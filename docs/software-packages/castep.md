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

- [CASTEP User Guides](http://www.castep.org/CASTEP/Documentation)
- [CASTEP Tutorials](http://www.castep.org/CASTEP/OnlineTutorials)
- [CASTEP Licensing](http://www.castep.org/CASTEP/GettingCASTEP)

## Using CASTEP on Cirrus

**CASTEP is only available to users who have a valid CASTEP licence.**

If you have a CASTEP licence and wish to have access to CASTEP on Cirrus
please [submit a request through the
SAFE](https://epcced.github.io/safe-docs/safe-for-users/#how-to-request-access-to-a-package-group-licensed-software-or-restricted-features).


!!! Note


	CASTEP versions 19 and above require a separate licence from CASTEP
	versions 18 and below so these are treated as two separate access
	requests.


## Running parallel CASTEP jobs

CASTEP can exploit multiple nodes on Cirrus and will generally be run in
exclusive mode over more than one node.

For example, the following script will run a CASTEP job using 4 nodes
(144 cores).

    #!/bin/bash

     # Slurm job options (name, compute nodes, job time)
     #SBATCH --job-name=CASTEP_Example
     #SBATCH --time=1:0:0
     #SBATCH --exclusive
     #SBATCH --nodes=4
     #SBATCH --tasks-per-node=36
     #SBATCH --cpus-per-task=1

    # Replace [budget code] below with your project code (e.g. t01)
    #SBATCH --account=[budget code]
    # Replace [partition name] below with your partition name (e.g. standard,gpu)
    #SBATCH --partition=[partition name]
    # Replace [qos name] below with your qos name (e.g. standard,long,gpu)
    #SBATCH --qos=[qos name]

    # Load CASTEP version 18 module
    module load castep/18

    # Set OMP_NUM_THREADS=1 to avoid unintentional threading
    export OMP_NUM_THREADS=1

    # Run using input in test_calc.in
    srun --distribution=block:block castep.mpi test_calc
