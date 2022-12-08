NAMD
====

`NAMD <http://www.ks.uiuc.edu/Research/namd/>`_, recipient of a 2002 Gordon Bell Award and a
2012 Sidney Fernbach Award, is a parallel molecular dynamics code designed for
high-performance simulation of large biomolecular systems. Based on Charm++
parallel objects, NAMD scales to hundreds of cores for typical simulations
and beyond 500,000 cores for the largest simulations. NAMD uses the popular
molecular graphics program VMD for simulation setup and trajectory analysis,
but is also file-compatible with AMBER, CHARMM, and X-PLOR.

Useful Links
------------

* `NAMD User Guide <http://www.ks.uiuc.edu/Research/namd/2.14/ug/>`__
* `NAMD Tutorials <https://www.ks.uiuc.edu/Training/Tutorials/#namd>`__

Using NAMD on Cirrus
--------------------

NAMD is freely available to all Cirrus users.

Running parallel NAMD jobs
--------------------------

NAMD can exploit multiple nodes on Cirrus and will generally be run in
exclusive mode over more than one node.

For example, the following script will run a NAMD MD job across 2 nodes
(72 cores) with 2 tasks per node and 18 cores per task, one of which
is reserved for communications.

::

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

   export OMP_NUM_THREADS=18
   export OMP_PLACES=cores

   srun namd2 +setcpuaffinity +isomalloc_sync +ppn 17 +pemap 1-17,19-35 +commap 0,18 input.namd

NAMD can also be run without SMP.

::

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

   srun namd2 +setcpuaffinity +isomalloc_sync input.namd

And, finally, there's also a GPU version. The example below runs ten NAMD worker threads
on one GPU.

::

   #!/bin/bash --login

   # Slurm job options (name, compute nodes, job time)
   #SBATCH --job-name=NAMD_Example
   #SBATCH --time=01:00:00
   #SBATCH --nodes=1
   #SBATCH --account=[budget code]
   #SBATCH --partition=gpu
   #SBATCH --qos=gpu
   #SBATCH --gres=gpu:1

   module load namd/2.14-gpu

   export OMP_NUM_THREADS=10
   export OMP_PLACES=cores

   srun --distribution=block:block --hint=nomultithread \
       namd2 +setcpuaffinity +isomalloc_sync +idlepoll \
           +ppn ${OMP_NUM_THREADS} +devices 0 input.namd
