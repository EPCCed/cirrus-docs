MATLAB
======

`MATLAB <https://uk.mathworks.com>`__ combines a desktop environment
tuned for iterative analysis and design processes with a programming
language that expresses matrix and array mathematics directly.


Useful Links
------------

* `MATLAB Documentation <https://uk.mathworks.com/help/index.html>`__

Using MATLAB on Cirrus
----------------------------

MATLAB R2018b is available on Cirrus.

This installation of MATLAB on Cirrus is covered by an Academic
License - for use in teaching, academic research, and meeting course
requirements at degree granting institutions only.  Not for
government, commercial, or other organizational use.

**If your use of MATLAB is not covered by this license then please do
not use this installation.**  Please contact the `Cirrus Helpdesk
<http://www.cirrus.ac.uk/support/>`__ to arrange use of your own
MATLAB license on Cirrus.

This is MATLAB Version 9.5.0.1033004 (R2018b) Update 2 and provides the
following toolboxes ::

 MATLAB                                  Version 9.5
 Simulink                                Version 9.2
 5G Toolbox                              Version 1.0
 Aerospace Blockset                      Version 4.0
 Aerospace Toolbox                       Version 3.0
 Antenna Toolbox                         Version 3.2
 Audio System Toolbox                    Version 1.5
 Automated Driving System Toolbox        Version 1.3
 Bioinformatics Toolbox                  Version 4.11
 Communications Toolbox                  Version 7.0
 Computer Vision System Toolbox          Version 8.2
 Control System Toolbox                  Version 10.5
 Curve Fitting Toolbox                   Version 3.5.8
 DO Qualification Kit                    Version 3.6
 DSP System Toolbox                      Version 9.7
 Database Toolbox                        Version 9.0
 Datafeed Toolbox                        Version 5.8
 Deep Learning Toolbox                   Version 12.0
 Econometrics Toolbox                    Version 5.1
 Embedded Coder                          Version 7.1
 Filter Design HDL Coder                 Version 3.1.4
 Financial Instruments Toolbox           Version 2.8
 Financial Toolbox                       Version 5.12
 Fixed-Point Designer                    Version 6.2
 Fuzzy Logic Toolbox                     Version 2.4
 GPU Coder                               Version 1.2
 Global Optimization Toolbox             Version 4.0
 HDL Coder                               Version 3.13
 HDL Verifier                            Version 5.5
 IEC Certification Kit                   Version 3.12
 Image Acquisition Toolbox               Version 5.5
 Image Processing Toolbox                Version 10.3
 Instrument Control Toolbox              Version 3.14
 LTE HDL Toolbox                         Version 1.2
 LTE Toolbox                             Version 3.0
 MATLAB Coder                            Version 4.1
 MATLAB Distributed Computing Server     Version 6.13
 MATLAB Report Generator                 Version 5.5
 Mapping Toolbox                         Version 4.7
 Model Predictive Control Toolbox        Version 6.2
 Optimization Toolbox                    Version 8.2
 Parallel Computing Toolbox              Version 6.13
 Partial Differential Equation Toolbox   Version 3.1
 Phased Array System Toolbox             Version 4.0
 Polyspace Bug Finder                    Version 2.6
 Polyspace Code Prover                   Version 9.10
 Powertrain Blockset                     Version 1.4
 Predictive Maintenance Toolbox          Version 1.1
 RF Blockset                             Version 7.1
 RF Toolbox                              Version 3.5
 Risk Management Toolbox                 Version 1.4
 Robotics System Toolbox                 Version 2.1
 Robust Control Toolbox                  Version 6.5
 Sensor Fusion and Tracking Toolbox      Version 1.0
 Signal Processing Toolbox               Version 8.1
 SimBiology                              Version 5.8.1
 SimEvents                               Version 5.5
 Simscape                                Version 4.5
 Simscape Driveline                      Version 2.15
 Simscape Electrical                     Version 7.0
 Simscape Fluids                         Version 2.5
 Simscape Multibody                      Version 6.0
 Simulink 3D Animation                   Version 8.1
 Simulink Check                          Version 4.2
 Simulink Code Inspector                 Version 3.3
 Simulink Coder                          Version 9.0
 Simulink Control Design                 Version 5.2
 Simulink Coverage                       Version 4.2
 Simulink Design Optimization            Version 3.5
 Simulink Report Generator               Version 5.5
 Simulink Requirements                   Version 1.2
 Simulink Test                           Version 2.5
 Stateflow                               Version 9.2
 Statistics and Machine Learning Toolbox Version 11.4
 Symbolic Math Toolbox                   Version 8.2
 System Identification Toolbox           Version 9.9
 Text Analytics Toolbox                  Version 1.2
 Trading Toolbox                         Version 3.5
 Vehicle Dynamics Blockset               Version 1.1
 Vehicle Network Toolbox                 Version 4.1
 Vision HDL Toolbox                      Version 1.7
 WLAN Toolbox                            Version 2.0
 Wavelet Toolbox                         Version 5.1
  
