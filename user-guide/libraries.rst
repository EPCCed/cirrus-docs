Software Libraries
==================

This section of the User Guide covers the use of different software libraries
on Cirrus.

Intel MKL: BLAS, LAPACK, ScaLAPACK
----------------------------------

The Intel MKL libraries contain a variety of optimised numerical libraries 
including BLAS, LAPACK, and ScaLAPACK.

Intel Compilers
~~~~~~~~~~~~~~~

BLAS and LAPACK
^^^^^^^^^^^^^^^

To use MKL libraries with the Intel compilers you first need to load the Intel
compiler module and the Intel tools module:

::

   module load intel-compilers-16
   module load intel-tools-16

To include MKL you specify the ``-mkl`` option on your compile and link lines.
For example, to compile a single source file, Fortran program with MKL you could use:

::

   ifort -c -mkl -o lapack_prb.o lapack_prb.f90
   ifort -mkl -o lapack_prb.x lapack_prb.o

The ``-mkl`` flag without any options builds against the threaded version of MKL.
If you wish to build against the serial version of MKL, you would use
``-mkl=sequential``.

ScaLAPACK
^^^^^^^^^

The distributed memory linear algebra routines in ScaLAPACK require MPI in addition
to the compilers and MKL libraries. On Cirrus, this is usually provided by SGI MPT.

::

   module load intel-compilers-16
   module load intel-tools-16
   module load mpt

Once you have the modules loaded you use the ``-mkl=cluster`` option to the compiler 
at compile and link time to include ScaLAPACK. Remember to use the MPI versions of
the compilers:

::

   mpif90 -c -mkl=cluster -o linsolve.o linsolve.f90
   mpif90 -mkl=cluster -o linsolve.x linsolve.o

