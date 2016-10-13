Hardware
========

The Cirrus facility is based around a Intel ICE XA 59 node cluster that
provides the central computational resource.

Intel ICE XA Cluster
--------------------

The Cirrus architecture consists of compute nodes connected together by
a single Infiniband fabric, with 56 compute nodes and 3 login nodes.

Compute Nodes
~~~~~~~~~~~~~

Cirrus compute nodes each contain two 2.1 GHz, 18-core Intel Xeon E5-2695
(Broadwell) series processors. Each of the cores in these processors
support 2 hardware threads (Hyperthreads), which are enabled by default.

The compute nodes on Cirrus have 256 GB of memory shared between the two
processors. The memory is arranged in a non-uniform access (NUMA) form:
each 18-core processor is a single NUMA region with local memory of 128
GB. Access to the local memory by cores within a NUMA region has a lower
latency than accessing memory on the other NUMA region.

There are three levels of cache, configured as follows:

-  L1 Cache 32 KB Instr., 32 KB Data (per core)
-  L2 Cache 256 KB (per core)
-  L3 Cache 45 MB (shared)

There are 56 compute nodes on Cirrus giving a total of 2,016 cores).
When employing hyperthreads, the core count doubles to 4,032. NB
hyperthreads are currently switched on by default

Infiniband fabric
-----------------

The system has a single infiniband (IB) fabric and every compute node
and login node has a single ib0 interface on it. The IB interface is
FDR, rated at 54.5Gbps. The Lustre servers have two connections on the
IB fabric and all Lustre file system IO traverses the IB fabric.

Filesystems and Data Infrastructure
-----------------------------------

There is currently a single filesystem available on Cirrus: the /lustre
filesystem. This filesystem is a collection of three high-performance,
parallel Lustre filesystems.

There is currently a total of 200 TB available in ``/lustre`` on Cirrus.
The cluster login and compute nodes mount the storage as /lustre, and
all home directories are available on all nodes.

The compute nodes are diskless. Each node boots from a cluster
management noded called the Rack Leader and NFS mounts the root file
system from this management node.

**NB Currently, the /lustre filesystem are not backed-up in any way.**

Parallel I/O
------------

For a description of the terms associated with Lustre file systems
please see the description on Wikipedia:

-  `Lustre File Systems
   Description <https://en.wikipedia.org/wiki/Lustre_(file_system)>`__

The default striping on the Lustre filesystem is 1 stripe, and the
default stripe size is 1 MiB. There are 4 OSTs.

The parallel I/O performance has been measured by writing to a single
shared file using MPI I/O. All cores per node were writing
simultaneously. Best performance was withh 4 nodes (144 cores) writing
tof 4 stripes of 1 MiB and was found to be around 1.5 GB/s.

Performance was evaluated using the EPCC "benchio" application, found
at: https://github.com/ARCHER-CSE/parallel-io
