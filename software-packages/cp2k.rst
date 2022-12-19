CP2K
====

`CP2K <https://www.cp2k.org/>`__ is a quantum chemistry and solid state physics software package
that can perform atomistic simulations of solid state, liquid, molecular, periodic, material,
crystal, and biological systems. CP2K provides a general framework for different modelling methods
such as DFT using the mixed Gaussian and plane waves approaches GPW and GAPW. Supported theory
levels include DFTB, LDA, GGA, MP2, RPA, semi-empirical methods (AM1, PM3, PM6, RM1, MNDO, …),
and classical force fields (AMBER, CHARMM, …). CP2K can do simulations of molecular dynamics,
metadynamics, Monte Carlo, Ehrenfest dynamics, vibrational analysis, core level spectroscopy,
energy minimisation, and transition state optimisation using NEB or dimer method.

Useful Links
------------

* `CP2K Reference Manual <https://manual.cp2k.org/#gsc.tab=0>`__
* `CP2K HOWTOs <https://www.cp2k.org/howto>`__
* `CP2K FAQs <https://www.cp2k.org/faq>`__

Using CP2K on Cirrus
--------------------

CP2K is available through the ``cp2k`` module. MPI only ``cp2k.popt`` and MPI/OpenMP Hybrid
``cp2k.psmp`` binaries are available.


Running parallel CP2K jobs - MPI Only
-------------------------------------

To run CP2K using MPI only, load the ``cp2k`` module and use the ``cp2k.popt`` executable.

For example, the following script will run a CP2K job using 4 nodes (144 cores):

   ::

     #!/bin/bash

     # Slurm job options (name, compute nodes, job time)
     #SBATCH --job-name=CP2K_test
     #SBATCH --time=0:20:0
     #SBATCH --exclusive
     #SBATCH --nodes=4
     #SBATCH --tasks-per-node=36 
     #SBATCH --cpus-per-task=1

     # Replace [budget code] below with your budget code (e.g. t01)
     #SBATCH --account=[budget code]
     # Replace [partition name] below with your partition name (e.g. standard,gpu)
     #SBATCH --partition=[partition name]
     # Replace [qos name] below with your qos name (e.g. standard,long,gpu)
     #SBATCH --qos=[qos name]

     # Load CP2K
     module load cp2k

     #Ensure that no libraries are inadvertently using threading
     export OMP_NUM_THREADS=1

     # Run using input in test.inp
     srun cp2k.popt -i test.inp


Running Parallel CP2K Jobs - MPI/OpenMP Hybrid Mode
---------------------------------------------------

To run CP2K using MPI and OpenMP, load the ``cp2k`` module and use the ``cp2k.psmp`` executable.

For example, the following script will run a CP2K job using 8 nodes, with 2 OpenMP threads per MPI process:

  ::

   #!/bin/bash
  
   # Slurm job options (name, compute nodes, job time)
   #SBATCH --job-name=CP2K_test
   #SBATCH --time=0:20:0
   #SBATCH --exclusive
   #SBATCH --nodes=8
   #SBATCH --tasks-per-node=18
   #SBATCH --cpus-per-task=2

   # Replace [budget code] below with your budget code (e.g. t01)
   #SBATCH --account=[budget code]
   # Replace [partition name] below with your partition name (e.g. standard,gpu)
   #SBATCH --partition=[partition name]
   # Replace [qos name] below with your qos name (e.g. standard,long,gpu)
   #SBATCH --qos=[qos name]

   # Load CP2K
   module load cp2k

   # Set the number of threads to 2
   export OMP_NUM_THREADS=2

   # Run using input in test.inp
   srun cp2k.psmp -i test.inp
