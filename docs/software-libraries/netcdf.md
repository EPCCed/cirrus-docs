# NetCDF

The Network Common Data Form NetCDF
(and its parallel manifestation NetCDF parallel) is a standard library
and data format developed and supported by [UCAR](https://www.unidata.ucar.edu/software/netcdf/)
is released under a BSD-like license.

Both serial and parallel versions are available on Cirrus as
standard modules:

  + `module load cray-netcdf` (serial version)
  + `module load cray-netcdf-hdf5parallel` (MPI parallel version)

Note that one should first load the relevant HDF module file, e.g.,
```
$ module load cray-hdf5
$ module load cray-netcdf
```
for the serial version.

Use `module spider` to locate available versions, and use `module help` to
locate `cray-`specific release notes on a particular version.

## Resources

The NetCDF [home page](https://www.unidata.ucar.edu/software/netcdf/).
