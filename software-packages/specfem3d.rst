SPECFEM3D Cartesian
===================

`SPECFEM3D Cartesian <https://geodynamics.org/cig/software/specfem3d/>`_, simulates acoustic (fluid),
elastic (solid), coupled acoustic/elastic, poroelastic or seismic wave propagation in any type
of conforming mesh of hexahedra (structured or not.) It can, for instance, model seismic waves
propagating in sedimentary basins or any other regional geological model following earthquakes.
It can also be used for non-destructive testing or for ocean acoustics.

Useful Links
------------

* `SPECFEM3D User Resources <https://geodynamics.org/cig/software/specfem3d/#users/>`__
* `SPECFEM3D Wiki <https://wiki.geodynamics.org/software:specfem3d:start>`__

Using SPECFEM3D Cartesian on Cirrus
-----------------------------------

SPECFEM3D Cartesian is freely available to all Cirrus users.

Running parallel SPECFEM3D Cartesian jobs
----------------------------------------

SPECFEM3D can exploit multiple nodes on Cirrus and will generally be run in
exclusive mode over more than one node. Furthermore, it can be run on the
GPU nodes.

For example, the following script will run a SPECFEM3D job using 4 nodes
(144 cores) with pure MPI.

::

   #!/bin/bash --login
   
   # Slurm job options (name, compute nodes, job time)
   #SBATCH --job-name=SPECFEM3D_Example
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


   # Load SPECFEM3D module
   module load specfem3d

   # Run using input in input.namd
   srun xspecfem3D
   


