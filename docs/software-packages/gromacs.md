# GROMACS

[GROMACS](http://www.gromacs.org/) is a versatile package to
perform molecular dynamics, i.e. simulate the Newtonian equations of
motion for systems with hundreds to millions of particles. It is
primarily designed for biochemical molecules like proteins, lipids and
nucleic acids that have a lot of complicated bonded interactions, but
since GROMACS is extremely fast at calculating the nonbonded
interactions (that usually dominate simulations) many groups are also
using it for research on non-biological systems, e.g. polymers.

## Useful Links

- [GROMACS User Guides](https://manual.gromacs.org/documentation/)
- [GROMACS Tutorials](https://tutorials.gromacs.org/)

## Using GROMACS on Cirrus

GROMACS is Open Source software and is freely available to all Cirrus
users. The central installation supports the single-precision version
of GROMACS compiled with MPI and OpenMP support.


GROMACS is installed centrally on Cirrus as a module via Spack. To
obtain information on which versions are available use, e.g.,
```
module avail gromacs
...
   gromacs/2025.2 (D)
```
The `gmx_mpi` binary is available after loading a `gromacs` module.
To see details of the build one can use, e.g.,
```
module load gromacs
gmx_mpi -version
```
This should show that GROMACS is compiled with the GNU Compiler Collection,
along with other compile-time information.


## Running GROMACS jobs

GROMACS can use full nodes in parallel (with the `--exclusive` option
to `sbatch`) for larger problem sizes, or run in parallel (or even serial)
on a subset of the  cores on a node if the problem size is smaller.

For general information on running SLURM jobs, see
[Running jobs on Cirrus](../user-guide/batch.md).

### Example: an exclusive GROMACS job

The following script will run a GROMACS MD job using 2
nodes (576 cores) with MPI only (`OMP_NUM_THREADS=1`).

??? info "Exclusive SLURM job submission for GROMACS (MPI)"
    ```{.yaml .copy}
    #!/bin/bash

    #SBATCH --time=00:20:00
    #SBATCH --export=none

    #SBATCH --exclusive
    #SBATCH --nodes=2
    #SBATCH --ntasks-per-node=288
    #SBATCH --cpus-per-task=1

    #SBATCH --partition=standard
    #SBATCH --qos=short

    #SBATCH --distribution=block:block
    #SBATCH --hint=nomultithread

    module load PrgEnv-gnu
    module load gromacs

    export OMP_NUM_THREADS=1

    srun gmx_mpi mdrun -s problem-initial-condition.tpr
    ```

### Example: a hybrid MPI/OpenMP job

The following SLURM submission will run a GROMACS MD job using 2 nodes
with 48 MPI processes per node (96 MPI processes in total),
and 6 OpenMP threads per MPI process (576 cores in total). Gromacs
typically recommends between 1 and 8 OpenMP threads per MPI process.

??? info "Exclusive SLURM job submission for GROMACS (hybrid OpenMP/MPI)"
    ```{.yaml .copy}
    #!/bin/bash

    #SBATCH --time=00:20:00
    #SBATCH --export=none

    #SBATCH --exclusive
    #SBATCH --nodes=2
    #SBATCH --ntasks-per-node=48
    #SBATCH --cpus-per-task=6

    #SBATCH --partition=standard
    #SBATCH --qos=short

    #SBATCH --distribution=block:block
    #SBATCH --hint=nomultithread

    module load PrgEnv-gnu
    module load gromacs

    export OMP_NUM_THREADS=6
    export OMP_PLACES=cores

    srun gmx_mpi mdrun -s problem-initial-condition.tpr
    ```

### Example: a non-exclusive job

GROMACS can run on a subset of cores in a node. The following script will
run a GROMACS MD job using 36 cores on a single node.

??? info "Non-exclusive SLURM job submission for GROMACS (MPI)"
    ```{.yaml .copy}
    #!/bin/bash

    #SBATCH --time=00:20:00
    #SBATCH --export=none

    #SBATCH --ntasks=36
    #SBATCH --cpus-per-task=1

    #SBATCH --partition=standard
    #SBATCH --qos=short

    #SBATCH --distribution=block:block
    #SBATCH --hint=nomultithread

    module load PrgEnv-gnu
    module load gromacs

    export OMP_NUM_THREADS=1

    srun gmx_mpi mdrun -s problem-initial-condition.tpr
    ```

You may need to add a budget code to the above examples
```
#SBATCH --account=<code>
```
using the relevant project budget code.

### Warning message

The warning message
```
[CRAYBLAS_WARNING] Application linked against multiple cray-libsci libraries
```
may appear in the standard error channel when running the centrally installed
version. The warning is benign and may be ignored.


## Compiling Gromacs

If you require a version of GROMACS which is not available via a central
module, other versions may be installed via Spack. For information us, e.g.,
```
module load spack
spack info gromacs
```
See using [Spack on Cirrus](../software-tools/spack.md) for further
information on Spack.
