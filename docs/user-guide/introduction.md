# Introduction

The Cirrus EX4000 system was installed in Q4 2025. The underlying technology
is supplied by HPE Cray and is based on AMD 9005 series processors. The system
runs a version of Red Hat Enterprise Linux (RHEL).


## Overview of the Cirrus system

<figure markdown="span">
   ![Overview of the Cirrus system](/images/overview.svg){ width="90%" }
   <figcaption>A schematic of the Cirrus system, where users login into
   the front end nodes, and work on the back end is managed by SLURM.
   </figcaption>
</figure>


There are four front end or login nodes which are intended for interactive
access, and lightweight pre-processing and post-processing work. The front
end nodes use AMD EPYC 9745 processors (two 128-core processors per node)
each with a total of 1.5 TB of memory.

The SLURM workload manager provides access to a total of 256 back end or
compute nodes. All compute nodes have two 144-core AMD 9825 processors (a
total of 288 physical codes per node). There are 192 standard compute
nodes with 768 GB DDR5 RAM per node, and 64 "high memory" nodes with
1,536 GB per node. All the back end compute nodes are connected with
Slingshot 11 interconnect.

The SLURM scheduler is also informally known as "the queue system",
although SLURM itself does not have the exact concept of queues.
Work is submitted to _partitions_ with a given _quality of service_ (QoS).

For further details of the compute node hardware and network, see the
[hardware description](/user-guide/hardware).

### Storage

Storage is provided by two file systems:

- A 1.0 PB HPE E1000 ClusterStor Lustre parallel file system mounted on both
  the front end and compute nodes. It is also referred to as the work file
  system (`/work`). The work file system _must_ be  used for work submitted to
  SLURM.

- A 1.5 PB Ceph distributed file system mounted on the login nodes but
  not the compute nodes. It is the location of users' home directories
  (`/home`).
  It follows that work submitted to SLURM must not reference users'
  home directories.

For further storage details see
[Data Management and Transfer](/user-guide/data).

## Charging

Cirrus is a CPU-only system and usage of the queue system (SLURM) is
accounted for in core hours (referred to as "coreh" in SAFE).
For example, a job requesting
one node exclusively for one hour will be charged 288 core hours
from the relevant budget if it completes in exactly 60 minutes. Jobs
requesting less than a full node will be charged pro-rata according to
the number of cores requested and time taken. Accounting takes
place at job completion.

Applications for access to the service should make estimates of computational
resource requirement in these units. Requirements for disk usage should
be made in GB or TB.


## Acknowledging Cirrus

Please use the following phrase to acknowledge Cirrus in all
research outputs that have used the facility:

*This work used the Cirrus UK National Tier-2 HPC Service at EPCC
(http://www.cirrus.ac.uk) funded by The University of Edinburgh,
the Edinburgh and South East Scotland City Region Deal, and UKRI via
EPSRC.*
