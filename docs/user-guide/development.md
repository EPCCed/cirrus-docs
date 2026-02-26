# Application development environment

## What's available

Cirrus runs the RHEL 9,
and provides a development environment which includes:

  - Software modules via a standard module framework
  - Four different compiler environments (AMD, Cray, Intel and GNU)
  - MPI, OpenMP, and SHMEM
  - Scientific and numerical libraries
  - Parallel Python and R
  - Parallel debugging and profiling
  - Apptainer container software

Access to particular software, and particular versions, is managed by an 
Lmod module framework. Most software is available by loading modules,
including the different compiler environments

You can see what compiler environments are available with:

```bash
[auser@uan01:~]$ module avail PrgEnv

-------------------------------------- /opt/cray/pe/lmod/modulefiles/core ---------------------------------------
   PrgEnv-aocc/8.6.0    PrgEnv-cray/8.6.0    PrgEnv-gnu/8.6.0 (L)    PrgEnv-intel/8.6.0

  Where:
   L:  Module is loaded

Module defaults are chosen based on Find First Rules due to Name/Version/Version modules found in the module tree.
See https://lmod.readthedocs.io/en/latest/060_locating.html for details.

If the avail list is too long consider trying:

"module --default avail" or "ml -d av" to just list the default modules.
"module overview" or "ml ov" to display the number of modules for each name.

Use "module spider" to find all possible modules and extensions.
Use "module keyword key1 key2 ..." to search for all possible modules matching any of the "keys".

```

Other software modules can be searched using the `module spider` command:

``` 
[auser@uan01:~]$ module spider

--------------------------------------------------------------------------------------------------------------
The following is a list of the modules and extensions currently available:
--------------------------------------------------------------------------------------------------------------
  PrgEnv-aocc: PrgEnv-aocc/8.6.0

  PrgEnv-cray: PrgEnv-cray/8.6.0

  PrgEnv-gnu: PrgEnv-gnu/8.6.0

  PrgEnv-intel: PrgEnv-intel/8.6.0

  aocc: aocc/5.0.0

  aocc-mixed: aocc-mixed/5.0.0

  atp: atp/3.15.6

  castep: castep/24.1

  cce: cce/19.0.0

  cce-mixed: cce-mixed/19.0.0

  cmake: cmake/4.1.2

  cp2k: cp2k/2025.1

  cpe: cpe/25.03

  cray-R: cray-R/4.4.0

  cray-ccdb: cray-ccdb/5.0.6

  cray-cti: cray-cti/2.19.1

  cray-dsmml: cray-dsmml/0.3.1

  cray-dyninst: cray-dyninst/12.3.5

  cray-fftw: cray-fftw/3.3.10.10

...output trimmed...


```

A full discussion of the module system is available in
[the software environment section](sw-environment.md).

A consistent set of modules is loaded on login to the machine (currently
`PrgEnv-cray`, see below). Developing applications then means selecting
and loading the appropriate set of modules before starting work.

This section is aimed at code developers and will concentrate on the
compilation environment, building libraries and executables,
specifically parallel executables. Other topics such as [Python](python.md) and
[Containers](containers.md) are covered in more detail in separate sections of the
documentation.

!!! tip
    If you want to get back to the login module state without having to logout
    and back in again, you can use:

    ```
    module restore
    ```

    This is also handy for build scripts to ensure you are starting from a known
    state.

## Compiler environments

There are four different compiler environments available on Cirrus:

- AMD Compiler Collection (AOCC)
- GNU Compiler Collection (GCC)
- Intel oneAPI (Intel)
- HPE Cray Compiler Collection (CCE) (current default compiler environment)

The current compiler suite is selected via the
`PrgEnv` module , while the specific compiler versions are
determined by the relevant compiler module. A summary is:

| Suite name | Compiler Environment Module | Compiler Version Module |
| ---------- | --------------------------- | ----------------------- |
| CCE        | `PrgEnv-cray`               | `cce`                   |
| GCC        | `PrgEnv-gnu`                | `gcc-native`            |
| Intel      | `PrgEnv-intel`              | `intel`                 |
| AOCC       | `PrgEnv-aocc`               | `aocc`                  |

For example, at login, the default set of modules are:

