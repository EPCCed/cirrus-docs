VASP
====

The `Vienna Ab initio Simulation Package (VASP) <http://www.vasp.at>`__ is a computer program for atomic scale materials modelling, e.g. electronic structure calculations and quantum-mechanical molecular dynamics, from first principles.

VASP computes an approximate solution to the many-body Schrödinger equation, either within density functional theory (DFT), solving the Kohn-Sham equations, or within the Hartree-Fock (HF) approximation, solving the Roothaan equations. Hybrid functionals that mix the Hartree-Fock approach with density functional theory are implemented as well. Furthermore, Green's functions methods (GW quasiparticles, and ACFDT-RPA) and many-body perturbation theory (2nd-order Møller-Plesset) are available in VASP.

In VASP, central quantities, like the one-electron orbitals, the electronic charge density, and the local potential are expressed in plane wave basis sets. The interactions between the electrons and ions are described using norm-conserving or ultrasoft pseudopotentials, or the projector-augmented-wave method.

To determine the electronic groundstate, VASP makes use of efficient iterative matrix diagonalisation techniques, like the residual minimisation method with direct inversion of the iterative subspace (RMM-DIIS) or blocked Davidson algorithms. These are coupled to highly efficient Broyden and Pulay density mixing schemes to speed up the self-consistency cycle.

Useful Links
------------

* `VASP Manual <http://cms.mpi.univie.ac.at/vasp/vasp/vasp.html>`__
* `VASP Licensing <http://www.vasp.at/index.php/faqs/71-how-can-i-purchase-a-vasp-license>`__

Using VASP on Cirrus
--------------------

**VASP is only available to users who have a valid VASP licence.**

If you have a VASP licence and wish to have access to VASP on Cirrus
please contact the `Cirrus Helpdesk <http://www.cirrus.ac.uk/support/>`__.

Running parallel VASP jobs
--------------------------

VASP can exploit multiple nodes on Cirrus and will generally be run in
exclusive mode over more than one node.

To access VASP you should load the ``vasp`` module in your job submission scripts:

::

   module add vasp

Once loaded, the executables are called:

* vasp_std - Multiple k-point version
* vasp_gam - GAMMA-point only version
* vasp_ncl - Non-collinear version

All 5.4.* executables include the additional MD algorithms accessed via the ``MDALGO`` keyword.

You can access the LDA and PBE pseudopotentials for VASP on Cirrus at:

:: 

   /lustre/home/y07/vasp5/5.4.4-intel17-mpt214/pot

The following script will run a VASP job using 4 nodes (144 cores).

::

   #!/bin/bash
   
   # job options (name, compute nodes, job time)
   #SBATCH --job-name=VASP_test
   #SBATCH --nodes=4
   #SBATCH --tasks-per-node=36
   #SBATCH --exclusive
   #SBATCH --time=0:20:0
   
   # Replace [budget code] below with your project code (e.g. t01)
   #SBATCH --account=[budget code]
   # Replace [partition name] below with your partition name (e.g. standard,gpu-skylake)
   #SBATCH --partition=[partition name]
   # Replace [qos name] below with your qos name (e.g. standard,long,gpu)
   #SBATCH --qos=[qos name]
   
   # Load VASP version 5 module
   module load vasp/5

   # Set number of OpenMP threads to 1
   export OMP_NUM_THREADS=1

   # Run standard VASP executable
   srun vasp_std

