Debugging using Allinea DDT
===========================

Arm Forge tool suite is installed on Cirrus and DDT,  which is a
debugging tool for scalar, multi-threaded and large-scale parallel
applications, is available for use in debugging your codes. To compile
your code for debugging you will usually want to specify the ``-O0``
option to turn off all code optimisation (as this can produce a mismatch
between source code line numbers and debugging information) and ``-g`` to
include debugging information in the compiled executable. To use this package
you will need to load the Arm Forge module and execute ``forge``:

::

    module load forge
    forge

Debugging runs on the login nodes
---------------------------------

You can execute and debug your MPI code on the login node which is useful for
immediate development work with short, simple runs to avoid having to wait
in the queue. Firstly ensure you have loaded the ``mpt`` library, then start
forge and click *Run*. Fill in the nescesary details of your code under the
*application* pane, then check the MPI tick box, specify the number of MPI
processes you wish to run and ensure implementation is set to *SGI MPT (2.22)*.
If this is not set correctly then you can update the configuration via
clicking the *Change* button and selecting this option on the *MPI/UPC Implementation*
field of the system pane. When you are happy with this hit *Run* to start.

Debugging runs on the compute nodes
-----------------------------------

This involves DDT submitting your job to the queue, this then running and as soon as the compute nodes start executing you will drop into the debug session and be able to interact with your code. Similarly to running on the login node, fill in details of your application and ensure that MPI is ticked. Then check the *Submit to Queue* tick box and click the *Configure* button. In the settings window that pops up you can specify the submission template, one has been prepared one for Cirrus at ``/lustre/sw/allinea/Forge-20/templates/cirrus.qtf`` which we suggest you use - although you are very free to chose another one and/or specialise this as you require. Back on the run page, click the *Parameters* button and fill in the maximum wallclock time, the budget to charge to and the total number of virtual cores required which determine the number of nodes. Back on the *run* dialog ensure look at the *MPI* pane, ensure the *number of processes* and *processes per node* settings are correct and then hit *Submit*.

Memory debugging with DDT
-------------------------

If you are dynamically linking your code and debugging it on the login node then this is fine (just ensure that the *Preload the memory debugging library* option is ticked in the *Details* pane.) If you are dynamically linking but intending to debug running on the compute nodes, or statically linking then you need to include the compile option ``-Wl,--allow-multiple-definition`` and explicitly link your executable with Allinea's memory debugging library. The exactly library to link against depends on your code; ``-ldmalloc`` (for no threading with C), ``-ldmallocth`` (for threading with C), ``-ldmallocxx`` (for no threading with C++) or ``-ldmallocthcxx`` (for threading with C++). The library locations are all set up when the *forge* module is loaded so these libraries should be found without further arguments.

Remote Client
--------------
The Arm Tools can connect to remote systems using SSH for you so you can run the user interface on your desktop or laptop machine without the need for X forwarding. Native remote clients are available for Windows, Mac OS X and Linux. You can download the remote clients from the `Arm website <https://developer.arm.com/tools-and-software/server-and-hpc/downloads/arm-forge>`__. No license file is required by a remote client. 

You can find more detailed information `here <https://developer.arm.com/documentation/101136/2011/Arm-Forge/Connecting-to-a-remote-system>`__.

.. note:: The same versions of Arm Forge must be installed on the local and remote systems in order to use DDT remotely.

Getting further help on DDT
---------------------------

-  `DDT website <https://www.arm.com/products/development-tools/server-and-hpc/forge/ddt>`__
-  `DDT user guide <https://developer.arm.com/documentation/101136/2011/DDT>`__
