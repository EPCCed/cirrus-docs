.. include:: header.rst

Cirrus
======

Cirrus is a HPC and data science service hosted and run by `EPCC <http://www.epcc.ed.ac.uk>`_ at
`The University of Edinburgh <http://www.ed.ac.uk>`_. It is one of the `EPSRC <http://www.epsrc.ac.uk>`_
Tier-2 National HPC Services.

Cirrus is available to industry and academic researchers. For information on how
to get access to the system please see the `Cirrus website <http://www.cirrus.ac.uk>`_.

The Cirrus facility is based around an SGI ICE XA system. There are 280 standard
compute nodes and 38 GPU compute nodes. Each standard compute node has 256 GiB of memory and
contains two 2.1 GHz, 18-core Intel Xeon (Broadwell) processors. Each GPU compute node has 384 GiB of 
memory, contains two 2.4 GHz, 20-core Intel Xeon (Cascade Lake) processors and four NVIDIA Tesla V100-SXM2-16GB
(Volta) GPU accelerators connected to the host processors and each other via PCIe. All nodes are
connected using a single Infiniband fabric.
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

   user-guide/network-upgrade-2023
   user-guide/introduction
   user-guide/connecting
   user-guide/data
   user-guide/resource_management
   user-guide/development
   user-guide/batch
   user-guide/singularity
   user-guide/python
   user-guide/gpu
   user-guide/solidstate
   user-guide/reading

.. toctree::
   :maxdepth: 2
   :caption: Software Applications

   software-packages/castep
   software-packages/cp2k
   software-packages/elements
   software-packages/flacs
   software-packages/gaussian
   software-packages/gromacs
   software-packages/helyx
   software-packages/lammps
   software-packages/MATLAB
   software-packages/namd
   software-packages/openfoam
   software-packages/orca
   software-packages/qe
   software-packages/starccm+
   software-packages/vasp
   software-packages/specfem3d

.. toctree::
   :maxdepth: 2
   :caption: Software Libraries

   software-libraries/intel_mkl
   software-libraries/hdf5

.. toctree::
   :maxdepth: 2
   :caption: Software Tools

   software-tools/ddt
   software-tools/scalasca
   software-tools/intel-vtune

