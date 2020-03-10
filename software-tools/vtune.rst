Profiling using Intel Vtune
===========================
The Intel VTune Amplifier is a performance profiling tool for analysis and tuning software applications. To use this package
you will need to load one of the version of Intel Vtune:

::

    module load intel-vtune-19


Hotspots analysis
---------------------------------
To profile your code and obtain a Hotspot analysis, you will need to follow these steps:

1. Ccompile your code with ``-g`` to generate debug information that allows VTune Amplifier to correlate timing information with specific locations in your source code.

2. 


Debugging runs on the compute nodes
-----------------------------------

This involves DDT submitting your job to the queue, this then running and as soon as the compute nodes start executing you will drop into the debug session and be able to interact with your code. Similarly to running on the login node, fill in details of your application and ensure that MPI is ticked. But now change the implementation from *SGI MPT (2.10+)* to *SGI MPT (2.10+, batch)* as we are running via the batch system. Then check the *Submit to Queue* tick box and click the *Configure* button. In the settings window that pops up you can specify the submission template, one has been prepared one for Cirrus at ``/lustre/sw/allinea/forge-7.0.0/templates/cirrus.qtf`` which we suggest you use - although you are very free to chose another one and/or specialise this as you require. Back on the run page, click the *Parameters* button and fill in the maximum wallclock time, the budget to charge to and the total number of virtual cores required which determine the number of nodes and are provided as an argument to the *-l select=* PBS option. Back on the *run* dialog ensure look at the *MPI* pane, ensure the *number of processes* and *processes per node* settings are correct and then hit *Submit*.

Memory debugging with DDT
-------------------------

If you are dynamically linking your code and debugging it on the login node then this is fine (just ensure that the *Preload the memory debugging library* option is ticked in the *Details* pane.) If you are dynamically linking but intending to debug running on the compute nodes, or statically linking then you need to include the compile option ``-Wl,--allow-multiple-definition`` and explicitly link your executable with Allinea's memory debugging library. The exactly library to link against depends on your code; ``-ldmalloc`` (for no threading with C), ``-ldmallocth`` (for threading with C), ``-ldmallocxx`` (for no threading with C++) or ``-ldmallocthcxx`` (for threading with C++). The library locations are all set up when the *allinea* module is loaded so these libraries should be found without further arguments.

Getting further help on DDT
---------------------------

-  `DDT website <http://www.allinea.com/products/ddt/>`__
-  `DDT support page <https://www.allinea.com/get-support>`__
-  `DDT user guide <https://www.allinea.com/user-guide/forge/userguide.html>`__
