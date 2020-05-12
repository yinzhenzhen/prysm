#include <Python.h>
#include <string.h>
#include <iostream>
#include <fstream>
#include <sstream>
#include "tools/cpp/runfiles/runfiles.h"

using bazel::tools::cpp::runfiles::Runfiles;

// See https://docs.python.org/3/c-api/index.html
int main(int argc, char *argv[])
{
  Py_Initialize();
  PyObject *eth2spec = PyImport_ImportModule("eth2spec");
  if (!eth2spec)
  {
    std::cerr << "Missing eth2spec module. Is eth2spec installed?" << std::endl;
    return 1;
  }
  // Check eth2spec version is correct.
  const char* version = PyUnicode_AsUTF8(PyObject_GetAttrString(eth2spec, "__version__"));
  const char* want = "0.11.2";
  if(strcmp(version, want)!=0)
  {
    std::cerr << "Wrong version of eth2spec installed. Wanted " << want << ", got " << version << "." << std::endl;
    return 1;
  }

  // Read in python code!
  std::string error;
  std::unique_ptr<Runfiles> runfiles(Runfiles::Create(argv[0], &error));
  if (runfiles == nullptr) {
    std::cerr << "Failed to create runfiles" << std::endl;
    return 1;
  }
  std::string path = runfiles->Rlocation("prysm/fuzz/cc_python/example.py");
  std::ifstream ifs(path.c_str(), std::ifstream::in);
  if(!ifs)
  {
    std::cerr << "Failed to open file." << std::endl;
    return 1;
  }
  std::ostringstream ss;
  ifs >> ss.rdbuf();
  if (ifs.fail() && !ifs.eof())
  {
    std::cerr << "Could not read file." << std::endl;
    return 1;
  }
  std::cout << ss.str() << std::endl;

  Py_Finalize();
  return 0;
}