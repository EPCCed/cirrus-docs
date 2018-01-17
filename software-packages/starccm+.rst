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

Using STAR-CCM+ on Cirrus
----------------------------

Interactive remote GUI Mode

A fast and responsive way of running with a GUI is to install
STAR-CCM+ on your local Windows(7 or 10) or Linux workstation. You can
then start your local STAR-CCM+ and connect to Cirrus in order to
submit new jobs or query the status of running jobs. When you install
your local version, de-activate the FLEXIm installation. FLEXIm is not
required, since you will be using the FLEXIm on Cirrus.

You also need to setup passwordless SSH connections to Cirrus.

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



Licensing
---------

All users must provide their own license for STAR_CCM+.  To use
STAR_CCM+ on Cirrus, you must provide the IP address/hostname, and the
port number, of your local STAR_CCM+ license server.

EPCC will then add your license server's details to our License Server
Gateway on Cirrus (192.168.191.10).

Please note that your STAR_CCM+ license server must use the same ports
as our License Server Gateway: this is achieved by simply setting an
environment variable.
 
