# HDF5

The Hierarchical Data Format HDF5
(and its parallel manifestation HDF5 parallel) is a standard library
and data format developed and supported by
[The HDF Group](https://www.hdfgroup.org/), and
is released under a BSD-like license.

Both serial and parallel versions are available on ACirrus as
standard modules:

  + `module load cray-hdf5` (serial version)
  + `module load cray-hdf5-parallel` (MPI parallel version)

Use `module help` to locate `cray-`specific release notes on a
particular version.

## Compiling applications against HDF5

If the appropriate programming environment and HDF5 modules are loaded,
compiling applications against the HDF5 libraries should straightforward.
You should use the compiler wrappers `cc`, `CC`, and/or `ftn`. See, e.g.,
`cc --cray-print-opts` for the full list of include paths and library
paths and options added by the compiler wrapper.


## Resources

The HDF5 support website includes [general documentation](https://support.hdfgroup.org/documentation/index.html).

For parallel HDF5, some [tutorials and presentations](https://support.hdfgroup.org/documentation/hdf5-docs/hdf5_topics/ParallelHDF5.html) are available.
