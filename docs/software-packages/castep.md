# CASTEP

[CASTEP](http://www.castep.org) is a leading code for calculating the
properties of materials from first principles. Using density functional
theory, it can simulate a wide range of properties of materials
proprieties including energetics, structure at the atomic level,
vibrational properties, electronic response properties etc. In
particular it has a wide range of spectroscopic features that link
directly to experiment, such as infra-red and Raman spectroscopies, NMR,
and core level spectra.

## Useful Links

- [CASTEP Documentation and Tutorials](https://castep-docs.github.io/castep-docs/)
- [CASTEP Licensing](https://www.castep.org/get_castep)

## Using CASTEP on Cirrus

**CASTEP is only available to users who have a valid CASTEP licence.**

If you have a CASTEP licence and wish to have access to CASTEP on Cirrus
please [submit a request through the
SAFE](https://epcced.github.io/safe-docs/safe-for-users/#how-to-request-access-to-a-package-group-licensed-software-or-restricted-features).

## Running parallel CASTEP jobs

CASTEP can exploit multiple nodes on Cirrus and can be run on a subset
of cores on a node or across multiple nodes (with exclusive node access).

### Example: multi-core CASTEP job 

For example, the following script will run a CASTEP job using 36 cores on a 
single node.

```slurm
#!/bin/bash

# Slurm job options (name, compute nodes, job time)
#SBATCH --job-name=CASTEP_Example
#SBATCH --time=1:0:0
#SBATCH --exclusive
#SBATCH --nodes=1
#SBATCH --tasks-per-node=36
#SBATCH --cpus-per-task=1

# Replace [budget code] below with your project code (e.g. t01)
#SBATCH --account=[budget code]
# Replace [partition name] below with your partition name (e.g. standard)
#SBATCH --partition=[partition name]
# Replace [qos name] below with your qos name (e.g. standard,long)
#SBATCH --qos=[qos name]

# Load CASTEP module
module load castep

# Set OMP_NUM_THREADS=1 to avoid unintentional threading
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
export OMP_PLACES=cores
export SRUN_CPUS_PER_TASK=$SLURM_CPUS_PER_TASK

# Run using input in test_calc.in
srun --distribution=block:block castep.mpi test_calc
```

### Example: multi-node CASTEP job

For example, the following script will run a CASTEP job using 2 nodes
(576 cores).

```slurm
#!/bin/bash

# Slurm job options (name, compute nodes, job time)
#SBATCH --job-name=CASTEP_Example
#SBATCH --time=1:0:0
#SBATCH --exclusive
#SBATCH --nodes=1
#SBATCH --tasks-per-node=288
#SBATCH --cpus-per-task=1

# Replace [budget code] below with your project code (e.g. t01)
#SBATCH --account=[budget code]
# Replace [partition name] below with your partition name (e.g. standard)
#SBATCH --partition=[partition name]
# Replace [qos name] below with your qos name (e.g. standard,long)
#SBATCH --qos=[qos name]

# Load CASTEP module
module load castep

# Set OMP_NUM_THREADS=1 to avoid unintentional threading
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
export OMP_PLACES=cores
export SRUN_CPUS_PER_TASK=$SLURM_CPUS_PER_TASK

# Run using input in test_calc.in
srun --distribution=block:block castep.mpi test_calc
```