``` 
[user@login03:~]$ module list

Currently Loaded Modules:
  1) craype-x86-turin         5) xpmem/0.2.119-1.3_gef379be13330   9) cray-dsmml/0.3.1     13) epcc-setup-env
  2) libfabric/1.22.0         6) cce/19.0.0                       10) cray-mpich/8.1.32    14) load-epcc-module
  3) craype-network-ofi       7) cse_env/0.2                      11) cray-libsci/25.03.0
  4) perftools-base/25.03.0   8) craype/2.7.34                    12) PrgEnv-cray/8.6.0

 
```

from which we see the default compiler environment is Cray (indicated
by `PrgEnv-cray` (at 11 in the list above) and the default compiler module
is `cce/19.0.0` (at 6 in the list above). The compiler environment
will give access to a consistent set of compiler, MPI library via
`cray-mpich` (at 9), and other libraries e.g., `cray-libsci` (at 10 in
the list above).

### Switching between compiler environments

Switching between different compiler environments is achieved using the
`module load` command. For example, to switch from the default HPE Cray
(CCE) compiler environment to the GCC environment, you would use:

```
[auser@ln03:~]$ module load PrgEnv-gnu

Lmod is automatically replacing "cce/19.0.0" with "gcc-native/14.2".


Lmod is automatically replacing "PrgEnv-cray/8.6.0" with "PrgEnv-gnu/8.6.0".


Due to MODULEPATH changes, the following have been reloaded:
  1) cray-libsci/25.03.0     2) cray-mpich/8.1.32


```

If you then use the `module list` command, you will see that your environment
has been changed to the GCC environment:

```
[auser@ln03:~]$ module list

Currently Loaded Modules:
  1) craype-x86-turin         5) xpmem/0.2.119-1.3_gef379be13330   9) gcc-native/14.2    13) cray-libsci/25.03.0
  2) libfabric/1.22.0         6) cse_env/0.2                      10) craype/2.7.34      14) PrgEnv-gnu/8.6.0
  3) craype-network-ofi       7) epcc-setup-env                   11) cray-dsmml/0.3.1
  4) perftools-base/25.03.0   8) load-epcc-module                 12) cray-mpich/8.1.32
```

### Switching between compiler versions

Within a given compiler environment, it is possible to swap to a
different compiler version by swapping the relevant compiler module.
To switch to the GNU compiler environment from the default HPE Cray compiler
environment and than swap the version of GCC from the 11.2.0 default to 
the older 10.3.0 version, you would use

```
[auser@ln03:~]$ module load PrgEnv-gnu

Lmod is automatically replacing "cce/19.0.0" with "gcc-native/14.2".


Lmod is automatically replacing "PrgEnv-cray/8.6.0" with "PrgEnv-gnu/8.6.0".


Due to MODULEPATH changes, the following have been reloaded:
  1) cray-libsci/25.03.0     2) cray-mpich/8.1.32

auser@ln03:~> module load gcc-native/13.3

The following have been reloaded with a version change:
  1) gcc-native/14.2 => gcc-native/13.3

```

The first swap command moves to the GNU compiler environment and the second
swap command moves to the older version of GCC. As before, `module list`
will show that your environment has been changed:

```
[auser@ln03:~]$ module list

Currently Loaded Modules:
  1) craype-x86-turin         5) xpmem/0.2.119-1.3_gef379be13330   9) cray-dsmml/0.3.1  13) cray-mpich/8.1.32
  2) libfabric/1.22.0         6) cse_env/0.2                      10) PrgEnv-gnu/8.6.0  14) cray-libsci/25.03.0
  3) craype-network-ofi       7) epcc-setup-env                   11) craype/2.7.34
  4) perftools-base/25.03.0   8) load-epcc-module                 12) gcc-native/13.3


```

### Compiler wrapper scripts: `cc`, `CC`, `ftn`

To ensure consistent behaviour, compilation of C, C++, and Fortran
source code should then take place using the appropriate compiler
wrapper: `cc`, `CC`, and `ftn`, respectively. The wrapper will
automatically call the relevant underlying compiler and add the
appropriate include directories and library locations to the invocation.
This typically eliminates the need to specify this additional
information explicitly in the configuration stage. To see the details of
the exact compiler invocation use the `-craype-verbose` flag to the
compiler wrapper.

The default link time behaviour is also related to the current
programming environment. See the section below on [Linking and
libraries](#linking-and-libraries).

Users should not, in general, invoke specific compilers at compile/link
stages. In particular, `gcc`, which may default to `/usr/bin/gcc`,
should not be used. The compiler wrappers `cc`, `CC`, and `ftn` should
be used (with the underlying compiler type and version set by the
module system). Other common MPI compiler wrappers
e.g., `mpicc`, should also be replaced by the relevant wrapper, e.g. `cc`
(commands such as `mpicc` are not available on Cirrus).

!!! important
    Always use the compiler wrappers `cc`, `CC`, and/or `ftn` and not a
    specific compiler invocation. This will ensure consistent compile/link
    time behaviour.


!!! tip
    If you are using a build system such as Make or CMake then you 
    will need to replace all occurrences of `mpicc` with `cc`,
    `mpicxx`/`mpic++` with `CC` and `mpif90` with `ftn`.

### Compiler man pages and help

Further information on both the compiler wrappers, and the individual
compilers themselves are available via the command line, and via
standard `man` pages. The `man` page for the compiler wrappers is common
to all programming environments, while the `man` page for individual
compilers depends on the currently loaded programming environment. The
following table summarises options for obtaining information on the
compiler and compile options:

| Compiler suite | C            | C++           | Fortran        |
| -------------- | ------------ | ------------- | -------------- |
| Cray           | `man clang`  | `man clang++` | `man crayftn`  |
| GNU            | `man gcc`    | `man g++`     | `man gfortran` |
| Intel          | `man icx`    | `man icpx`    | `man ifx`      |
| Wrappers       | `man cc`     | `man CC`      | `man ftn`      |

!!! tip
    You can also pass the `--help` option to any of the compilers or
    wrappers to get a summary of how to use them. The Cray Fortran
    compiler uses `ftn --craype-help` to access the help options.

!!! tip
    There are no `man` pages for the AOCC compilers at the moment.

!!! tip
    Cray C/C++ is based on Clang and therefore
    supports similar options to clang/gcc. `clang --help` will produce a full summary
    of options with Cray-specific options marked "Cray". The `clang` man
    page on ARCHER2 concentrates on these Cray extensions to the `clang` front end and
    does not provide an exhaustive description of all `clang` options.
    Cray Fortran **is not** based on Flang and so takes different options
    from flang/gfortran.

### Which compiler environment?

If you are unsure which compiler you should choose, we suggest the
starting point should be the GNU compiler collection (GCC,
`PrgEnv-gnu`); this is perhaps the most commonly used by code
developers, particularly in the open source software domain. A portable,
standard-conforming code should (in principle) compile in any of the
three compiler environments.

For users requiring specific compiler features, such as coarray
Fortran, the recommended starting point would be Cray. The following
sections provide further details of the different compiler
environments.

### GNU compiler collection (GCC)

The commonly used open source GNU compiler collection is available and
provides C/C++ and Fortran compilers.

Switch to the GCC compiler environment via:

```
[auser@ln03:~]$ module load PrgEnv-gnu

Lmod is automatically replacing "cce/19.0.0" with "gcc-native/14.2".


Lmod is automatically replacing "PrgEnv-cray/8.6.0" with "PrgEnv-gnu/8.6.0".


Due to MODULEPATH changes, the following have been reloaded:
  1) cray-libsci/25.03.0     2) cray-mpich/8.1.32

```

!!! warning
    If you want to use GCC version 10 or greater to compile Fortran code,
    with the old MPI interfaces (i.e. `use mpi` or `INCLUDE 'mpif.h'`) you
    **must** add the `-fallow-argument-mismatch` option (or equivalent) when compiling
    otherwise you will see compile errors associated with MPI functions.
    The reason for this is that past versions of `gfortran` have allowed
    mismatched arguments to external procedures (e.g., where an explicit
    interface is not available). This is often the case for MPI routines
    using the old MPI interfaces where arrays of different types are passed
    to, for example, `MPI_Send()`. This will now generate an error as not
    standard conforming. The `-fallow-argument-mismatch` option is used
    to reduce the error to a warning. The same effect may be achieved via
    `-std=legacy`.

    If you use the Fortran 2008 MPI interface (i.e. `use mpi_f08`) then you
    should not need to add this option.

    Fortran language MPI bindings are described in more detail at
    in [the MPI Standard documentation](https://www.mpi-forum.org/docs/mpi-3.1/mpi31-report/node408.htm).

#### Useful Gnu Fortran options

| Option | Comment |  
| ------ | ------- |
| `-O<level>` | Optimisation levels: `-O0`, `-O1`, `-O2`, `-O3`, `-Ofast`. `-Ofast` is not recommended without careful regression testing on numerical output. |
| `-std=<standard>` |	Default is gnu |
| `-fallow-argument-mismatch` | Allow mismatched procedure arguments. This argument is required for compiling MPI Fortran code with GCC version 10 or greater if you are using the older MPI interfaces (see warning above) |
| `-fbounds-check` | Use runtime checking of array indices |
| `-fopenmp` | Compile OpenMP (default is no OpenMP) |
| `-v` | Display verbose output from compiler stages |

!!! tip
    The `standard` in `-std` may be one of `f95` `f2003`, `f2008` or
    `f2018`. The default option `-std=gnu` is the latest Fortran standard
    plus gnu extensions.

!!! warning
    Past versions of `gfortran` have allowed mismatched arguments to
    external procedures (e.g., where an explicit interface is not
    available). This is often the case for MPI routines where arrays of
    different types are passed to `MPI_Send()` and so on. This will now
    generate an error as not standard conforming. Use
    `-fallow-argument-mismatch` to reduce the error to a warning. The same
    effect may be achieved via `-std=legacy`.

#### Reference material

  - [C/C++ documentation](https://gcc.gnu.org/onlinedocs/gcc-14.3.0/gcc/)
  - [Fortran documentation](https://gcc.gnu.org/onlinedocs/gcc-14.3.0/gfortran/)

### Cray Compiling Environment (CCE)

The Cray Compiling Environment (CCE) is the default compiler at the point
of login. CCE supports C/C++ (along with unified parallel C UPC), and
Fortran (including co-array Fortran). Support for OpenMP parallelism is
available for both C/C++ and Fortran (currently OpenMP 4.5, with a
number of exceptions).

The Cray C/C++ compiler is based on a clang front end, and so compiler
options are similar to those for gcc/clang. However, the Fortran
compiler remains based around Cray-specific options. Be sure to separate
C/C++ compiler options and Fortran compiler options (typically `CFLAGS`
and `FFLAGS`) if compiling mixed C/Fortran applications.

As CCE is the default compiler environment on Cirrus, you do not usually
need to issue any commands to enable CCE.

#### Useful CCE C/C++ options

When using the compiler wrappers `cc` or `CC`, some of the following
options may be
useful:

Language, warning, Debugging options:

| Option | Comment |  
| ------ | ------- |
| `-std=<standard>` | Default is `-std=gnu11` (`gnu++14` for C++) \[1\] |

Performance options:

| Option | Comment |  
| ------ | ------- |
| `-Ofast` | Optimisation levels: `-O0`, `-O1`, `-O2`, `-O3`, `-Ofast`. `-Ofast` is not recommended without careful regression testing on numerical output.           |
| `-ffp=level` | Floating point maths optimisations levels 0-4 \[2\]    |
| `-flto` | Link time optimisation                                      |

Miscellaneous options:

| Option | Comment |  
| ------ | ------- |
| `-fopenmp` | Compile OpenMP (default is off)                          |
| `-v` | Display verbose output from compiler stages                    |

!!! notes
    1.  Option `-std=gnu11` gives `c11` plus GNU extensions (likewise
        `c++14` plus GNU extensions). See
        <https://gcc.gnu.org/onlinedocs/gcc-4.8.2/gcc/C-Extensions.html>
    2.  Option `-ffp=3` is implied by `-Ofast` or `-ffast-math`

#### Useful CCE Fortran options

Language, Warning, Debugging options:

| Option | Comment |  
| ------ | ------- |
| `-m <level>` | Message level (default `-m 3` errors and warnings) |

Performance options:

| Option | Comment |  
| ------ | ------- |
| `-O <level>` | Optimisation levels: -O0 to -O3 (default -O2)      |
| `-h fp<level>` | Floating point maths optimisations levels 0-3    |
| `-h ipa` | Inter-procedural analysis                              |

Miscellaneous options:

| Option | Comment |  
| ------ | ------- |
| `-h omp` | Compile OpenMP (default is `-hnoomp`)                  |
| `-v` | Display verbose output from compiler stages                |

##### CMake projects

When building a project using `CMake` it may fail due to a change in the submodule naming convention, a potential solution to this is to add
```
set(CMAKE_Fortran_SUBMODULE_SEP ".")
set(CMAKE_Fortran_SUBMODULE_EXT ".smod")
```
in your CMake script.

#### CCE Reference Documentation

* [Clang/Clang++ documentation](https://clang.llvm.org/docs/UsersManual.html), CCE-specific 
  details are available via `man clang` once the CCE compiler environment is loaded.
* [Cray Fortran documentation](https://internal.support.hpe.com/hpesc/public/docDisplay?docId=dp00005037en_us&docLocale=en_US)

### Intel compilers (oneAPI)

Intel oneAPI provides C/C++ compiers, Fortran compilers and other
libraries and tools.

Switch to the Intel compiler environment via:

```
[auser@ln03:~]$ module load PrgEnv-intel

Lmod is automatically replacing "cce/19.0.0" with "intel/2023.2".


Lmod is automatically replacing "PrgEnv-cray/8.6.0" with "PrgEnv-intel/8.6.0".


Due to MODULEPATH changes, the following have been reloaded:
  1) cray-libsci/25.03.0     2) cray-mpich/8.1.32

```

!!! warning
    The Intel compiler environment only provides the new LLVM based
    compilers (`icx`, `icpx` and `ifx`), the classic Intel compilers are not
    available.

#### Useful Intel Fortran (`ifx`) options

| Option | Comment |  
| ------ | ------- |
| `-O<level>` | Optimisation levels: `-O0`, `-O1`, `-O2`, `-O3`, `-Ofast`. `-Ofast` is not recommended without careful regression testing on numerical output. |
| `-std=<standard>` |	Default is gnu |
| `-fbounds-check` | Use runtime checking of array indices |
| `-fopenmp` | Compile OpenMP (default is no OpenMP) |
| `-v` | Display verbose output from compiler stages |

#### Reference material

  - [oneAPI documentation library](https://www.intel.com/content/www/us/en/developer/tools/oneapi/documentation-library.html)

### AMD Optimizing Compiler Collection (AOCC)

The AMD Optimizing Compiler Collection (AOCC) is a clang-based optimising
compiler. AOCC also includes a flang-based Fortran compiler.

Load the AOCC compiler environment from the default CCE (cray)
compiler environment via:

```
[auser@ln03:~]$ module load PrgEnv-aocc

Lmod is automatically replacing "cce/19.0.0" with "aocc/4.1".


Lmod is automatically replacing "PrgEnv-cray/8.6.0" with "PrgEnv-gnu/8.6.0".


Due to MODULEPATH changes, the following have been reloaded:
  1) cray-libsci/25.03.0     2) cray-mpich/8.1.32

```

#### AOCC reference material

  - [AOCC on AMD website](https://developer.amd.com/amd-aocc/)


## Message passing interface (MPI)

### HPE Cray MPICH

HPE Cray provide, as standard, an MPICH implementation of the message
passing interface which is specifically optimised for the Slingshot
interconnect. The current implementation supports MPI standard version 3.4.

The HPE Cray MPICH implementation is linked into software by default when
compiling using the standard wrapper scripts: `cc`, `CC` and `ftn`.

You do not need to do anything to make HPE Cray MPICH available when you
log into Cirrus, it is available by default to all users.

#### MPI reference material

- [MPI standard documents](https://www.mpi-forum.org/docs/)

## Linking and libraries

Linking to libraries is performed dynamically on Cirrus.

!!! important
    Static linking is not supported on Cirrus. If you attempt to link statically,
    you will see errors similar to:
    ```
    /usr/bin/ld: cannot find -lpmi
    /usr/bin/ld: cannot find -lpmi2
    collect2: error: ld returned 1 exit status
    ```

One can use the `-craype-verbose` flag to the compiler wrapper to check exactly what
linker arguments are invoked. The compiler wrapper scripts encode the
paths to the programming environment system libraries using RUNPATH.
This ensures that the executable can find the correct runtime
libraries without the matching software modules loaded.

!!! tip
    The RUNPATH setting in the executable only works for default versions
    of libraries. If you want to use non-default versions then you need
    to add some additional commands at compile time and in your job submission
    scripts. See the [Using non-default versions of HPE Cray libraries on Cirrus](#using-non-default-versions-of-hpe-cray-libraries).


The library RUNPATH associated with an executable can be inspected via,
e.g.,

    $ readelf -d ./a.out

(swap `a.out` for the name of the executable you are querying).

### Commonly used libraries

Modules with names prefixed by `cray-` are provided by HPE Cray, and work
with any of the compiler environments and. These modules should be the
first choice for access to software libraries if available.

!!! tip
    More information on the different software libraries on Cirrus can
    be found in the Software libraries section of the documentation.

## HPE Cray Programming Environment (CPE) releases

### Available HPE Cray Programming Environment (CPE) releases

Cirrus currently has the following HPE Cray Programming Environment (CPE) releases available:

- **25.09: Current default**

<!-- Not relevant at the moment as there is only one PE 
                                                        
### Switching to a different HPE Cray Programming Environment (CPE) release

!!! important
    See the section below on using non-default versions of HPE Cray libraries
    as this process will generally need to be followed when using software
    from non-default PE installs.

Access to non-default PE environments is controlled by the use of the `cpe` modules.
Loading a `cpe` module will do the following:

- The compiler version will be switched to the one from the selected PE
- All HPE Cray PE modules will be updated so their default version is the
  one from the PE you have selected

For example, if you have a code that uses the Gnu compiler environment, FFTW and
NetCDF parallel libraries and you want to compile in the (non-default and older)
22.12 programming environment, you would do the following:

First, load the `cpe/22.12` module to switch all the defaults to the versions from
the 22.12 PE. Then, swap to the GNU compiler environment and load the required library
modules (FFTW, hdf5-parallel and NetCDF HDF5 parallel). The loaded module list shows they 
are the versions from the 22.12 PE:


```bash
module load cpe/22.12
```

Output:
```output

The following have been reloaded with a version change:
  1) PrgEnv-cray/8.4.0 => PrgEnv-cray/8.3.3             4) cray-mpich/8.1.27 => cray-mpich/8.1.23
  2) cce/16.0.1 => cce/15.0.0                           5) craype/2.7.23 => craype/2.7.19
  3) cray-libsci/23.09.1.1 => cray-libsci/22.12.1.1     6) perftools-base/23.09.0 => perftools-base/22.12.0
```

```bash
module load PrgEnv-gnu
```
Output:
```output
Lmod is automatically replacing "cce/15.0.0" with "gcc/11.2.0".


Lmod is automatically replacing "PrgEnv-cray/8.3.3" with "PrgEnv-gnu/8.3.3".


Due to MODULEPATH changes, the following have been reloaded:
  1) cray-mpich/8.1.23

```

```bash
module load cray-fftw
module load cray-hdf5-parallel
module load cray-netcdf-hdf5parallel
module list
```

Output:
```output
Currently Loaded Modules:
  1) craype-x86-rome               7) load-epcc-module        13) cray-mpich/8.1.23
  2) libfabric/1.12.1.2.2.0.0      8) perftools-base/22.12.0  14) cray-libsci/22.12.1.1
  3) craype-network-ofi            9) cpe/22.12               15) PrgEnv-gnu/8.3.3
  4) xpmem/0.2.119-1.3_0_gnoinfo  10) gcc/11.2.0              16) cray-fftw/3.3.10.5
  5) bolt/0.8                     11) craype/2.7.19           17) cray-hdf5-parallel/1.12.2.1
  6) epcc-setup-env               12) cray-dsmml/0.2.2        18) cray-netcdf-hdf5parallel/4.9.0.1

```

Now you can go ahead and compile your software with the new programming
environment.


!!! important
    The `cpe` modules only change the versions of software modules provided
    as part of the HPE Cray programming environments. Any modules provided
    by the Cirrus service will need to be loaded manually after you have
    completed the process described above.
    
!!! note
    Unloading the `cpe` module does not restore the original programming environment
    release. To restore the default programming environment release you should log 
    out and then log back in to Cirrus.

-->

## Using non-default versions of HPE Cray libraries

If you wish to make use of non-default versions of libraries provided by HPE
Cray (usually because they are part of a non-default PE release: either old
or new) then you need to make changes at *both* compile and runtime. In summary,
you need to load the correct module and also make changes to the `LD_LIBRARY_PATH`
environment variable.

**At compile time** you need to load the version of the library module before you compile
*and* set the LD_LIBRARY_PATH environment variable to include the contencts of
`$CRAY_LD_LIBRARY_PATH` as the first entry. For example, to use the, non-default, newer 9.0.0
version of HPE Cray MPICH in the default programming environment (Cray Compiler Environment,
CCE) you would first setup the environment to compile with:

```bash
module load cray-mpich/9.0.0
export LD_LIBRARY_PATH=$CRAY_LD_LIBRARY_PATH:$LD_LIBRARY_PATH
```

The order is important here: every time you change a module, you will need to reset
the value of `LD_LIBRARY_PATH` for the process to work (it will not be updated
automatically).

Now you can compile your code. You can check that the executable is using the correct version 
of LibSci with the `ldd` command and look for the line beginning `libmpi*`, you
should see the version in the path to the library file.

!!! tip
    If any of the libraries point to versions in the `/opt/cray/pe/lib64` directory
    then these are using the default versions of the libraries rather than the 
    specific versions. This happens at compile time if you have forgotton to load 
    the right module and set `$LD_LIBRARY_PATH` afterwards.

**At run time** (typically in your job script) you need to repeat the environment
setup steps (you can also use the `ldd` command in your job submission script to 
check the library is pointing to the correct version). For example, a job submission
script to run an executable with the non-default version of Cray MPICH could
look like:

```slurm
#!/bin/bash
#SBATCH --job-name=test
#SBATCH --time=0:20:0
#SBATCH --exclusive
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=288
#SBATCH --cpus-per-task=1

# Replace the account code, partition and QoS with those you wish to use
#SBATCH --account=t01        
#SBATCH --partition=standard
#SBATCH --qos=short

# Setup up the environment to use the non-default version of LibSci
module load cray-mpich/9.0.0
export LD_LIBRARY_PATH=$CRAY_LD_LIBRARY_PATH:$LD_LIBRARY_PATH

# Check which library versions the executable is pointing too
ldd /path/to/myapp.x

export OMP_NUM_THREADS=1

srun --hint=nomultithread --distribution=block:block /path/to/myapp.x
```

!!! tip
    As when compiling, the order of commands matters. Setting the value of
    `LD_LIBRARY_PATH` must happen after you have finished all your `module`
    commands for it to have the correct effect.

!!! important
    You must setup the environment at both compile and run time otherwise
    you will end up using the default version of the library.

## Compiling on compute nodes

Sometimes you may wish to compile in a batch job. For example, the compile process may take a long
time or the compile process is part of the research workflow and can be coupled to the production job.
Unlike login nodes, the `/home` file system is not available.

An example job submission script for a compile job using `make` (assuming the Makefile is in the same
directory as the job submission script) would be:

```
#!/bin/bash

#SBATCH --job-name=compile
#SBATCH --time=00:20:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1

# Replace the account code, partition and QoS with those you wish to use
#SBATCH --account=t01        
#SBATCH --partition=standard
#SBATCH --qos=standard


make clean

make
```

!!! note
    If you want to use a compiler environment other than the default then
    you will need to add the `module load` command before the `make` command.
    e.g. to use the GCC compiler environemnt:
    
    ```
    module load PrgEnv-gnu
    ```

You can also use a compute node in an interactive way using `salloc`. Please see
Section [Using salloc to reserve resources](batch.md#using-salloc-with-srun)
for further details. Once your interactive session is ready, you can load the compilation environment and compile the code.

## Using the compiler wrappers for serial compilations

The compiler wrappers link with a number of HPE-provided libraries automatically. 
It is possible to compile codes in serial with the compiler wrappers to take 
advantage of the HPE libraries.

To set up your environment for serial compilation, you will need to run:

```bash
  module load craype-network-none
  module remove cray-mpich
```

Once this is done, you can use the compiler wrappers (`cc` for C, `CC` for 
C++, and `ftn` for Fortran) to compile your code in serial.

## Managing development

Cirrus supports common revision control software such as `git`.

Standard GNU autoconf tools are available, along with `make` (which is
GNU Make). Versions of `cmake` are available.

!!! tip
    Some of these tools are part of the system software, and
    typically reside in `/usr/bin`, while others are provided as part of the
    module system. Some tools may be available in different versions via
    both `/usr/bin` and via the module system. If you find the default
    version is too old, then look in the module system for a more recent
    version.

## Build instructions for software on Cirrus

The Cirrus CSE team at [EPCC](https://www.epcc.ed.ac.uk) and other contributors
provide build configurations ando instructions for a range of research
software, software libraries and tools on a variety of HPC systems (including
ARCHER2) in a public Github repository. See:

   - [Build instructions repository](https://www.github.com/HPC-UK/build-instructions)

The repository always welcomes contributions from the Cirrus user community.

## Support for building software on Cirrus

If you run into issues building software on Cirrus or the software you
require is not available then please contact the
[Cirrus Service Desk](https://www.cirrus.ac.uk/support-access/servicedesk.html)
with any questions you have.
