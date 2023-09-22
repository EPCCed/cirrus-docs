Introduction
============

This guide is designed to be a reference for users of the
high-performance computing (HPC) facility: Cirrus. It provides all the
information needed to access the system, transfer data, manage your
resources (disk and compute time), submit jobs, compile programs and
manage your environment.

Acknowledging Cirrus
--------------------

You should use the following phrase to acknowledge Cirrus in all
research outputs that have used the facility:

*This work used the Cirrus UK National Tier-2 HPC Service at EPCC (http://www.cirrus.ac.uk) funded by the University of Edinburgh and EPSRC (EP/P020267/1)*

You should also tag outputs with the keyword *Cirrus* whenever possible.

Hardware
--------

Details of the Cirrus hardware are available on the Cirrus website:

* `Cirrus Hardware <http://www.cirrus.ac.uk/about/hardware.html>`_

Useful terminology
------------------

This is a list of terminology used throughout this guide and its
meaning.

CPUh
    Cirrus CPU time is measured in CPUh. Each job you run on the service
    consumes CPUhs from your budget. You can find out more about CPUhs and
    how to track your usage in the :doc:`resource_management`

GPUh
    Cirrus GPU time is measured in GPUh. Each job you run on the GPU nodes
    consumes GPUhs from your budget, and requires positive CPUh, even though
    these will not be consumed. You can find out more about GPUhs and
    how to track your usage in the :doc:`resource_management`
