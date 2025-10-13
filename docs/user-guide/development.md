# Application Development Environment

The application development environment on Cirrus is primarily
controlled through the *modules* environment. By loading and switching
modules you control the compilers, libraries and software available.

This means that for compiling on Cirrus you typically set the compiler
you wish to use using the appropriate modules, then load all the
required library modules (e.g. numerical libraries, IO format
libraries).

Additionally, if you are compiling parallel applications using MPI (or
SHMEM, etc.) then you will need to load one of the MPI environments and
use the appropriate compiler wrapper scripts.

By default, all users on Cirrus start with no modules loaded.

Basic usage of the `module` command on Cirrus is covered below. For full
documentation please see:

- [Linux manual page on modules](http://linux.die.net/man/1/module)

## Using the modules environment

### Information on the available modules

Finding out which modules (and hence which compilers, libraries and
software) are available on the system is performed using the
`module avail` command:

    [user@cirrus-login0 ~]$ module avail
    ...

This will list all the names and versions of the modules available on
the service. Not all of them may work in your account though due to, for
example, licencing restrictions. You will notice that for many modules
we have more than one version, each of which is identified by a version
number. One of these versions is the default. As the service develops
the default version will change.

You can list all the modules of a particular type by providing an
argument to the `module avail` command. For example, to list all
available versions of the Intel Compiler type:

    [user@cirrus-login0 ~]$ module avail intel-*/compilers

    --------------------------------- /work/y07/shared/cirrus-modulefiles --------------------------------
    intel-19.5/compilers  intel-20.4/compilers  

If you want more info on any of the modules, you can use the
`module help` command:

    [user@cirrus-login0 ~]$ module help mpt

    -------------------------------------------------------------------
    Module Specific Help for /usr/share/Modules/modulefiles/mpt/2.25:

    The HPE Message Passing Toolkit (MPT) is an optimized MPI
    implementation for HPE systems and clusters.  See the
    MPI(1) man page and the MPT User's Guide for more
    information.
    -------------------------------------------------------------------

The simple `module list` command will give the names of the modules and
their versions you have presently loaded in your environment, e.g.:

    [user@cirrus-login0 ~]$ module list
    Currently Loaded Modulefiles:
    1) git/2.35.1(default)                                  
    2) epcc/utils
    2) /mnt/lustre/e1000/home/y07/shared/cirrus-modulefiles/epcc/setup-env 

### Loading, unloading and swapping modules

To load a module to use `module add` or `module load`. For example, to
load the intel 20.4 compilers into the development environment:

    module load intel-20.4/compilers

This will load the default version of the intel compilers.

If a module loading file cannot be accessed within 10 seconds, a warning
message will appear: `Warning: Module system not loaded`.

If you want to clean up, `module remove` will remove a loaded module:

    module remove intel-20.4/compilers

You could also run `module rm intel-20.4/compilers` or `module unload intel-20.4/compilers`.
There are many situations in which you might want to change the
presently loaded version to a different one, such as trying the latest
version which is not yet the default or using a legacy version to keep
compatibility with old data. This can be achieved most easily by using
"module swap oldmodule newmodule".

Suppose you have loaded version 19 of the Intel compilers; the following
command will change to version 20:

    module swap intel-19.5/compilers intel-20.4/compilers

## Available Compiler Suites


!!! Note


    As Cirrus uses dynamic linking by default you will generally also need to load any modules you used to compile your code in your job submission script when you run your code.



### Intel Compiler Suite

The Intel compiler suite is accessed by loading the `intel-*/compilers`
module, where `*` references the version. For example, to load the v20
release, you would run:

    module load intel-20.4/compilers

Once you have loaded the module, the compilers are available as:

- `ifort` - Fortran
- `icc` - C
- `icpc` - C++

See the extended section below for further details of available Intel
compiler versions and tools.

### GCC Compiler Suite

The GCC compiler suite is accessed by loading the `gcc/*` modules, where
`*` again is the version. For example, to load version 10.2.0 you would
run:

    module load gcc/10.2.0

Once you have loaded the module, the compilers are available as:

- `gfortran` - Fortran
- `gcc` - C
- `g++` - C++

## Compiling MPI codes

MPI on Cirrus is currently provided by the HPE MPT library.

