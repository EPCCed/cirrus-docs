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

This documentation covers:

* Cirrus User Guide: general information on how to use Cirrus
* Software Applications: notes on using specific software applications on Cirrus
* Software Libraries: notes on compiling against specific libraries on Cirrus. Most
  libraries work *as expected* so no additional notes are required however a small number require specific
  documentation
* Software Tools: Information on using tools such as debuggers and profilers on Cirrus

Information on using the SAFE web interface for managing and reporting on your usage on
Cirrus can be found on the `Tier-2 SAFE Documentation <http://tier2-safe.readthedocs.io/en/latest/>`__

This documentation draws on the `Sheffield Iceberg Documentation <https://github.com/rcgsheffield/sheffield_hpc>`__
and the documentation for the `ARCHER National Supercomputing Service <http://www.archer.ac.uk>`__.

.. toctree::
   :maxdepth: 2
   :caption: Cirrus User Guide

   user-guide/introduction
   user-guide/connecting
   user-guide/transfer
   user-guide/resource_management
   user-guide/development
   user-guide/batch
   user-guide/singularity
   user-guide/python
   user-guide/reading

.. toctree::
   :maxdepth: 2
   :caption: Software Applications

   software-packages/altair_hw
   software-packages/Ansys
   software-packages/castep
   software-packages/cp2k
   software-packages/flacs
   software-packages/gaussian
   software-packages/gromacs
   software-packages/helyx
   software-packages/lammps
   software-packages/MATLAB
   software-packages/namd
   software-packages/openfoam
   software-packages/qe
   software-packages/starccm+
   software-packages/vasp

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
