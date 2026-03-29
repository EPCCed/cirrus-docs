# Profiling using Scalasca

Scalasca is installed on Cirrus, which is an open source performance
profiling tool. Two versions are provided, using GCC 8.2.0 and the Intel
19 compilers; both use the HPE MPT library to provide MPI and SHMEM. An
important distinction is that the GCC+MPT installation cannot be used to
profile Fortran code as MPT does not provide GCC Fortran module files.
To profile Fortran code, please use the Intel+MPT installation.

Loading the one of the modules will autoload the correct compiler and
MPI library:

    module load scalasca/2.6-gcc8-mpt225

or

    module load scalasca/2.6-intel19-mpt225

Once loaded, the profiler may be run with the `scalasca` or `scan`
commands, but the code must first be compiled first with the Score-P
instrumentation wrapper tool. This is done by prepending the compilation
commands with `scorep`, e.g.:

    scorep mpicc -c main.c -o main
    scorep mpif90 -openmp main.f90 -o main

Advanced users may also wish to make use of the Score-P API. This allows
you to manually define function and region entry and exit points.

You can then profile the execution during a Slurm job by prepending your
`srun` commands with one of the equivalent commands `scalasca -analyze`
or `scan -s`:

    scalasca -analyze srun ./main
    scan -s srun ./main

You will see some output from Scalasca to stdout during the run.
Included in that output will be the name of an experiment archive
directory, starting with *scorep\_*, which will be created in the
working directory. If you want, you can set the name of the directory by
exporting the `SCOREP_EXPERIMENT_DIRECTORY` environment variable in your
job script.

There is an associated GUI called Cube which can be used to process and
examine the experiment results, allowing you to understand your code's
performance. This has been made available via a Singularity container.
To start it, run the command `cube` followed by the file in the
experiment archive directory ending in *.cubex* (or alternatively the
whole archive), as seen below:

    cube scorep_exp_1/profile.cubex

The Scalasca quick reference guide found
[here](https://apps.fz-juelich.de/scalasca/releases/scalasca/2.6/docs/QuickReference.pdf)
provides a good overview of the toolset's use, from instrumentation and
use of the API to analysis with Cube.
