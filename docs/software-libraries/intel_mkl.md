# Intel MKL: BLAS, LAPACK, ScaLAPACK

The Intel Maths Kernel Libraries (MKL) contain a variety of optimised
numerical libraries including BLAS, LAPACK, and ScaLAPACK. In general,
the exact commands required to build against MKL depend on the details
of compiler, environment, requirements for parallelism, and so on. The
Intel MKL link line advisor should be consulted.

See
<https://software.intel.com/content/www/us/en/develop/articles/intel-mkl-link-line-advisor.html>

Some examples are given below. Note that loading the appropriate intel
tools module will provide the environment variable
<span class="title-ref">MKLROOT</span> which holds the location of the
various MKL components.

## Intel Compilers

### BLAS and LAPACK

To use MKL libraries with the Intel compilers you just need to load the
relevant Intel compiler module, and the Intel `cmkl` module, e.g.:

    module load intel-20.4/fc
    module load intel-20.4/cmkl

To include MKL you specify the `-mkl` option on your compile and link
lines. For example, to compile a simple Fortran program with MKL you
could use:

    ifort -c -mkl -o lapack_prb.o lapack_prb.f90
    ifort -mkl -o lapack_prb.x lapack_prb.o

The `-mkl` flag without any options builds against the threaded version
of MKL. If you wish to build against the serial version of MKL, you
would use `-mkl=sequential`.

### ScaLAPACK

The distributed memory linear algebra routines in ScaLAPACK require MPI
in addition to the compiler and MKL libraries. Here we use Intel MPI
via:

    module load intel-20.4/fc
    module load intel-20.4/mpi
    module load intel-20.4/cmkl

ScaLAPACK requires the Intel versions of BLACS at link time in addition
to ScaLAPACK libraries; remember also to use the MPI versions of the
compilers:

    mpiifort -c -o linsolve.o linsolve.f90
    mpiifort -o linsolve.x linsolve.o -L${MKLROOT}/lib/intel64 \
    -lmkl_scalapack_lp64 -lmkl_intel_lp64 -lmkl_sequential -lmkl_core \
    -lmkl_blacs_intelmpi_lp64 -lpthread -lm -ldl

## GNU Compiler

### BLAS and LAPACK

To use MKL libraries with the GNU compiler you first need to load the
GNU compiler module and Intel MKL module, e.g.,:

    module load gcc
    module load intel-20.4/cmkl

To include MKL you need to link explicitly against the MKL libraries.
For example, to compile a single source file Fortran program with MKL
you could use:

    gfortran -c -o lapack_prb.o lapack_prb.f90
    gfortran -o lapack_prb.x lapack_prb.o -L$MKLROOT/lib/intel64 \
    -lmkl_gf_lp64 -lmkl_core -lmkl_sequential

This will build against the serial version of MKL; to build against the
threaded version use:

    gfortran -c -o lapack_prb.o lapack_prb.f90
    gfortran -fopenmp -o lapack_prb.x lapack_prb.o -L$MKLROOT/lib/intel64 \
    -lmkl_gf_lp64 -lmkl_core -lmkl_gnu_thread

### ScaLAPACK

The distributed memory linear algebra routines in ScaLAPACK require MPI
in addition to the MKL libraries. On Cirrus, this is usually provided by
SGI MPT.

    module load gcc
    module load mpt
    module load intel-20.4/cmkl

Once you have the modules loaded you need to link against two additional
libraries to include ScaLAPACK. Note we use here the relevant
`mkl_blacs_sgimpt_lp64` version of the BLACS library. Remember to use
the MPI versions of the compilers:

    mpif90 -f90=gfortran -c -o linsolve.o linsolve.f90
    mpif90 -f90=gfortran -o linsolve.x linsolve.o -L${MKLROOT}/lib/intel64 \
    -lmkl_scalapack_lp64 -lmkl_intel_lp64 -lmkl_sequential -lmkl_core \
    -lmkl_blacs_sgimpt_lp64 -lpthread -lm -ldl

### ILP vs LP interface layer

Many applications will use 32-bit (4-byte) integers. This means the MKL
32-bit integer interface should be selected (which gives the `_lp64`
extensions seen in the examples above).

For applications which require, e.g., very large array indices (greater
than 2^31-1 elements), the 64-bit integer interface is required. This
gives rise to `_ilp64` appended to library names. This may also require
`-DMKL_ILP64` at the compilation stage. Check the Intel link line
advisor for specific cases.
