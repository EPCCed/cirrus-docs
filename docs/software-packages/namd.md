# NAMD

[NAMD](http://www.ks.uiuc.edu/Research/namd/), recipient of a 2002
Gordon Bell Award and a 2012 Sidney Fernbach Award, is a parallel
molecular dynamics code designed for high-performance simulation of
large biomolecular systems. Based on Charm++ parallel objects, NAMD
scales to hundreds of cores for typical simulations and beyond 500,000
cores for the largest simulations. NAMD uses the popular molecular
graphics program VMD for simulation setup and trajectory analysis, but
is also file-compatible with AMBER, CHARMM, and X-PLOR.

## Useful Links

- [NAMD User Guide](http://www.ks.uiuc.edu/Research/namd/2.14/ug/)
- [NAMD Tutorials](https://www.ks.uiuc.edu/Training/Tutorials/#namd)

## Using NAMD on Cirrus

NAMD is freely available to all Cirrus users.

## Running parallel NAMD jobs

NAMD can exploit multiple nodes on Cirrus and will generally be run in
exclusive mode over more than one node.

For example, the following script will run a NAMD MD job across 2 nodes
(72 cores) with 2 processes/tasks per node and 18 cores per process, one
of which is reserved for communications.

    #!/bin/bash --login

    # Slurm job options (name, compute nodes, job time)
    #SBATCH --job-name=NAMD_Example
    #SBATCH --time=01:00:00
    #SBATCH --exclusive
    #SBATCH --nodes=2
    #SBATCH --tasks-per-node=2
    #SBATCH --cpus-per-task=18
    #SBATCH --account=[budget code]
    #SBATCH --partition=standard
    #SBATCH --qos=standard

    module load namd/2.14

    # Make sure --cpus-per-task information propagates to srun
    export SRUN_CPUS_PER_TASK=${SLURM_CPUS_PER_TASK}

    srun namd2 +setcpuaffinity +ppn 17 +pemap 1-17,19-35 +commap 0,18 input.namd

NAMD can also be run without SMP.

    #!/bin/bash --login

    # Slurm job options (name, compute nodes, job time)
    #SBATCH --job-name=NAMD_Example
    #SBATCH --time=01:00:00
    #SBATCH --exclusive
    #SBATCH --nodes=2
    #SBATCH --account=[budget code]
    #SBATCH --partition=standard
    #SBATCH --qos=standard

    module load namd/2.14-nosmp

    srun namd2 +setcpuaffinity input.namd
