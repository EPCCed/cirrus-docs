HELYX®
======

HELYX is a comprehensive, general-purpose computational fluid dynamics (CFD) software
package for engineering analysis and design optimisation developed by ENGYS. The package
features an advanced open-source CFD simulation engine and a client-server GUI to provide
a flexible and cost-effective HPC solver platform for enterprise applications.

Useful Links
------------

* Information about HELYX
* Information about ENGYS

Using HELYX on Cirrus
---------------------

HELYX is only available on Cirrus to authorised users with a valid license to use the software.
For any queries regarding HELYX on Cirrus, please contact ENGYS or the Cirrus Helpdesk.

HELYX applications can be run on Cirrus in two ways:

* Manually from the command line, using a SSH terminal to access the cluster’s master node.
* Interactively from within the GUI, using the dedicated client-server node to connect remotely to the cluster.

A complete user’s guide to access HELYX on demand via Cirrus is provided by ENGYS as part of the service offering.

Running Parallel HELYX Jobs
---------------------------

The standard execution of HELYX applications on Cirrus is handled through the command line using a submission
script to control PBSPro. A basic submission script for running multiple HELYX applications in parallel using
the SGI-MPT (Message Passing Toolkit) module is included below. In this example the applications
helyxHexMesh and caseSetup are run sequentially in 144 cores.

:: 

   #!/bin/bash --login
   
   # PBS job options (name, compute nodes, job time)
   #PBS -N HELYX_MPI_Job
   #PBS -l select=4:ncpus=72
   #PBS -l place=excl
   #PBS -l walltime=00:20:00
   
   # Replace [budget code] below with your project code (e.g. t01)
   #PBS -A [budget code]
   
   # Change to the directory that the job was submitted from
   cd $PBS_O_WORKDIR
   
   # Load any required modules
   module load mpt/2.14
   module load gcc/6.2.0
   
   # Load HELYX-Core environment
   export FOAM_INST_DIR=/lustre/home/y07/helyx/v3.0.2/CORE
   . /lustre/home/y07/helyx/v3.0.2/CORE/HELYXcore-3.0.2/etc/bashrc
   
   # Set the number of threads to 1
   export OMP_NUM_THREADS=1
   
   # Launch HELYX applications in parallel
   export myoptions="-parallel"
   jobs="helyxHexMesh caseSetup"
   
   for job in `echo $jobs`
   do
   
   case "$job" in
      *                )   options="$myoptions" ;;
   esac
   
   mpiexec_mpt -n 144 -ppn 36 $job $myoptions 2>&1 | tee log/$job.$PBS_JOBID.out
   
   done

Alternatively, the user can execute most HELYX applications on Cirrus interactively via the GUI by following these simple steps:

1. Launch HELYX GUI in the local Windows or Linux machine. 
2. Create a client-server connection to Cirrus using the dedicated node provided for this service.
   Enter the user login details and the total number of processors to be employed in the cluster
   for parallel execution.
3. Use the GUI in the local machine to access the remote file system in Cirrus to load a geometry,
   create a computational grid, set up a simulation, solve the flow, and post-process the results
   using the HPC resources available in the cluster. The scheduling associated with every HELYX job
   is handled automatically by the client-server.
4. Visualise the remote data from the local machine, perform changes in the model, and complete as
   many flow simulations in Cirrus as required. Disconnect the client-server at any point during
   execution, leave the solver running in the cluster, and resume the connection to Cirrus from
   another client machine to reload an existing case when needed.

