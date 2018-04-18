STAR-CCM+
=========

STAR-CCM+ is a computational fluid dynamics (CFD) code and beyond.  It
provides a broad range of validated models to simulate disciplines and
physics including CFD, computational solid mechanics (CSM),
electromagnetics, heat transfer, multiphase flow, particle dynamics,
reacting flow, electrochemistry, aero-acoustics and rheology; the
simulation of rigid and flexible body motions with techniques
including mesh morphing, overset mesh and six degrees of freedom
(6DOF) motion; and the ability to combine and account for the
interaction between the various physics and motion models in a single
simulation to cover your specific application.

Useful Links
------------

 * `Information about STAR-CCM+ by Siemens <https://mdx.plm.automation.siemens.com/star-ccm-plus>`__

Licensing
---------

All users must provide their own license for STAR-CCM+. This licence 
can be provided as:

1. FLEXlm licence key to be installed on Cirrus
2. IP address and port of publicly accesible remote licence (your STAR-CCM+ license server must use the same ports
as our License Server Gateway: this is achieved by simply setting an environment variable)
3. Power on Demand (PoD) (nothing needs to be provided to Cirrus in this case)

For options 1 and 2, you should contact the `Cirrus Helpdesk <mailto:support@cirrus.ac.uk>`_
with the relevant details.

Using STAR-CCM+ on Cirrus: Interactive remote GUI Mode
------------------------------------------------------

A fast and responsive way of running with a GUI is to install
STAR-CCM+ on your local Windows(7 or 10) or Linux workstation. You can
then start your local STAR-CCM+ and connect to Cirrus in order to
submit new jobs or query the status of running jobs. When you install
your local version, de-activate the FLEXIm installation. FLEXIm is not
required, as you will either be using the FLEXIm server on Cirrus 
or the Power on Demand (PoD) licence option.

You also need to setup passwordless SSH connections to Cirrus.

Jobs using FLEXlm licence server on Cirrus
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Before you can use the FLEXlm server on Cirrus, you must provide us with
your licence key to install on Cirrus (see above).

You can then start the STAR-CCM+ server on the compute nodes. The
following script starts the server:


::

   #!/bin/bash --login
   
   # PBS job options (name, compute nodes, job time)
   #PBS -N STAR-CCM_test
   #PBS -l select=1008
   #PBS -l walltime=02:00:00
   #PBS -l place=excl
   #PBS -k oe    

   # Replace [budget code] below with your project code (e.g. t01)
   #PBS -A [budget code]

   # Change to the directory yhat the job was submitted from
   cd $PBS_O_WORKDIR
   # Load any required modules
   module load mpt
   module load starccm+

   export SGI_MPI_HOME=$MPI_ROOT

   uniq $PBS_NODEFILE | cut -d . -f 1 > ~/starccm.launcher.host.txt
   starccm+ -server -machinefile ~/starccm.launcher.host.txt -np 504 -rsh ssh -port 42333


The port number "42333" should be free. If it is not free STAR-CCM+
will return with an error. You must then try to use another random
port in the 42XXX range. You can then use the 'qstat' command to find
out the first node of your application.

Jobs using remote licence server
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The documentation for this option is currently under construction.

Jobs using Power on Demand (PoD) licences
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

You can then start the STAR-CCM+ server on the compute nodes. The
following script starts the server:


::

   #!/bin/bash --login
   
   # PBS job options (name, compute nodes, job time)
   #PBS -N STAR-CCM_test
   #PBS -l select=1008
   #PBS -l walltime=02:00:00
   #PBS -l place=excl
   #PBS -k oe    

   # Replace [budget code] below with your project code (e.g. t01)
   #PBS -A [budget code]

   # Change to the directory yhat the job was submitted from
   cd $PBS_O_WORKDIR
   # Load any required modules
   module load mpt
   module load starccm+

   export SGI_MPI_HOME=$MPI_ROOT
   export PATH=$STARCCM_EXE:$PATH
   export LM_LICENSE_FILE=2999@192.168.191.10
   export CDLMD_LICENSE_FILE=2999@192.168.191.10

   uniq $PBS_NODEFILE | cut -d . -f 1 > ~/starccm.launcher.host.txt
   starccm+ -power -podkey <PODkey> -licpath 2999@192.168.191.10 -server -machinefile ~/starccm.launcher.host.txt -np 504 -rsh ssh -port 42333

You should replace "<PODkey>" with your PoD licence key.

Local Star-CCM+ client configuration
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Start your local STAR-CCM+ application and connect to your
server. Click on the File -> "Connect to Server..." option and use the
following settings:

* Host: name of first Cirrus compute node (use 'qtsat', e.g. r1i0n32)
* Port: the number that you specified in the submission script

Select the "Connect through SSH tunnel" option and use:

* SSH Tunnel Host: cirrus-login0.epcc.ed.ac.uk
* SSH Tunnel Host Username: use your Cirrus username
* SSH Options: -agent

Your local STAR-CCM+ client should now be connected to the remote
server. You should be able to run a new simulation or interact with an
existing one.

