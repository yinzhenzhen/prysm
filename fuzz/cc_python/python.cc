#include <Python.h>
#include <fstream>
#include <iostream>
#include <sstream>

#include "python.h"
#include "tools/cpp/runfiles/runfiles.h"

#if PY_MAJOR_VERSION < 3 || (PY_MAJOR_VERSION == 3 && PY_MINOR_VERSION < 7)
#warning "Only supported for Python >= 3.7"
#endif

using bazel::tools::cpp::runfiles::Runfiles;

// The required version of eth2spec to be installed.
const char *PYSPEC_VERSION = "0.11.2";

namespace fuzzing {

std::string loadScript(const std::filesystem::path &scriptPath) {
  std::string error;
  std::unique_ptr<Runfiles> runfiles(Runfiles::Create("", &error));
  if (runfiles == nullptr) {
    std::cerr << "Failed to create runfiles" << std::endl;
    throw; // TODO
  }
  std::string path = runfiles->Rlocation(scriptPath);
  std::ifstream ifs(path.c_str(), std::ifstream::in);
  if (!ifs) {
    std::cerr << "Failed to open file " << path << std::endl;
    throw; // TODO
  }
  std::ostringstream ss;
  ifs >> ss.rdbuf();
  if (ifs.fail() && !ifs.eof()) {
    std::cerr << "Could not read file." << std::endl;
    throw; // TODO
  }

  return ss.str();
}

PyObject *createPyFuzzModule(const std::string code) {
  PyObject *pValue, *pModule, *pLocal;

  pModule = PyModule_New("fuzzermod");
  PyModule_AddStringConstant(pModule, "__file__", "");
  pLocal = PyModule_GetDict(pModule);
  pValue = PyRun_String(code.c_str(), Py_file_input, pLocal, pLocal);
  if (pValue == nullptr) {
    std::cerr << "Fatal: Cannot create Python function from string"
              << std::endl;
    PyErr_Print();
    throw; // TODO
  }

  // Clean up references.
  Py_DECREF(pValue);
  Py_DECREF(pLocal);

  return pModule;
}

void initializePyFuzzModule(PyObject *pModule, bool bls_disabled) {
  PyObject *initFun = PyObject_GetAttrString(pModule, "FuzzerInit");
  if (initFun == nullptr ||
      !PyCallable_Check(static_cast<PyObject *>(initFun))) {
    std::cerr << "Fatal: FuzzerInit not defined or not callable" << std::endl;
    abort();
  }
  PyObject *pArgs = PyTuple_New(1);
  int err = PyTuple_SetItem(pArgs, 0, PyBool_FromLong(bls_disabled));
  if (err) {
    std::cerr << "Fatal: Unable to add bool to init args tuple." << std::endl;
    PyErr_Print();
    throw; // TODO
  }
  auto pValue = PyObject_CallObject(initFun, pArgs);
  if (pValue == nullptr) {
    // FuzzerInit() raised an exception
    std::cerr << "Fatal: FuzzerInit failed." << std::endl;
    PyErr_Print();
    throw; // TODO
  }

  // Discard return values.
  Py_DECREF(pValue);
  Py_DECREF(pArgs);
  Py_DECREF(initFun);
}

Python::Python(const std::filesystem::path &scriptPath, bool bls_disabled) {
  Py_Initialize();
  PyObject *eth2spec = PyImport_ImportModule("eth2spec");
  if (!eth2spec) {
    std::cerr << "Missing eth2spec module. Is eth2spec installed?" << std::endl;
    throw; // TODO
  }
  // Ensure eth2spec version is correct.
  const char *version =
      PyUnicode_AsUTF8(PyObject_GetAttrString(eth2spec, "__version__"));
  if (strcmp(version, PYSPEC_VERSION) != 0) {
    std::cerr << "Wrong version of eth2spec installed. Wanted "
              << PYSPEC_VERSION << ", got " << version << "." << std::endl;
    throw; // TODO
  }

  auto code = loadScript(scriptPath);
  auto module = createPyFuzzModule(code);
  initializePyFuzzModule(module, bls_disabled);

  pFuzzRunOne = PyObject_GetAttrString(module, "FuzzerRunOne");

  if (pFuzzRunOne == nullptr ||
      !PyCallable_Check(static_cast<PyObject *>(pFuzzRunOne))) {
    printf("Fatal: FuzzerRunOne not defined or not callable\n");
    throw; // TODO
  }
}

std::optional<std::vector<uint8_t>>
Python::Run(const std::vector<uint8_t> &data) {
  std::optional<std::vector<uint8_t>> ret = std::nullopt;
  auto pState = PyThreadState_Get();
  PyThreadState_Swap(pState);

  if (data.empty()) {
    // Ensure data is not empty. Otherwise:
    //
    // "If size() is 0, data() may or may not return a null pointer."
    // https://en.cppreference.com/w/cpp/container/vector/data
    //
    // if nullptr, the pValue contains uninitialized data:
    // "If v is NULL, the contents of the bytes object are uninitialized."
    // https://docs.python.org/3/c-api/bytes.html?highlight=pybytes_check#c.PyBytes_FromStringAndSize
    // NOTE: this assumes empty input is never valid
    return ret;
  }

  PyObject *pArgs = PyTuple_New(1);
  PyObject *pValue =
      PyBytes_FromStringAndSize((const char *)data.data(), data.size());
  if (pValue == nullptr) {
    printf("Fatal: Unable to save data as bytes\n");
    PyErr_Print();
    throw; // TODO
  }
  // NOTE: this pValue does not need to be DECREFed because PyTuple_SetItem
  // steals the reference
  int err = PyTuple_SetItem(pArgs, 0, pValue);
  if (err) {
    printf("Fatal: Unable to add bytes to a tuple.\n");
    PyErr_Print();
    throw; // TODO
  }

  pValue = PyObject_CallObject(pFuzzRunOne, pArgs);

  if (pValue == nullptr) {
    // Abort on unhandled exception.
    // Indicates an error in the Python code.
    // E.g. Eth2 Py spec only specifies behaviour for AssertionError and
    // IndexError
    // https://github.com/ethereum/eth2.0-specs/blob/dev/specs/core/0_beacon-chain.md#beacon-chain-state-transition-function
    //
    // Any expected exceptions that indicate failure (but not a bug) should be
    // caught by the target function, and None returned.
    PyErr_Print();
    throw; // TODO
  }

  if (PyBytes_Check(pValue)) {
    /* Retrieve output */

    uint8_t *output;
    Py_ssize_t outputSize;
    if (PyBytes_AsStringAndSize(pValue, reinterpret_cast<char **>(&output),
                                &outputSize) != -1) {
      /* Return output */
      ret.emplace(output, output + outputSize);
    } else {
      printf(
          "Fatal: Returning Python bytes failed - this should not happen.\n");
      throw; // TODO
    }

  } else if (pValue != Py_None) {
    printf("Fatal: unexpected return type. Should return a bytes or None");
    throw; // TODO
  }

  Py_DECREF(pValue);
  Py_DECREF(pArgs);
  PyThreadState_Swap(pState);
  return ret;
}
} // namespace fuzzing
