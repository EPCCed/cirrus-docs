LAMMPS
=======

`LAMMPS <http://lammps.sandia.gov/>`_, is a classical molecular dynamics code, and an
acronym for Large-scale Atomic/Molecular Massively Parallel Simulator. LAMMPS has
potentials for solid-state materials (metals, semiconductors) and soft matter
(biomolecules, polymers) and coarse-grained or mesoscopic systems. It can be used
to model atoms or, more generically, as a parallel particle simulator at the atomic,
meso, or continuum scale.

Useful Links
------------

* `LAMMPS Documentation <https://lammps.sandia.gov/doc/Manual.html>`_
* `LAMMPS Mailing list details <https://lammps.sandia.gov/mail.html>`_

Using LAMMPS on Cirrus
----------------------

LAMMPS is Open Source software, and is freely available to all Cirrus users.
A number of versions are available:

* Parallel MPI: using impi or mpt
* MPI+GPU version: using impi and CUDA11.8

Running parallel LAMMPS jobs (MPI)
----------------------------------

LAMMPS can exploit multiple nodes on Cirrus and will generally be run in
exclusive mode over more than one node.

For example, the following script will run a LAMMPS MD job using 4 nodes
(144 cores) with pure MPI.

::

   #!/bin/bash --login

   # Slurm job options (name, compute nodes, job time)
   #SBATCH --job-name=lammps_Example
   #SBATCH --time=00:20:00
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

   # Load LAMMPS module
   module load lammps

   # Run using input in in.test
    srun lmp_mpi < in.test

Running parallel LAMMPS jobs (GPU)
----------------------------------

LAMMPS can exploit multiple GPUs, although the performance scaling depends heavily on the particular system, so each user should run benchmarks for their particular use-case.
While not every LAMMPS forcefield/fix are available for GPU, a vast majority is, and more are added with each new version.
Check the LAMMPS documentation for GPU compatibility with a specific command.

For example, the following script will run a LAMMPS MD job using 2 GPUs

::

   #!/bin/bash --login

   # Slurm job options (name, compute nodes, job time)
   #SBATCH --job-name=lammps_Example
   #SBATCH --time=00:20:00
   #SBATCH --nodes=1
   #SBATCH --gres=gpu:2

   # Replace [budget code] below with your project code (e.g. t01)
   #SBATCH --account=[budget code]
   # Replace [partition name] below with your partition name (e.g. standard,gpu)
   #SBATCH --partition=[partition name]
   # Replace [qos name] below with your qos name (e.g. standard,long,gpu)
   #SBATCH --qos=[qos name]

   # Load LAMMPS module
   module load lammps/8Feb2023-GCC8-IMPI-CUDA118

   # Run using input in in.test
    srun lmp -sf gpu -pk gpu 2 -in input.file -l log.file

Compiling LAMMPS on Cirrus
--------------------------

Compile instructions for LAMMPS on Cirrus can be found on GitHub:

* `Cirrus LAMMPS compile instructions <https://github.com/hpc-uk/build-instructions/tree/main/apps/LAMMPS>`_