Running parallel MATLAB jobs
-----------------------------------

On Cirrus, MATLAB is intended to be used on the compute nodes within
PBS job scripts.  Use on the login nodes should be restricted to
setting preferences, accessing help, etc.  It is recommended that
MATLAB is used without a GUI on the compute nodes, as the interactive
response is slow.

The license for this installation of MATLAB provides only 32 workers
via MATLAB Distributed Computing Server (MDCS) but provides 36 workers
via the local cluster profile (there are 36 cores on a Cirrus compute
node), so we do not recommend the use of MDCS for parallel
computations.

MATLAB will normally use up to the total number of cores on a node for
multi-threaded operations (e.g., matrix inversions) and for parallel
computations.  It also makes no restriction on its memory use.  These
features are incompatible with the shared use of nodes on Cirrus.  A
wrapper script is provided to limit the number of cores and amount of
memory used, in proportion to the number of CPUs selected in the PBS
job script.  Please use this wrapper instead of using MATLAB directly.

Say you have a job that requires 3 workers, each running 2 threads.
As such, you should employ 3x2=6 physical cores (we find running
MATLAB without hyper-threading gives best performance).  An example
job script for this particular case would be ::

 #PBS -N Example_MATLAB_Job

 #PBS -l select=1:ncpus=6
 #PBS -l walltime=00:20:00
 
 # Replace [budget code] below with your project code (e.g. t01)
 #PBS -A [budget code]
 
 # Change to the directory that the job was submitted from
 cd $PBS_O_WORKDIR
 
 module load matlab
 
 matlab_wrapper -nodisplay < /lustre/sw/cse-matlab/examples/testp.m > testp.log

This would run the *testp.m* script, without a display, and exit when
*testp.m* has finished.  6 CPUs are selected, which correspond to 6
cores, and the following limits would be set initially ::

 ncores = 6
 memory = 42GB

 Maximum number of computational threads (maxNumCompThreads)          = 6
 Preferred number of workers in a parallel pool (PreferredNumWorkers) = 6
 Number of workers to start on your local machine (NumWorkers)        = 6
 Number of computational threads to use on each worker (NumThreads)   = 1

The *testp.m* program sets *NumWorkers* to 3 and *NumThreads* to 2 ::

 cirrus_cluster = parcluster('local');
 ncores = cirrus_cluster.NumWorkers * cirrus_cluster.NumThreads;
 cirrus_cluster.NumWorkers = 3;
 cirrus_cluster.NumThreads = 2;
 fprintf("NumWorkers = %d NumThreads = %d ncores = %d\n",cirrus_cluster.NumWorkers,cirrus_cluster.NumThreads,ncores);
 if cirrus_cluster.NumWorkers * cirrus_cluster.NumThreads > ncores
     disp("NumWorkers * NumThreads > ncores");
     disp("Exiting");
     exit(1);
 end
 saveProfile(cirrus_cluster);
 clear cirrus_cluster;

Note that *PreferredNumWorkers*, *NumWorkers* and *NumThreads* persist
between MATLAB sessions but will be updated correctly if you use the
wrapper each time.

*NumWorkers* and *NumThreads* can be changed (using *parcluster*
and *saveProfile*) but *NumWorkers* * *NumThreads* should be less than
or equal to the number of cores (*ncores* above).  If you wish a
worker to run a threaded routine in serial, you must set *NumThreads*
to 1 (the default).

If you specify exclusive node access, then all the cores and memory
will be available.  On the login nodes, a single core is used and
memory is not limited.
