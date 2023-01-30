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

CPU and GPU versions of VASP are available on Cirrus

**VASP is only available to users who have a valid VASP licence. VASP 5 and VASP 6 are
separate packages on Cirrus and requests for access need to be made separately for the
two versions via SAFE.**

If you have a VASP 5 or VASP 6 licence and wish to have access to VASP on Cirrus
please request access through SAFE:

* `How to request access to package groups <https://epcced.github.io/safe-docs/safe-for-users/#how-to-request-access-to-a-package-group-licensed-software-or-restricted-features>`__

Once your access has been enabled, you access the VASP software using the ``vasp`` modules
in your job submission script. You can see which versions of VASP are currently available
on Cirrus with 

::

   module avail vasp
   
Once loaded, the executables are called:

* vasp_std - Multiple k-point version
* vasp_gam - GAMMA-point only version
* vasp_ncl - Non-collinear version

All executables include the additional MD algorithms accessed via the ``MDALGO`` keyword.

Running parallel VASP jobs - CPU
--------------------------------

The CPU version of VASP can exploit multiple nodes on Cirrus and will generally be run in
exclusive mode over more than one node.

The following script will run a VASP job using 4 nodes (144 cores).

::

   #!/bin/bash
   
   # job options (name, compute nodes, job time)
   #SBATCH --job-name=VASP_CPU_test
   #SBATCH --nodes=4
   #SBATCH --tasks-per-node=36
   #SBATCH --exclusive
   #SBATCH --time=0:20:0
   
   # Replace [budget code] below with your project code (e.g. t01)
   #SBATCH --account=[budget code]
   # Replace [partition name] below with your partition name (e.g. standard,gpu)
   #SBATCH --partition=[partition name]
   # Replace [qos name] below with your qos name (e.g. standard,long,gpu)
   #SBATCH --qos=[qos name]
   
   # Load VASP version 6 module
   module load vasp/6

   # Set number of OpenMP threads to 1
   export OMP_NUM_THREADS=1
   
   # Run standard VASP executable
   srun --hint=nomultithread --distribution=block:block vasp_std
   
Running parallel VASP jobs - GPU
--------------------------------

The GPU version of VASP can exploit multiple GPU across multiple nodes, you should
benchmark your system to ensure you understand how many GPU can be used in parallel
for your calculations.

The following script will run a VASP job using 2 GPU on 1 node.

::

   #!/bin/bash
   
   # job options (name, compute nodes, job time)
   #SBATCH --job-name=VASP_GPU_test
   #SBATCH --nodes=1
   #SBATCH --gres=gpu:2
   #SBATCH --time=0:20:0
   
   # Replace [budget code] below with your project code (e.g. t01)
   #SBATCH --account=[budget code]
   #SBATCH --partition=gpu
   #SBATCH --qos=gpu
   
   # Load VASP version 6 module
   module load vasp/6/6.3.2-gpu-nvhpc22

   # Set number of OpenMP threads to 1
   export OMP_NUM_THREADS=1

   # Run standard VASP executable with 1 MPI process per GPU
   srun --ntasks=2 --cpus-per-task=10 --hint=nomultithread --distribution=block:block vasp_std

