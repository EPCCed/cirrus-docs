# OpenFOAM

OpenFOAM is an open-source toolbox for computational fluid dynamics.
OpenFOAM consists of generic tools to simulate complex physics for a
variety of fields of interest, from fluid flows involving chemical
reactions, turbulence and heat transfer, to solid dynamics,
electromagnetism and the pricing of financial options.

The core technology of OpenFOAM is a flexible set of modules written in
C++. These are used to build solvers and utilities to perform pre- and
post-processing tasks ranging from simple data manipulation to
visualisation and mesh processing.

## Useful links

OpenFOAM comes in two main flavours. The two main releases
are:

- [The OpenFOAM Foundation (openfoam.org)](https://openfoam.org/)
- [OpenFOAM(R) (openfoam.com)](https://www.openfoam.com/)

## Using OpenFOAM on Cirrus

Centrally installed versions of OpenFOAM are available on Cirrus. The
central installations are managed by Spack and can seen:
```
$ module avail openfoam
...
  openfoam-org/12    openfoam/2412
```
Modules named `openfoam-org` are related to The OpenFOAM Foundation, whose
versions have a numbering convention 11, 12, 13, etc, with a new major
version released once per year. Modules named `openfoam` relate to
OpenFOAM(R) and have a version convention YYMM so, e.g., 2412
was released in December 2024 (there are usually two releases per year
in June and December).

The central versions are managed with Spack and are compiled in
`PrgEnv-gnu`.


## Running OpenFOAM jobs (MPI)

While limited serial work (such as `blockMesh` and `decomposePar`) may be
run on the front end, parallel simulations should be submitted to SLURM.

Any SLURM script which intends to use OpenFOAM should first load the
appropriate OpenFOAM module. The module will automatically set
the relevant environment variables such as `FOAM_TUTORIALS` (see also the note
below on `WM_PROJECT_USER_DIR`).

You should be able to use OpenFOAM in the usual way.

### Example SLURM submissions

Larger OpenFOAM jobs should use an exclusive submission, e.g., for 2 nodes
running 288 MPI processes per node:

??? info "Exclusive SLURM job submission script for OpenFOAM (openfoam.com)"
    ```{.yaml .copy}
    #!/bin/bash

    #SBATCH --export=none
    #SBATCH --time=00:20:00

    #SBATCH --nodes=2
    #SBATCH --exclusive
    #SBATCH --ntasks-per-node=288
    #SBATCH --cpus-per-task=1

    #SBATCH --partition=standard
    #SBATCH --qos=standard

    #SBATCH --distribution=block:block
    #SBATCH --hint=nomultithread

    module load PrgEnv-gnu
    module load openfoam/2412

    # We should now have access to OpenFOAM executables

    srun --ntasks=576 icoFoam -parallel -fileHandler collated
    ```
    In this example, SLURM is able to allocate the appropriate resources
    by knowing that 2 nodes are required on an exclusive basis. The
    number of MPI processes per node is set via `--ntasks-per-node=228`
    and `--cpus-per-task=1` indicates that one core be used for each process.

    A relevant budget code may needed in the above script:
    ```
    #SBATCH --account=budget-code
    ```
    where an appropriate `budget-code` is needed.


Smaller OpenFOAM jobs (fewer than 288 cores) may wish to use a non-exclusive
submission:

??? info "None-exclusive SLURM job submission script for OpenFOAM (openfoam.org)"
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

    module load PrgEnv-gnu
    module load openfoam-org/12

    # We should now have access to OpenFOAM executables

    srun icoFoam -parallel -fileHandler collated
    ```
    In this example, SLURM is able to allocate appropriate resouves from
    the combination `--ntasks=36` and `--cpus-per-task=1`, ie., 36 cores.

    A relevant budget code may needed in the above script:
    ```
    #SBATCH --account=budget-code
    ```
    where an appropriate `budget-code` is needed.

See [Running Jobs on Cirrus](/user-guide/batch) for general information on
SLURM submissions.


### Efficient file handling for larger OpenFOAM jobs

By default, OpenFOAM will tend to read and write one file per MPI process.
As the number of MPI processes becomes large, this can lead to a very
large number of small files. The can put due pressure on the Lustre file
system, which favours smaller numbers of larger files. Worse, this can
cause contention and slow-dowms for all users accessing files on the
file system.

At a minimum, please consider using collated file operations when running
larger parallel jobs. This should give better I/O performance for all jobs.


See the relevant user guide for running applications in parallel:

- [Running applications in parallel](https://doc.cfd.direct/openfoam/user-guide-v13/running-applications-parallel) in OpenFOAM 13.
- [Section on Parallism](https://doc.openfoam.com/2312/tools/parallel/) for OpenFoam 2312.

## Compiling OpenFOAM on Cirrus


### General comments

Many packages extend the central OpenFOAM functionality in some way. However,
there is no completely standardised way in which this works. Some packages
assume they have write access to the main OpenFOAM installation. If this is
the case, you must install your own version before continuing. This
can be done on an individual basis, or a per-project basis using the
project shared directories.

Some packages are installed in the OpenFOAM user directory, by default this
may be set to, e.g.,
```
${HOME}/OpenFOAM/${USER}
```
Because user home directories are not available on the back end, this must be
changed to a location in `\work` before any useful simulations can carried
out.

If an extension to a central module is envisaged, set e.g.,
```
export WM_PROJECT_USER_DIR=${HOME/home/work}/OpenFOAM/${USER}
```
_after_ the relevant OpenFOAM module has been loaded.


### Using Spack

OpenFOAM versions may be installed via Spack. For information on availability:
```
$ module load spack
$ spack info openfoam
$ spack info openfoam-org
```

See [using Spack on Cirrus](/software-tools/spack) for further information
on Spack.
