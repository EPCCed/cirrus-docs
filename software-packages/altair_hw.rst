Altair Hyperworks
=================

`Hyperworks <http://www.altairhyperworks.com/>`__ includes best-in-class
modeling, linear and nonlinear analyses, structural and system-level
optimization, fluid and multi-body dynamics simulation, electromagnetic
compatibility (EMC), multiphysics analysis, model-based development,
and data management solutions.

Useful Links
------------

 * `Hyperworks 14 User Guide <http://www.altairhyperworks.com/hwhelp/Altair/hw14.0/help/altair_help/altair_help.htm?welcome_page.htm>`__

Using Hyperworks on Cirrus
--------------------------

Hyperworks is licenced software so you require access to a Hyperworks
licence to access the software. For queries on access to Hyperworks on
Cirrus and to enable your access please contact the Cirrus helpdesk.

The standard mode of using Hyperworks on Cirrus is to use the installation
of the Desktop application on your local workstation or laptop to set
up your model/simulation. Once this has been doen you would transsfer the
required files over to Cirrus using SSH and then launch the appropriate
Solver program (OptiStruct, RADIOSS, MotionSolve).

Once the Solver has finished you can transfer the output back to your 
local system for visualisation and analysis in the Hyperworks Desktop.

Running serial Hyperworks jobs
------------------------------

Each of the Hyperworks Solvers can be run in serial on Cirrus in a similar
way. You should construct a batch submission script with the command to 
launch your chosen Solver with the correct command line options.

For example, here is a job script to run a serial RADIOSS job on Cirrus:

Running parallel Hyperworks jobs
--------------------------------

Only the OptiStruct Solver currently supports parallel execution. OptiStruct
supports a number of parallel execution modes of which two can be used on 
Cirrus:

* Shared memory (SMP) mode uses multiple cores within a single node
* Distributed memory (SPMD) mode uses multiple cores across multiple nodes
  via the MPI library

OptiStruct SMP
~~~~~~~~~~~~~~

* `OptiStruct SMP documentation <http://www.altairhyperworks.com/hwhelp/Altair/hw14.0/help/hwsolvers/hwsolvers.htm?shared_memory_parallelization.htm>`__ 

You can use up to 36 physical cores (or 72 virtual cores using HyperThreading) 
for OptiStruct SMP mode as these are the maximum numbers available on each
Cirrus compute node.

You use the `-nt` option to OptiStruct to specify the number of cores to use.

For example, to run a 18 cores for an OptiStruct SMP calculation you could
use the following job script:

OptiStruct SPMD (MPI)
~~~~~~~~~~~~~~~~~~~~~

*Note:* OptiStruct SPMD is not currently enabled on Cirrus. We are working with
Intel to resolve this issue. If you have questions on this, please contact the
Cirrus helpdesk.

* `OptiStruct SPMD documentation <http://www.altairhyperworks.com/hwhelp/Altair/hw14.0/help/hwsolvers/hwsolvers.htm?optistruct_spmd.htm>`__

