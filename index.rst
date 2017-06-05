.. include:: header.rst
   
Cirrus
======

Cirrus is a HPC and data science service hosted and run by `EPCC <http://www.epcc.ed.ac.uk>`_ at 
`The University of Edinburgh <http://www.ed.ac.uk>`_. It is one of the `EPSRC <http://www.epsrc.ac.uk>`_
Tier-2 National HPC Services.

Cirrus is available to industry, commerce and academic researchers. For information on how
to get access to the system please see the `Cirrus website <http://www.cirrus.ac.uk>`_.
   
The Cirrus facility is based around an SGI ICE XA system with 10,080 cores. There are 280 compute
nodes, each with 256 GB of memory, connected together by a single Infiniband fabric. Each node
contains two 2.1 GHz, 18-core Intel Xeon processors, and all nodes access the 406 TiB Lustre file system.

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
   user-guide/python
   user-guide/libraries
   user-guide/transfer
   user-guide/reading
   
.. toctree::
   :maxdepth: 2
   :caption: Software Applications
   
   software-packages/altair_hw
   software-packages/castep
   software-packages/flacs
   software-packages/gaussian
   software-packages/gromacs
   software-packages/lammps
   software-packages/namd
   software-packages/qe

.. toctree::
   :maxdepth: 2
   :caption: Software Libraries
   
   software-libraries/intel_mkl

.. toctree::
   :maxdepth: 2
   :caption: Software Tools
   
   software-tools/ddt

.. toctree::
   :maxdepth: 2
   :caption: Data Management Guide

   data-management/transfer

.. toctree::
   :maxdepth: 2
   :caption: Cirrus SAFE Documentation

   safe-guide/introduction
   safe-guide/safe-guide-users
   safe-guide/safe-guide-pi
   
