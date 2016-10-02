Cirrus User Guide
=================

This guide explains how to make use of the Cirrus facility.

Contents
--------

`1. Introduction <introduction.php>`__
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

An introduction to the Cirrus facility. This includes links to
information on the hardware and software installed on the system.

-  `1.1 Acknowledging Cirrus <introduction.php#acknowledge>`__
-  `1.2 Hardware <introduction.php#hardware>`__
-  `1.3 Useful terminology <introduction.php#glossary>`__

`2. Connecting and Transferring Data <connecting.php>`__
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

How to access the Cirrus facilities and transfer data to and from
Cirrus.

-  `2.2 Transferring data to and from Cirrus <connecting.php#sec-2.2>`__

   -  `2.2.1 Performance considerations <connecting.php#sec-2.2.1>`__

-  `2.3 Making access more convenient using a SSH
   Agent <connecting.php#sec-2.3>`__

   -  `2.3.1 Setup a SSH key pair protected by a
      passphrase <connecting.php#sec-2.3.1>`__
   -  `2.3.2 Copy the public part of the key to the remote
      host <connecting.php#sec-2.3.2>`__
   -  `2.3.3 Enabling the SSH Agent <connecting.php#sec-2.3.3>`__
   -  `2.3.4 Adding access to other remote
      machines <connecting.php#sec-2.3.4>`__
   -  `2.3.5 SSH Agent forwarding <connecting.php#sec-2.3.5>`__

`3. Resource Management <resource_management.php>`__
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Information on using budgets (for CPU time), the Cirrus filesystems and
managing your resources using the EPCC SAFE.

`3.1 The Cirrus administration web site
(SAFE) <resource_management.php#sec-3.1>`__

`3.2 Checking your CPU-time (kAU)
quota <resource_management.php#sec-3.2>`__

`3.3 Cirrus Filesystems <resource_management.php#sec-3.3>`__

-  `3.3.1 /home Filesystem <resource_management.php#sec-3.3.1>`__
-  `3.3.2 /work Filesystem <resource_management.php#sec-3.3.2>`__
-  `3.3.3 Research Data Facility <resource_management.php#sec-3.3.3>`__

`3.4 Disk quotas <resource_management.php#sec-3.4>`__

-  `3.4.1 Checking disk quotas <resource_management.php#sec-3.4.1>`__
-  `3.4.2 Allocating quotas to specific groups and
   users <resource_management.php#sec-3.4.2>`__

`3.5 File permissions and security <resource_management.php#sec-3.5>`__

`3.6 Sharing data with other Cirrus
users <resource_management.php#sec-3.6>`__

-  `3.6.1 Sharing data with users in your
   project <resource_management.php#sec-3.6.1>`__
-  `3.6.2 Sharing data with all
   users <resource_management.php#sec-3.6.2>`__

`3.7 Sharing data between systems <resource_management.php#sec-3.7>`__

`3.8 File IO Performance Guidelines <resource_management.php#sec-3.8>`__

`3.9 Data archiving <resource_management.php#sec-3.9>`__

`3.10 Use of ``/tmp`` <resource_management.php#sec-3.10>`__

`3.11 Backup policies <resource_management.php#sec-3.11>`__

`4. Application Development Environment <development.php>`__
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Using the application development environment on Cirrus: using modules
to control compilers and libraries, compiling and linking code,
accessing debugging and performance analysis tools.

`4.1 Information on the available modules <development.php#isec-4.1>`__

`4.2 Loading, unloading and swapping
modules <development.php#sec-4.2>`__

`4.3 Things to watch out for <development.php#sec-4.3>`__

`4.4 Compiler wrapper scripts <development.php#sec-4.4>`__

`4.5 Available compiler suites <development.php#sec-4.5>`__

-  `4.5.1 Switching compiler suites <development.php#sec-4.5.1>`__
-  `4.5.2 Changing compiler versions <development.php#sec-4.5.2>`__
-  `4.5.3 Useful compiler options <development.php#sec-4.5.3>`__

`4.6 Using dynamic linking/libraries <development.php#sec-4.6>`__

`4.7 Compiling for Postprocessing/Serial
Nodes <development.php#sec-4.7>`__

-  `4.7.1 Including Libraries in Serial
   Builds <development.php#sec-4.7.1>`__

`Switching to older/newer programming environment
releases <development.php#sec-4.8>`__

`5. Running Jobs <batch.php>`__
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

How to run jobs on Cirrus facilities and more information on the job
submission system.

-  `5.1 Using PBS Pro <batch.php#sec-5.1>`__

   -  `5.8.1 Using checkQueue <batch.php#checkQueue>`__

-  `5.2 Output from PBS jobs <batch.php#sec-5.2>`__
-  `5.3 bolt: Job submission script creation tool <batch.php#sec-5.3>`__

   -  `5.3.1 Basic usage <batch.php#sec-5.3.1>`__
   -  `5.3.2 Further help <batch.php#sec-5.3.2>`__

-  `5.4 Running Parallel Jobs <batch.php#sec-5.4>`__

   -  `5.4.1 PBS Submission Options <batch.php#sec-5.4.1>`__
   -  `5.4.2 Parallel job launcher aprun <batch.php#sec-5.4.2>`__
   -  `5.4.3 Task affinity for "unpacked" jobs <batch.php#sec-5.4.3>`__
   -  `5.4.4 Example: job submission script for MPI parallel
      job <batch.php#sec-5.4.4>`__
   -  `5.4.5 Example: job submission script for MPI parallel job on
      large memory nodes <batch.php#sec-5.4.5>`__
   -  `5.4.6 Example: job submission script for OpenMP parallel
      job <batch.php#sec-5.4.6>`__
   -  `5.4.7 Example: job submission script for MPI+OpenMP (mixed mode)
      parallel job <batch.php#sec-5.4.7>`__
   -  `5.4.8 Interactive Jobs <batch.php#sec-5.4.8>`__

-  `5.5 Array Jobs <batch.php#sec-5.5>`__
-  `5.6 Sharing Nodes with OpenMP/Threaded Jobs <batch.php#sec-5.6>`__
-  `5.7 Python Task Farm <batch.php#sec-5.7>`__
-  `5.8 Job Submission System Layouts and Limits <batch.php#sec-5.8>`__

   -  `5.8.1 Scheduling System Priorities and Logic <>`__

-  `5.9 checkScript: Script validation tool <batch.php#checkscript>`__
-  `5.10 Setting a time limit for aprun <batch.php#sec-5.10>`__
-  `5.11 Low Priority Access <batch.php#sec-5.11>`__
-  `5.12 Long Queue Access <batch.php#sec-5.12>`__
-  `5.13 Debug Queue Access <batch.php#sec-5.13>`__
-  `5.14 Reservations <batch.php#sec-5.14>`__
-  `5.15 Serial Queues <batch.php#sec-5.15>`__

   -  `5.15.1 Example Serial Job Submission
      Script <batch.php#sec-5.15.1>`__
   -  `5.15.2 Interactive Postprocessing Job <batch.php#sec-5.15.2>`__

-  `5.16 OOM (Out of Memory) Error Messages <batch.php#sec-5.16>`__

`6. Appendix: Linux Quick Reference Sheet <Quick-Reference-Sheet.pdf>`__
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

A brief guide to basic shell commands. Includes examples for core
utilities, text editors and PBS functions.
