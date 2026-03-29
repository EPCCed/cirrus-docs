# VASP

The [Vienna Ab initio Simulation Package (VASP)](http://www.vasp.at) is
a computer program for atomic scale materials modelling, e.g. electronic
structure calculations and quantum-mechanical molecular dynamics, from
first principles.

VASP computes an approximate solution to the many-body Schrödinger
equation, either within density functional theory (DFT), solving the
Kohn-Sham equations, or within the Hartree-Fock (HF) approximation,
solving the Roothaan equations. Hybrid functionals that mix the
Hartree-Fock approach with density functional theory are implemented as
well. Furthermore, Green's functions methods (GW quasiparticles, and
ACFDT-RPA) and many-body perturbation theory (2nd-order Møller-Plesset)
are available in VASP.

In VASP, central quantities, like the one-electron orbitals, the
electronic charge density, and the local potential are expressed in
plane wave basis sets. The interactions between the electrons and ions
are described using norm-conserving or ultrasoft pseudopotentials, or
the projector-augmented-wave method.

To determine the electronic groundstate, VASP makes use of efficient
iterative matrix diagonalisation techniques, like the residual
minimisation method with direct inversion of the iterative subspace
(RMM-DIIS) or blocked Davidson algorithms. These are coupled to highly
efficient Broyden and Pulay density mixing schemes to speed up the
self-consistency cycle.

## Useful Links

- [VASP Manual](http://cms.mpi.univie.ac.at/vasp/vasp/vasp.html)
- [VASP
  Licensing](http://www.vasp.at/index.php/faqs/71-how-can-i-purchase-a-vasp-license)

## Using VASP on Cirrus

**VASP is only available to users who have a valid VASP licence. Only 
VASP 6 is available on Cirrus and requests for access need to be made
via SAFE.**

If you VASP 6 licence and wish to have access to VASP 6 on Cirrus please
request access through SAFE:

- [How to request access to package
  groups](https://epcced.github.io/safe-docs/safe-for-users/#how-to-request-access-to-a-package-group-licensed-software-or-restricted-features)

Once your access has been enabled, you access the VASP software using
the `vasp` modules in your job submission script. You can see which
versions of VASP are currently available on Cirrus with

    module avail vasp

Once loaded, the executables are called:

- vasp_std - Multiple k-point version
- vasp_gam - GAMMA-point only version
- vasp_ncl - Non-collinear version

All executables include:

- libBEEF functionality
- LibXC functionality
- Wannier90 support
- HDF5 support
- Additional MD algorithms accessed via the `MDALGO` keyword.

## Running parallel VASP jobs

!!! tip
    If you are running &Gamma;-point calculations, the `vasp_gam`
    executable typically runs around 50% faster than `vasp_std`.

### Smaller than single node VASP jobs

When running on less than a node you omit the `--exclusive` flag
from your job submission scripts. 

The following example runs a 36-core VASP calculation on a single 
node on Cirrus:

```slurm
#!/bin/bash

# job options (name, compute nodes, job time)
#SBATCH --job-name=VASP
#SBATCH --nodes=1
#SBATCH --tasks-per-node=36
#SBATCH --cpus-per-task=1
#SBATCH --time=0:20:0

# Replace [budget code] below with your project code (e.g. t01)
#SBATCH --account=[budget code]
# Replace [partition name] below with your partition name (e.g. standard)
#SBATCH --partition=[partition name]
# Replace [qos name] below with your qos name (e.g. standard,long)
#SBATCH --qos=[qos name]

# Load VASP version 6 module
module load vasp/6

# Set number of OpenMP threads to 1
export OMP_NUM_THREADS=1
export OMP_PLACES=cores
export SRUN_CPUS_PER_TASK=$SLURM_CPUS_PER_TASK

# Run standard VASP executable
#   --hint=nomultithread - ensures VASP uses physical cores
#   --distribution=block:block - ensure best placement of MPI tasks for 
#       collective comms performance
srun --hint=nomultithread --distribution=block:block vasp_std
```


### Multi-node VASP jobs

VASP can exploit multiple nodes on Cirrus.

!!! tip
    If you are running multi-node VASP jobs you will often need to
    use half the cores on a node or less to achieve good performance
    due to memory/interconnect contention from the high number of 
    cores per node.

The following script will run a VASP job using 2 nodes with half the 
cores on each node (144 cores) being used for VASP MPI processes. This
gives 288 cores in total for this VASP job

```slurm
#!/bin/bash

# job options (name, compute nodes, job time)
#SBATCH --job-name=VASP
#SBATCH --nodes=2
#SBATCH --tasks-per-node=144
#SBATCH --cpus-per-task=2
#SBATCH --exclusive
#SBATCH --time=0:20:0

# Replace [budget code] below with your project code (e.g. t01)
#SBATCH --account=[budget code]
# Replace [partition name] below with your partition name (e.g. standard)
#SBATCH --partition=[partition name]
# Replace [qos name] below with your qos name (e.g. standard,long)
#SBATCH --qos=[qos name]

# Load VASP version 6 module
module load vasp/6

# Set number of OpenMP threads to 1
export OMP_NUM_THREADS=1
export OMP_PLACES=cores
export SRUN_CPUS_PER_TASK=$SLURM_CPUS_PER_TASK

# Run standard VASP executable
#   --hint=nomultithread - ensures VASP uses physical cores
#   --distribution=block:block - ensure best placement of MPI tasks for 
#       collective comms performance
srun --hint=nomultithread --distribution=block:block vasp_std
```
