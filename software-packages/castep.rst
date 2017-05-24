CASTEP
======

`CASTEP <http://www.castep.org>`__  is a leading code for calculating the
properties of materials from first principles. Using density functional theory,
it can simulate a wide range of properties of materials proprieties including
energetics, structure at the atomic level, vibrational properties, electronic
response properties etc. In particular it has a wide range of spectroscopic
features that link directly to experiment, such as infra-red and Raman
spectroscopies, NMR, and core level spectra.

Useful Links
------------

* `CASTEP User Guides <http://www.castep.org/CASTEP/Documentation>`__
* `CASTEP Tutorials <http://www.castep.org/CASTEP/OnlineTutorials>`__
* `CASTEP Licensing <http://www.castep.org/CASTEP/GettingCASTEP>`__

Using CASTEP on Cirrus
----------------------

**CASTEP is only available to users who have a valid CASTEP licence.**

If you have a CASTEP licence and wish to have access to CASTEP on Cirrus
please contact the `Cirrus Helpdesk <http://www.cirrus.ac.uk/support/>`__.

Running parallel CASTEP jobs
----------------------------

CASTEP can exploit multiple nodes on Cirrus and will generally be run in
exclusive mode over more than one node.

For example, the following script will run a CASTEP job using 4 nodes
(144 cores).

::

   #!/bin/bash --login
   
   # PBS job options (name, compute nodes, job time)
   #PBS -N CASTEP_test
   #PBS -l select=4:ncpus=72
   #PBS -l place=excl
   #PBS -l walltime=0:20:0
   
   # Replace [budget code] below with your project code (e.g. t01)
   #PBS -A [budget code]
   
   # Change to the directory that the job was submitted from
   cd $PBS_O_WORKDIR
   
   # Load CASTEP and MPI modules
   module load castep
   module load mpt

   # Run using input in test_calc.in
   # Note: '-ppn 36' is required to use all physical cores across
   # nodes as hyperthreading is enabled by default
   mpiexec_mpt -n 144 -ppn 36 castep.mpi test_calc

