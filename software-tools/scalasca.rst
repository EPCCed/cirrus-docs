Profiling using Scalasca
===========================

Scalasca is installed on Cirrus, which is an open source performance profiling tool.
It is built against the ``mpt`` MPI library and the ``openmpi`` SHMEM library, however 
requires both modules to be loaded as well as the ``gcc`` module.

::

    module load mpt 
    module load openmpi
    module load gcc/8.2.0
    module load scalasca/2.5 


The profiler is run with the ``scalasca`` command, however requires the code to be 
compiled first with the SCORE-P instrumentation wrapper tool. This is done by prepending 
compilation with ``scorep``:

::

    scorep mpicc -c main.c
    scorep mpif90 -openmp main.f90
    
Then the Scalasca profiling tool can be run using one of the following commands:

::

    scalasca -analyze mpiexec -np 4 main
    scan -s mpiexec -np 4 main


This will create a folder in the current directory starting  with *scorep_*.

There is also an associated GUI called Cube, which can be opened with the 
command ``cube`` and the file in the *scorep_* directory  ending in *.cubex* 
(or alternatively the whole archive), as seen below:

::

    cube scorep_exp_1/profile.cubex

There is also a  SCORE-P API which code can also be manually annotated with.

More information about Scalasca and its associated toolbox can be found `here <https://apps.fz-juelich.de/scalasca/releases/scalasca/2.3/docs/QuickReference.pdf>`__.  