You should also consult the chapter on running jobs through the batch
system for examples of how to run jobs compiled against MPI.



!!! Note

    By default, all compilers produce dynamic executables on Cirrus. This   means that you must load the same modules at runtime (usually in your job submission script) as you have loaded at compile time.




### Using HPE MPT

To compile MPI code with HPE MPT, using any compiler, you must first
load the "mpt" module.

    module load mpt

This makes the compiler wrapper scripts `mpicc`, `mpicxx` and `mpif90`
available to you.

What you do next depends on which compiler (Intel or GCC) you wish to
use to compile your code.


!!! Note

    We recommend that you use the Intel compiler wherever possible to compile MPI applications as this is the method officially supported and tested by HPE.



!!! Note

    You can always check which compiler the MPI compiler wrapper scripts are using with, for example, `mpicc -v` or `mpif90 -v`.



#### Using Intel Compilers and HPE MPT

Once you have loaded the MPT module you should next load the Intel
compilers module you intend to use (e.g. `intel-20.4/compilers`):

    module load intel-20.4/compilers

The compiler wrappers are then available as

- `mpif90` - Fortran with MPI
- `mpicc -cc=icc` - C with MPI
- `mpicxx --cxx=icpc` - C++ with MPI

The MPT C/C++ compiler wrappers use GCC by default rather than the Intel compilers hence the additional options in the commands above. When compiling C applications you must also specify that `mpicc` should use the `icc` compiler with, for example, `mpicc -cc=icc`. Similarly, when compiling C++ applications you must also specify that `mpicxx` should use the `icpc` compiler with, for example, `mpicxx -cxx=icpc`. (This is not required for Fortran as the `mpif90` compiler automatically uses `ifort`.) If in doubt use `mpicc -cc=icc -v` or `mpicxx -cxx=icpc -v` to see which compiler is actually being called.

Alternatively, you can set the environment variables `MPICC_CC=icc` and/or `MPICXX=icpc` to ensure the correct base compiler is used:

```
export MPICC_CC=icc
export MPICXX_CXX=icpc
```

When the environment variables are set, you can use `mpicc` or `mpicxx` without needing additional options.


#### Using GCC Compilers and HPE MPT

Once you have loaded the MPT module you should next load the `gcc`
module:

    module load gcc

Compilers are then available as

- `mpif90` - Fortran with MPI
- `mpicc` - C with MPI
- `mpicxx` - C++ with MPI



!!! Note

    HPE MPT does not support the syntax `use mpi` in Fortran applications with the GCC compiler `gfortran`. You should use the older `include "mpif.h"` syntax when using GCC compilers with `mpif90`. If you cannot change this, then use the Intel compilers with MPT.



### Using Intel MPI

Although HPE MPT remains the default MPI library and we recommend that
first attempts at building code follow that route, you may also choose
to use Intel MPI if you wish. To use these, load the appropriate
MPI module, for example `intel-20.4/mpi`:

    module load intel-20.4/mpi

Please note that the name of the wrappers to use when compiling with
Intel MPI depends on whether you are using the Intel compilers or GCC.
You should make sure that you or any tools use the correct ones when
building software.



!!! Note

    Although Intel MPI is available on Cirrus, HPE MPT remains the recommended and default MPI library to use when building applications.



#### Using Intel Compilers and Intel MPI

After first loading Intel MPI, you should next load the appropriate
Intel compilers module (e.g. `intel-20.4/compilers`):

    module load intel-20.4/compilers

You may then use the following MPI compiler wrappers:

- `mpiifort` - Fortran with MPI
- `mpiicc` - C with MPI
- `mpiicpc` - C++ with MPI

#### Using GCC Compilers and Intel MPI

After loading Intel MPI, you should next load the `gcc` module you wish
to use:

    module load gcc

You may then use these MPI compiler wrappers:

- `mpif90` - Fortran with MPI
- `mpicc` - C with MPI
- `mpicxx` - C++ with MPI


### Using OpenMPI

There are a number of OpenMPI modules available on Cirrus; these can be listed
by running `module avail openmpi`.

