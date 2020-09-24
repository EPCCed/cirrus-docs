OpenFOAM
========

OpenFOAM is an open-source toolbox for computational fluid dynamics. OpenFOAM consists of generic tools to simulate complex physics for a variety of fields of interest, from fluid flows involving chemical reactions, turbulence and heat transfer, to solid dynamics, electromagnetism and the pricing of financial options.

The core technology of OpenFOAM is a flexible set of modules written in C++. These are used to build solvers and utilities to perform pre- and post-processing tasks ranging from simple data manipulation to visualisation and mesh processing.

Available Versions
------------------

You can query the versions of OpenFOAM available on Cirrus from the command line with ``module avail openfoam``.

Useful Links
------------

* `OpenFOAM Documentation <https://www.openfoam.com/documentation/>`_

Using OpenFOAM on Cirrus
------------------------

To use OpenFOAM on Cirrus you should first load the OpenFOAM module:

::

   module add openfoam
   
After that you need to source the ``etc/bashrc`` file provided by OpenFOAM:

::

   source $OPENFOAM_CURPATH/etc/bashrc

You should then be able to use OpenFOAM.  The above commands will also need to be added to any job/batch submission scripts you want to run OpenFOAM from.
