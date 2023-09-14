Cirrus Network Upgrade: 2023
============================

During September 2023 Cirrus will be undergoing a Network upgrade.

On this page we describe the impact this will have and links to further information.

If you have any questions or concerns, please
contact the Cirrus Service Desk: https://www.cirrus.ac.uk/support/



When will the upgrade happen and how long will it take?
--------------------------------------------------------------------------

The outage dates will be:

 - Start:  Monday 18th September 2023  09:00
 - Scheduled End:  Friday 22nd September 2023

We will notify users if we are able to complete this work ahead of schedule.

What are the impacts on users from the upgrade?
--------------------------------------------------------

During the upgrade process

 - No login access
 - No access to any data on the system
 - The SAFE will be available during the outage but there will be reduced functionality due to the unavailability of the connection to Cirrus such as resetting of passwords or new account creation. 

Submitting new work, and running work

 - With no login access, it will not be possible to submit new jobs to the queues
 - Jobs will continue to run, and queued jobs will be started as usual

We will therefore be encouraging users to submit jobs to the queues in the period prior to the work, so that Cirrus can continue to run jobs during the outage.

Relaxing of queue limits
~~~~~~~~~~~~~~~~~~~~~~~~~

In preparation for the Data Centre Network (DCN) upgrade we have relaxed the queue limits on all the QoS’s, so that users can submit a significantly larger number of jobs to Cirrus. These changes are intended to allow users to submit jobs that they wish to run during the upgrade, in advance of the start of the upgrade. The changes will be in place until the end of the Data Centre Network upgrade.

Quality of Service (QoS)
~~~~~~~~~~~~~~~~~~~~~~~~

QoS relaxed limits which will be in force during the Networ upgrade.

.. list-table:: Cirrus QoS
   :header-rows: 1

   * - QoS Name
     - Jobs Running Per User
     - Jobs Queued Per User
     - Max Walltime
     - Max Size
     - Applies to Partitions
     - Notes
   * - standard
     - No limit
     - 1000 jobs
     - 4 days
     - 88 nodes (3168 cores/25%)
     - standard
     -
   * - largescale
     - 1 job
     - 20 jobs
     - 24 hours
     - 228 nodes (8192+ cores/65%) or 144 GPUs
     - standard, gpu
     -
   * - long
     - 5 jobs
     - 40 jobs
     - 14 days
     - 16 nodes or 8 GPUs
     - standard, gpu
     -
   * - highpriority
     - 10 jobs
     - 20 jobs
     - 4 days
     - 140 nodes
     - standard
     -
   * - gpu
     - No limit
     - 256 jobs
     - 4 days
     - 64 GPUs (16 nodes/40%)
     - gpu
     -
   * - lowpriority
     - No limit
     - 1000 jobs
     - 2 days
     - 36 nodes (1296 cores/10%) or 16 GPUs
     - standard, gpu
     -
