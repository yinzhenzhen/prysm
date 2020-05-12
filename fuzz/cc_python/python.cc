// Adapted from https://github.com/sigp/beacon-fuzz (MIT License).
// For python API documentation see https://docs.python.org/3/c-api/index.html

#include <Python.h>
#include <fstream>
#include <iostream>
#include <optional>
#include <sstream>
#include <string.h>

#include "python.h"
#include "tools/cpp/runfiles/runfiles.h"

#if PY_MAJOR_VERSION < 3 || (PY_MAJOR_VERSION == 3 && PY_MINOR_VERSION < 7)
#warning "Only supported for Python >= 3.7"
#endif

using bazel::tools::cpp::runfiles::Runfiles;

// The required version of eth2spec to be installed.
const char* PYSPEC_VERSION = "0.11.2";

namespace fuzzing {

class Python::Impl {
  std::string code;

  PyObject *pFunc = nullptr;

  PyThreadState *thisInterpreter = nullptr;

public:
  Impl(const std::string &argv0, const std::filesystem::path &scriptPath,
       const bool bls_disabled) {
    Py_Initialize();
    PyObject *eth2spec = PyImport_ImportModule("eth2spec");
    if (!eth2spec) {
      std::cerr << "Missing eth2spec module. Is eth2spec installed?"
                << std::endl;
      abort();
    }
    // Check eth2spec version is correct.
    const char *version =
        PyUnicode_AsUTF8(PyObject_GetAttrString(eth2spec, "__version__"));
    if (strcmp(version, PYSPEC_VERSION) != 0) {
      std::cerr << "Wrong version of eth2spec installed. Wanted " << PYSPEC_VERSION
                << ", got " << version << "." << std::endl;
      abort();
    }

    std::string error;
    std::unique_ptr<Runfiles> runfiles(Runfiles::Create(argv0, &error));
    if (runfiles == nullptr) {
      std::cerr << "Failed to create runfiles" << std::endl;
      abort();
    }
    std::string path = runfiles->Rlocation(scriptPath);
    std::ifstream ifs(path.c_str(), std::ifstream::in);
    if (!ifs) {
      std::cerr << "Failed to open file " << path << std::endl;
      abort();
    }
    std::ostringstream ss;
    ifs >> ss.rdbuf();
    if (ifs.fail() && !ifs.eof()) {
      std::cerr << "Could not read file." << std::endl;
      abort();
    }

    PyObject *pValue, *pModule, *pLocal;

    pModule = PyModule_New("fuzzermod");
    PyModule_AddStringConstant(pModule, "__file__", "");
    pLocal = PyModule_GetDict(pModule);
    pValue = PyRun_String(ss.str().c_str(), Py_file_input, pLocal, pLocal);
    if (pValue == nullptr) {
      std::cerr << "Fatal: Cannot create Python function from string"
                << std::endl;
      PyErr_Print();
      abort();
    }
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
      abort();
    }
    pValue = PyObject_CallObject(initFun, pArgs);
    if (pValue == nullptr) {
      // FuzzerInit() raised an exception
      std::cerr << "Fatal: FuzzerInit failed." << std::endl;
      PyErr_Print();
      abort();
    }
    // Don't care about the value returned
    Py_DECREF(pValue);
    Py_DECREF(pArgs);
    Py_DECREF(initFun);

    PyObject *pFunc = PyObject_GetAttrString(pModule, "FuzzerRunOne");

    if (pFunc == nullptr || !PyCallable_Check(static_cast<PyObject *>(pFunc))) {
      printf("Fatal: FuzzerRunOne not defined or not callable\n");
      abort();
    }
  }

  std::optional<std::vector<uint8_t>> Run(const std::vector<uint8_t> &data) {
    std::optional<std::vector<uint8_t>> ret = std::nullopt;

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
    // swap to our interpreter, don't care about previous interpreter
    // TODO(gnattishness) quicker to not swap if already at our interpreter?
    (void)PyThreadState_Swap(thisInterpreter);

    PyObject *pArgs = PyTuple_New(1);
    PyObject *pValue =
        PyBytes_FromStringAndSize((const char *)data.data(), data.size());
    if (pValue == nullptr) {
      printf("Fatal: Unable to save data as bytes\n");
      PyErr_Print();
      abort();
    }
    // NOTE: this pValue does not need to be DECREFed because PyTuple_SetItem
    // steals the reference
    int err = PyTuple_SetItem(pArgs, 0, pValue);
    if (err) {
      printf("Fatal: Unable to add bytes to a tuple.\n");
      PyErr_Print();
      abort();
    }

    pValue = PyObject_CallObject(pFunc, pArgs);

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
      abort();
    }

    if (PyBytes_Check(pValue)) {
      /* Retrieve output */

      uint8_t *output;
      Py_ssize_t outputSize;
      if (PyBytes_AsStringAndSize(pValue, reinterpret_cast<char **>(&output),
                                  &outputSize) != -1) {
        /* Return output */
        ret.emplace(output, output + outputSize);
        // TODO(gnattishness) N isn't this goto irrelevant?
        goto end;
      } else {
        printf(
            "Fatal: Returning Python bytes failed - this should not happen.\n");
        abort();
      }

    } else if (pValue != Py_None) {
      printf("Fatal: unexpected return type. Should return a bytes or None");
      abort();
    }
    // We returned None

  end:
    Py_DECREF(pValue);
    Py_DECREF(pArgs);
    return ret;
  }

  ~Impl(void) { Py_Finalize(); }
};

Python::Python(const std::string &name, const std::string &argv0,
               const std::filesystem::path &scriptPath, const bool bls_disabled)
    : Runnable(), pImpl_{
                      std::make_unique<Impl>(argv0, scriptPath, bls_disabled)} {
  name_ = name;
}

std::optional<std::vector<uint8_t>>
Python::Run(const std::vector<uint8_t> &data) {
  return pImpl_->Run(data);
}

const std::string &Python::name() { return this->name_; }

Python::~Python() = default;
} // namespace fuzzing