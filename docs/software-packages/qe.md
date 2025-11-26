# Quantum Espresso (QE)

[Quantum Espresso](http://www.quantum-espresso.org/) is an integrated
suite of Open-Source computer codes for electronic-structure
calculations and materials modeling at the nanoscale. It is based on
density-functional theory, plane waves, and pseudopotentials.

## Useful Links

- [QE User Guides](https://www.quantum-espresso.org/Doc/user_guide/)
- [QE Tutorials](http://www.quantum-espresso.org/tutorials/)

## Using QE on Cirrus

QE is Open Source software and is freely available to all Cirrus users.

## Running parallel QE jobs

Quantum Espresso can exploit multiple nodes on Cirrus or can be run on a subset
of cores on a node.

!!! note
    You must load the `PrgEnv-gnu` module before the `quantum-espresso` module
    is available to load.

### Example: multi-core QE job 

For example, the following script will run a QE job using 36 cores on a single 
node (which may be shared with other users/jobs).

```slurm
#!/bin/bash
#
# Slurm job options (name, compute nodes, job time)
#SBATCH --job-name=pw_test
#SBATCH --nodes=2
#SBATCH --tasks-per-node=36
#SBATCH --cpus-per-task=1
#SBATCH --time=0:20:0

# Replace [budget code] below with your project code (e.g. t01)
#SBATCH --account=[budget code]
# Replace [partition name] below with your partition name (e.g. standard)
#SBATCH --partition=[partition name]
# Replace [qos name] below with your qos name (e.g. standard,long)
#SBATCH --qos=[qos name]

module load PrgEnv-gnu
module load quantum-espresso

export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
export OMP_PLACES=cores
export SRUN_CPUS_PER_TASK=SBATCH_CPUS_PER_TASK

# Run using input in test_calc.in
srun --hint=nomultithread --distribution=block:block pw.x -i test_cals.in
```

### Example: multi-node QE job 

For example, the following script will run a QE job using 2 nodes
(576 cores).

```slurm
#!/bin/bash
#
# Slurm job options (name, compute nodes, job time)
#SBATCH --job-name=pw_test
#SBATCH --nodes=2
#SBATCH --tasks-per-node=288
#SBATCH --cpus-per-task=1
#SBATCH --time=0:20:0
# Make sure you are not sharing nodes with other users
#SBATCH --exclusive

# Replace [budget code] below with your project code (e.g. t01)
#SBATCH --account=[budget code]
# Replace [partition name] below with your partition name (e.g. standard)
#SBATCH --partition=[partition name]
# Replace [qos name] below with your qos name (e.g. standard,long)
#SBATCH --qos=[qos name]

module load PrgEnv-gnu
module load quantum-espresso

export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
export OMP_PLACES=cores
export SRUN_CPUS_PER_TASK=SBATCH_CPUS_PER_TASK

# Run using input in test_calc.in
srun --hint=nomultithread --distribution=block:block pw.x -i test_cals.in
```
