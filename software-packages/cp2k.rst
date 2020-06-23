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

CP2K is available through the ``cp2k-mpt`` module. MPI only ``cp2k.popt`` and MPI/OpenMP Hybrid
``cp2k.psmp`` binaries are available.

**IMPORTANT:** Running cp2k in hybrid OpenMP/MPI mode requires some non-standard steps. Please see
the `Running CP2K in OpenMP/MPI Hybrid Mode` section below for further details.



Running parallel CP2K jobs - MPI Only
-------------------------------------

To run CP2K using MPI only, load the ``cp2k-mpt`` module and use the ``cp2k.popt`` executable.

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

     # Replace [budget code] below with your project code (e.g. t01) 
     #SBATCH --account=[budget code]

     # Load CP2K and MPI modules
     module load cp2k-mpt
     module load mpt
     module load intel-cmkl-19

     #Ensure that no libraries are inadvertently using threading
     export OMP_NUM_THREADS=1

     # Run using input in test.inp
     srun cp2k.popt -i test.inp


Running Parallel CP2K Jobs - MPI/OpenMP Hybrid Mode
---------------------------------------------------

To run CP2K using MPI and OpenMP, load the ``cp2k-mpt`` module and use the ``cp2k.psmp`` executable.

.. Due to a thread placement bug in SGI MPT's ``omplace``, tool for GCC-compiled software, launching
.. the executable must be achieved in a different way to other hybrid OpenMP/MPI codes on Cirrus.

.. You must first run the ``placement`` tool (included in the module) to produce a thread placement
.. file, `place.txt`. For example, if you wish to use 6 threads per process, use:

.. ::

..    export OMP_NUM_THREADS=6
..    placement $OMP_NUM_THREADS

.. to produce the placement file. Then launch the executable using ``mpiexec_mpt`` and ``dplace``
.. (instead of ``omplace``) as follows:

.. ::

..    mpiexec_mpt -n 6 dplace -p place.txt cp2k.psmp ...

For example, the following script will run a CP2K job using 8 nodes, with 2 OpenMP threads per MPI process:

  ::

   #!/bin/bash
  
   # Slurm job options (name, compute nodes, job time)
   #SBATCH --job-name=CP2K_test
   #SBATCH --time=0:20:0
   #SBATCH --exclusive
   #SBATCH --nodes=8
   #SBATCH --tasks=144
   #SBATCH --tasks-per-node=18
   #SBATCH --cpus-per-task=2

   # Replace [budget code] below with your project code (e.g. t01)
   #SBATCH --account=[budget code]

   # Load CP2K and MPI modules
   module load cp2k-mpt
   module load mpt
   module load intel-cmkl-19

   #Ensure that no libraries are inadvertently using threading
   export OMP_NUM_THREADS=2

   # Run using input in test.inp
   srun cp2k.psmp -i test.inp