[Build instructions for OpenMPI 4.1.6 on Cirrus](https://github.com/hpc-uk/build-instructions/blob/main/libs/openmpi/build_openmpi_4.1.6_cirrus_gcc10.md)

OpenMPI modules for use on the CPU nodes are also available, but these are not
expected to provide any performance advantage over HPE MPT or Intel MPI.


## Compiler Information and Options

The manual pages for the different compiler suites are available:

GCC  
Fortran `man gfortran` , C/C++ `man gcc`

Intel  
Fortran `man ifort` , C/C++ `man icc`

### Useful compiler options

Whilst difference codes will benefit from compiler optimisations in
different ways, for reasonable performance on Cirrus, at least
initially, we suggest the following compiler options:

Intel  
`-O2`

GNU  
`-O2 -ftree-vectorize -funroll-loops -ffast-math`

When you have a application that you are happy is working correctly and
has reasonable performance you may wish to investigate some more
aggressive compiler optimisations. Below is a list of some further
optimisations that you can try on your application (Note: these
optimisations may result in incorrect output for programs that depend on
an exact implementation of IEEE or ISO rules/specifications for math
functions):

Intel  
`-fast`

GNU  
`-Ofast -funroll-loops`

Vectorisation, which is one of the important compiler optimisations for
Cirrus, is enabled by default as follows:

Intel  
At `-O2` and above

GNU  
At `-O3` and above or when using `-ftree-vectorize`

To promote integer and real variables from four to eight byte precision
for Fortran codes the following compiler flags can be used:

Intel  
`-real-size 64 -integer-size 64 -xAVX` (Sometimes the Intel compiler
incorrectly generates AVX2 instructions if the `-real-size 64` or `-r8`
options are set. Using the `-xAVX` option prevents this.)

GNU  
`-freal-4-real-8 -finteger-4-integer-8`

## Using static linking/libraries

By default, executables on Cirrus are built using shared/dynamic
libraries (that is, libraries which are loaded at run-time as and when
needed by the application) when using the wrapper scripts.

An application compiled this way to use shared/dynamic libraries will
use the default version of the library installed on the system (just
like any other Linux executable), even if the system modules were set
differently at compile time. This means that the application may
potentially be using slightly different object code each time the
application runs as the defaults may change. This is usually the desired
behaviour for many applications as any fixes or improvements to the
default linked libraries are used without having to recompile the
application, however some users may feel this is not the desired
behaviour for their applications.

Alternatively, applications can be compiled to use static libraries
(i.e. all of the object code of referenced libraries are contained in
the executable file). This has the advantage that once an executable is
created, whenever it is run in the future, it will always use the same
object code (within the limit of changing runtime environment). However,
executables compiled with static libraries have the potential
disadvantage that when multiple instances are running simultaneously
multiple copies of the libraries used are held in memory. This can lead
to large amounts of memory being used to hold the executable and not
application data.

To create an application that uses static libraries you must pass an
extra flag during compilation, `-Bstatic`.

Use the UNIX command `ldd exe_file` to check whether you are using an
executable that depends on shared libraries. This utility will also
report the shared libraries this executable will use if it has been
dynamically linked.

## Intel modules and tools

There are a number of different Intel compiler versions available, and
there is also a slight difference in the way different versions appear.

A full list is available via `module avail intel`.

The different available compiler versions are:

- `intel-19.5/*` Intel 2019 Update 5
- `intel-20.4/*` Intel 2020 Update 4

We recommend the most up-to-date version in the first instance, unless
you have particular reasons for preferring an older version.

For a note on Intel compiler version numbers, see this [Intel
page](https://software.intel.com/content/www/us/en/develop/articles/intel-compiler-and-composer-update-version-numbers-to-compiler-version-number-mapping.html)

The different module names (or parts thereof) indicate:

- `cc` C/C++ compilers only
- `cmkl` MKL libraries (see Software Libraries section)
- `compilers` Both C/C++ and Fortran compilers
- `fc` Fortran compiler only
- `itac` Intel Trace Analyze and Collector
- `mpi` Intel MPI
- `pxse` Intel Parallel Studio (all Intel modules)
- `tbb` Thread Building Blocks
- `vtune` VTune profiler - note that in older versions
  (`intel-*/18.0.5.274`, `intel-*/19.0.0.117` VTune is launched as
  `amplxe-gui` for GUI or `amplxe-cl` for CLI use)
