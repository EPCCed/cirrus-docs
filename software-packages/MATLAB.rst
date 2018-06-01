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

MATLAB R2016b is available on Cirrus.

This installation of MATLAB on Cirrus is covered by an Academic
License - for use in teaching, academic research, and meeting course
requirements at degree granting institutions only.  Not for
government, commercial, or other organizational use.

**If your use of MATLAB is not covered by this license then please do
not use this installation.**  Please contact the `Cirrus Helpdesk
<http://www.cirrus.ac.uk/support/>`__ to arrange use of your own
MATLAB license on Cirrus.

This is MATLAB Version 9.1.0.441655 (R2016b) and provides the
following toolboxes ::

 MATLAB                                   Version 9.1   
 Simulink                                 Version 8.8   
 Bioinformatics Toolbox                   Version 4.7   
 Communications System Toolbox            Version 6.3   
 Computer Vision System Toolbox           Version 7.2   
 Control System Toolbox                   Version 10.1  
 Curve Fitting Toolbox                    Version 3.5.4 
 DSP System Toolbox                       Version 9.3   
 Database Toolbox                         Version 7.0   
 Datafeed Toolbox                         Version 5.4   
 Econometrics Toolbox                     Version 3.5   
 Financial Instruments Toolbox            Version 2.4   
 Financial Toolbox                        Version 5.8   
 Fixed-Point Designer                     Version 5.3   
 Fuzzy Logic Toolbox                      Version 2.2.24
 Global Optimization Toolbox              Version 3.4.1 
 HDL Coder                                Version 3.9   
 HDL Verifier                             Version 5.1   
 Image Acquisition Toolbox                Version 5.1   
 Image Processing Toolbox                 Version 9.5   
 Instrument Control Toolbox               Version 3.10  
 LTE System Toolbox                       Version 2.3   
 MATLAB Coder                             Version 3.2   
 MATLAB Compiler                          Version 6.3   
 MATLAB Compiler SDK                      Version 6.3   
 MATLAB Report Generator                  Version 5.1   
 Mapping Toolbox                          Version 4.4   
 Neural Network Toolbox                   Version 9.1   
 Optimization Toolbox                     Version 7.5   
 Parallel Computing Toolbox               Version 6.9   
 Partial Differential Equation Toolbox    Version 2.3   
 Phased Array System Toolbox              Version 3.3   
 RF Toolbox                               Version 3.1   
 Robust Control Toolbox                   Version 6.2   
 Signal Processing Toolbox                Version 7.3   
 SimBiology                               Version 5.5   
 SimEvents                                Version 5.1   
 Simscape                                 Version 4.1   
 Simscape Multibody                       Version 4.9   
 Simscape Power Systems                   Version 6.6   
 Simulink 3D Animation                    Version 7.6   
 Simulink Coder                           Version 8.11  
 Simulink Control Design                  Version 4.4   
 Simulink Design Optimization             Version 3.1   
 Stateflow                                Version 8.8   
 Statistics and Machine Learning Toolbox  Version 11.0  
 Symbolic Math Toolbox                    Version 7.1   
 System Identification Toolbox            Version 9.5   
 Wavelet Toolbox                          Version 4.17  


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
computations.  Instead we recommend that a whole, single compute node
is used.  Cirrus employs exclusive node usage, thus requesting a
whole, single node will provide 36 physical cores.  MATLAB will use up
to the total number of physical cores on a compute node for
multi-threaded operations (e.g., matrix inversions) and for parallel
workers.

An example job script would be ::

 #PBS -N Example_MATLAB_Job
 # Select a whole, single node; ncpus=72 because there are
 # 2 HyperThreads per physical core
 #PBS -l select=1:ncpus=72
 #PBS -l walltime=00:20:00
 
 # Replace [budget code] below with your project code (e.g. t01)
 #PBS -A [budget code]
 
 # Change to the directory that the job was submitted from
 cd $PBS_O_WORKDIR
 
 module load matlab
 
 matlab_wrapper -nodisplay < /lustre/sw/cse-matlab/examples/testp.m > testp.log

This would run the *testp.m* script, without a display, and exit when
*testp.m* has finished.

*NumWorkers* and *NumThreads* can be changed in MATLAB (using
*parcluster* and *saveProfile*) but *NumWorkers* x *NumThreads* should
no greater than 36.  If each worker runs a threaded routine, then
setting *NumThreads* to 1 (the default) will ensure that each worker runs threaded
routines serially.  If you want to run these routines in parallel,
you must set *NumThreads* accordingly.
