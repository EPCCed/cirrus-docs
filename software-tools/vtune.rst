Profiling using Intel Vtune
===========================
The Intel VTune Amplifier is a performance profiling tool for analysis and tuning software applications. The different analysis types include: Basic Hotspots; Advanced Hotspots; Concurrency; and Locks and Waits. To use this package you will need to load one of the version of Intel Vtune:

::

    module load intel-vtune-19


Hotspots analysis
---------------------------------
To profile your code and obtain a Hotspot analysis, you will need to follow these steps:

1. Compile your code with ``-g`` to generate debug information that allows VTune Amplifier to correlate timing information with specific locations in your source code.

2. Run the ``amplxe-cl`` command line tool.  Use the ``-collect`` (or ``-c``) option to run the hotspots collection and the ``-result-dir`` (or ``-r``) option to specify a directory.

::

   mpirun -n 36 -ppn 36 amplxe-cl -collect hotspots -result-dir r000hs -- ./stride.exe


Viewing Results with the VTune 
-------------------------------
Once data are collected, we can view the results using VTune graphical user interface (GUI) or
the command line tools.

GUI
^^^
Open the VTune GUI application runing ``amplxe-gui`` and load the experiments.

.. image:: Vtune.png
	   

Command-line
^^^^^^^^^^^^
You can also use the ``amplxe-cl`` command with the ``-report`` option to generate a report, as follows:
::
   amplxe-cl -report hotspots -r r000hs -report-output output

To display a call tree and provide CPU time for each function:
::
   amplxe-cl -report top-down -r r000hs


Memory debugging with DDT
-------------------------

If you are dynamically linking your code and debugging it on the login node then this is fine (just ensure that the *Preload the memory debugging library* option is ticked in the *Details* pane.) If you are dynamically linking but intending to debug running on the compute nodes, or statically linking then you need to include the compile option ``-Wl,--allow-multiple-definition`` and explicitly link your executable with Allinea's memory debugging library. The exactly library to link against depends on your code; ``-ldmalloc`` (for no threading with C), ``-ldmallocth`` (for threading with C), ``-ldmallocxx`` (for no threading with C++) or ``-ldmallocthcxx`` (for threading with C++). The library locations are all set up when the *allinea* module is loaded so these libraries should be found without further arguments.

Getting further help on Intel Vtune
-----------------------------------

-  `Intel VTune documentation <https://software.intel.com/en-us/vtune/documentation/get-started/>`__

