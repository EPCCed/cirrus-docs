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

The `gmx_mpi` binary is available after loading a `gromacs` module.

## Running parallel GROMACS jobs

GROMACS can use full nodes in parallel (with the `--exclusive` option
to `sbatch`) or run in parallel (or even serial) on a subset of the 
cores on a node. GROMACS can make use of both distributed memory
parallelism (via MPI) and shared memory parallelism via OpenMP.

### Example: pure MPI using multiple nodes

GROMACS can exploit multiple nodes on Cirrus.

For example, the following script will run a GROMACS MD job using 2
nodes (576 cores) with pure MPI.

```bash
#!/bin/bash --login

# Slurm job options (name, compute nodes, job time)
#SBATCH --job-name=gmx_test
#SBATCH --nodes=2
#SBATCH --tasks-per-node=288
#SBATCH --cpus-per-task=1
#SBATCH --time=0:25:0
# Make sure you are not sharing nodes with other users
#SBATCH --exclusive

# Replace [budget code] below with your project code (e.g. t01)
#SBATCH --account=[budget code]
# Replace [partition name] below with your partition name (e.g. standard)
#SBATCH --partition=[partition name]
# Replace [qos name] below with your qos name (e.g. standard,long)
#SBATCH --qos=[qos name]

# Load GROMACS module
module load gromacs

export OMP_NUM_THREADS=1 
export SRUN_CPUS_PER_TASK=$SLURM_CPUS_PER_TASK

# Run using input in test_calc.tpr
srun --hint=nomultithread --distribution=block:block gmx_mpi mdrun -s test_calc.tpr
```

### Example: hybrid MPI/OpenMP across multiple nodes

The following script will run a GROMACS MD job using 2 nodes (576 cores)
with 24 MPI processes per node (48 MPI processes in total), one per CCD and 12 OpenMP
threads per MPI process.

```bash
#!/bin/bash --login

# Slurm job options (name, compute nodes, job time)
#SBATCH --job-name=gmx_test
#SBATCH --nodes=2
#SBATCH --tasks-per-node=24
#SBATCH --cpus-per-task=12
#SBATCH --time=0:25:0
# Make sure you are not sharing nodes with other users
#SBATCH --exclusive

# Replace [budget code] below with your project code (e.g. t01)
#SBATCH --account=[budget code]
# Replace [partition name] below with your partition name (e.g. standard)
#SBATCH --partition=[partition name]
# Replace [qos name] below with your qos name (e.g. standard,long)
#SBATCH --qos=[qos name]

# Load GROMACS module
module load gromacs

# Propagate --cpus-per-task to srun
export OMP_NUM_THREADS=${SLURM_CPUS_PER_TASK}
export OMP_PLACES=cores
export SRUN_CPUS_PER_TASK=${SLURM_CPUS_PER_TASK}

# Run using input in test_calc.tpr
srun --hint=nomultithread --distribution=block:block gmx_mpi mdrun -s test_calc.tpr
```

### Example: pure MPI using a subset of a node

GROMACS can run on a subset of cores in a node (potentially sharing a 
node with other users)

For example, the following script will run a GROMACS MD job using 36
cores ona single node with pure MPI.

```bash
#!/bin/bash --login

# Slurm job options (name, compute nodes, job time)
#SBATCH --job-name=gmx_test
#SBATCH --nodes=1
#SBATCH --tasks-per-node=36
#SBATCH --cpus-per-task=1
#SBATCH --time=0:25:0

# Replace [budget code] below with your project code (e.g. t01)
#SBATCH --account=[budget code]
# Replace [partition name] below with your partition name (e.g. standard)
#SBATCH --partition=[partition name]
# Replace [qos name] below with your qos name (e.g. standard,long)
#SBATCH --qos=[qos name]

# Load GROMACS module
module load gromacs

export OMP_NUM_THREADS=1 
export SRUN_CPUS_PER_TASK=$SLURM_CPUS_PER_TASK

# Run using input in test_calc.tpr
srun --hint=nomultithread --distribution=block:block gmx_mpi mdrun -s test_calc.tpr
```