.. include:: header.rst
   
Cirrus
======

Cirrus is a supercomputing service hosted and run by `EPCC <http://www.epcc.ed.ac.uk>`_ at 
`The University of Edinburgh <http://www.ed.ac.uk>`_.

Cirrus is available to industry, commerce and academic researchers. For information on how
to get access to the system please see `Cirrus on the EPCC website <http://www.epcc.ed.ac.uk/cirrus>`_.
   
The Cirrus facility is based around an SGI ICE XA HPC cluster with 2,016 cores. There are 56 compute
nodes, each with 256 GB of memory, connected together by a single Infiniband fabric. Each node
contains two 2.1 GHz, 18-core Intel Xeon processors, and all nodes access the 116 TiB Lustre file system.

This documentation draws on the `Sheffield Iceberg Documentation <https://github.com/rcgsheffield/sheffield_hpc>`_
and the documentation for the `ARCHER National Supercomputing Service <http://www.archer.ac.uk>`_.
   
.. toctree::
   :maxdepth: 2
   :caption: Cirrus User Guide

   user-guide/introduction
   user-guide/connecting
   user-guide/resource_management
   user-guide/development
   user-guide/batch
   user-guide/transfer
   user-guide/reading
   
.. toctree::
   :maxdepth: 2
   :caption: Software Applications
   
   software-packages/introduction
   software-packages/altair_hw
   software-packages/flacs

.. toctree::
   :maxdepth: 2
   :caption: Data Management Guide

   data-management/transfer

.. toctree::
   :maxdepth: 2
   :caption: About Cirrus
  
   hardware
   policies/introduction

.. toctree::
   :maxdepth: 2
   :caption: Cirrus SAFE Documentation

   safe-guide/introduction
   safe-guide/safe-guide-users
   safe-guide/safe-guide-pi
   
.. toctree::
   :maxdepth: 2
   :caption: Support
   
   support
   
