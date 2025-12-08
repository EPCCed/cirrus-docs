# LAMMPS

[LAMMPS](http://lammps.sandia.gov/) (large-scale atomic/molecular massively
parallel simulator) is a classical molecular dynamics
code developed by Sandia Laboratories in the United States. LAMMPS includes
potentials for solid-state materials (metals, semiconductors), soft
matter (biomolecules, polymers) and
coarse-grained or mesoscopic systems. It can be used to model atoms or,
more generically, as a parallel particle simulator at the atomic scale,
mesoscale, or continuum scale.

## Useful Links

- [LAMMPS Home Page](https://www.lammps.org/)
- [LAMMPS Documentation](https://docs.lammps.org/Manual.html)

## Using LAMMPS on Cirrus

LAMMPS is Open Source software, and is freely available to all Cirrus
users. Centrally installed versions are managed by
[Spack on Cirrus](../software-tools/spack.md).

To see what versions are available in the current programming environment:

```
  $ module avail lammps
...
   lammps/20250612
```
indicating the release version of 12th June 2025 is available. Centrally
installed versions are available in `PrgEnv-cray` and `PrgEnv-gnu`.

### Optional LAMMPS packages

The centrally installed module versions of LAMMPS have a limited standand
set of packages compiled. For the full configuration, try
```
$ module load lammps
$ lmp -h
...
Installed packages:

KSPACE MANYBODY MOLECULE RIGID
...
```
a list which includes available pair, bond, angle, etc, styles, and fix and
compute styles (which is omitted here for brevity).


## Running parallel LAMMPS jobs (MPI)

LAMMPS scales well for appropriate problem sizes and can make use of more
than one node.
For example, the following script will run a LAMMPS job using 2 nodes
(576 cores) with MPI in the Cray programming environment.

??? info "Exclusive SLURM job submission script for LAMMPS"
    ```{.yaml .copy}
    #!/bin/bash

    #SBATCH --export=none
    #SBATCH --time=00:20:00

    #SBATCH --nodes=2
    #SBATCH --exclusive

    #SBATCH --partition=standard
    #SBATCH --qos=standard

    #SBATCH --distribution=block:block
    #SBATCH --hint=nomultithread

    module load PrgEnv-cray
    module load lammps

    srun --ntasks=576 --ntasks-per-node=288 --cpus-per-task=1 lmp < in.test

    ```
    Here, SLURM is able to allocate resources by knowing 2 complete (exclusive)
    nodes are required.
    A relevant budget code may needed in the above script:
    ```
    #SBATCH --account=budget-code
    ```
    where an appropriate `budget-code` is needed.

### Non-exclusive jobs

Smaller problem sizes, requiring less than 288 cores (a full node), may be
run in non-exclusive mode. Such a job might require only 36 MPI tasks.

??? info "Non-exclusive SLURM submission script for LAMMPS"
    ```{.yaml .copy}
    #!/bin/bash

    #SBATCH --export=none
    #SBATCH --time=00:20:00

    #SBATCH --ntasks=36
    #SBATCH --cpus-per-task=1

    #SBATCH --partition=standard
    #SBATCH --qos=standard

    #SBATCH --distribution=block:block
    #SBATCH --hint=nomultithread

    module load PrgEnv-cray
    module load lammps

    srun lmp < in.test
    ```
    Here, SLURM is able to allocate resources by knowning that 36 tasks are
    required, and each task requires 1 core (`--cpus-per-task=1`). Again,
    a valid budget code may be required (see the previous example).

## Compiling LAMMPS on Cirrus

LAMMPS supports a significant number of optional standard packages, and also
provides a further large selection of unsupported ("USER") packages. If one
or more of these are required, and not provided by the central installation,
a separation compilation will be required.

### Using Spack

LAMMPS may be installed using Spack. For information on availability:
```
$ module load spack
$ spack info lammps
```
See [using Spack on Cirrus](../software-tools/spack.md) for further information
on Spack.

### Using CMake

LAMMPS offers developers a relatively simple and robust build mechanism
using CMake.

A standard LAMMPS CMake configuration for "most" packages might look like,
schematically:

```
module load PrgEnv-cray
module load cray-fftw
module load cray-python

cmake -C ../cmake/presets/most.cmake                                       \
      -D BUILD_MPI=on                                                      \
      -D BUILD_SHARED_LIBS=yes                                             \
      -D CMAKE_CXX_COMPILER=CC                                             \
      -D CMAKE_CXX_FLAGS="-O2"                                             \
      -D CMAKE_Fortran_COMPILER=ftn                                        \
      -D CMAKE_INSTALL_PREFIX=${prefix}                                    \
      ../cmake/
```
where the `${prefix}` environment variable is used to specify the location
of the installation. See
[Build LAMMPS with CMake](https://docs.lammps.org/Build_cmake.html) for
further information.
