# Using R on Cirrus

[R](https://www.r-project.org/) is a software environment for
statistical computing and graphics. It provides a wide variety of
statistical and graphical techniques (linear and nonlinear modelling,
statistical tests, time-series analysis, classification, clustering,
and so on).

!!! note "Load `cray-R` module"
    When you log onto Cirrus, no R module is loaded by
    default. You need to load the `cray-R` module to access the
    functionality described below.

## The `cray-R` module

The recommended version of R to use on Cirrus is the HPE Cray R
distribution, which can be loaded using:

```
module load cray-R
```

### Packages available

The HPE Cray R distribution includes a range of common R packages, including all of the base packages, plus a few others.

To see what packages are available, run the R command

```
library()
```

--from the R command prompt.

At the time of writing, the HPE Cray R distribution included the following packages:


```
Packages in library '/opt/cray/pe/R/4.4.0/lib64/R/library':

base                    The R Base Package
boot                    Bootstrap Functions (Originally by Angelo Canty
                        for S)
class                   Functions for Classification
cluster                 "Finding Groups in Data": Cluster Analysis
                        Extended Rousseeuw et al.
codetools               Code Analysis Tools for R
compiler                The R Compiler Package
datasets                The R Datasets Package
foreign                 Read Data Stored by 'Minitab', 'S', 'SAS',
                        'SPSS', 'Stata', 'Systat', 'Weka', 'dBase', ...
graphics                The R Graphics Package
grDevices               The R Graphics Devices and Support for Colours
                        and Fonts
grid                    The Grid Graphics Package
KernSmooth              Functions for Kernel Smoothing Supporting Wand
                        & Jones (1995)
lattice                 Trellis Graphics for R
MASS                    Support Functions and Datasets for Venables and
                        Ripley's MASS
Matrix                  Sparse and Dense Matrix Classes and Methods
methods                 Formal Methods and Classes
mgcv                    Mixed GAM Computation Vehicle with Automatic
                        Smoothness Estimation
nlme                    Linear and Nonlinear Mixed Effects Models
nnet                    Feed-Forward Neural Networks and Multinomial
                        Log-Linear Models
parallel                Support for Parallel Computation in R
rpart                   Recursive Partitioning and Regression Trees
spatial                 Functions for Kriging and Point Pattern
                        Analysis
splines                 Regression Spline Functions and Classes
stats                   The R Stats Package
stats4                  Statistical Functions using S4 Classes
survival                Survival Analysis
tcltk                   Tcl/Tk Interface
tools                   Tools for Package Development
utils                   The R Utils Package
```

## Running R on the compute nodes

In this section, we provide an example R job submission scripts for
using R on the Cirrus compute nodes.

### Serial R submission script

```slurm
#!/bin/bash --login

#SBATCH --job-name=r_test
#SBATCH --ntasks=1
#SBATCH --time=00:10:00

# Replace [budget code] below with your project code (e.g., t01)
#SBATCH --account=[budget code]
#SBATCH --partition=standard
#SBATCH --qos=standard

# Load the R module
module load cray-R

# Run your R progamme
Rscript my_script.R
```

On completion, the output of the R script will be available in the job output file.

## Adding additional R packages

As the home file system is not available on the compute nodes, you must install 
additional R packages in a location on the work file system. The simplest way of
doing this is to use the `R_LIBS` environment variable. 

In addition, you must ensure that the GCC compiler environment it loaded so that
compiled packages are built using the same compiler as used for the core R 
install by using the command `module load PrgEnv-gcc` before you enter the R
environment and add packages.

For example, if you are user `auser` in the `t01` project and want to add the 
`xts` R package (as the first custom package you have ever added), then you would:

1. Switch to GCC compiler environment:
   ```
   [auser@login02 auser]$ module load PrgEnv-gnu
   ```

2. Load the `cray-R` module:
   ```
   [auser@login02 auser]$ module load cray-R
   ```

3. Move to the work directory and create a directory to hold custom R package
   installs (called `R-packages` in this example):
   ```
   [auser@login02 auser]$ cd /work/t01/t01/auser
   [auser@login02 auser]$ mkdir R-packages
   ```
   **Note:** If you already created a directory like this for previous custom package
   installs, you can skip this step.

4. Set the `R_LIBS` environment variable to point to the new directory you 
   just created
   ```
   [auser@login02 auser]$ export R_LIBS=/work/t01/t01/auser/R-packages
   ```

5. Start R and install the `xts` package:
   ```
   [auser@login02 auser]$ R

   R version 4.4.0 (2024-04-24) -- "Puppy Cup"
   Copyright (C) 2024 The R Foundation for Statistical Computing
   Platform: x86_64-redhat-linux-gnu

   R is free software and comes with ABSOLUTELY NO WARRANTY.
   You are welcome to redistribute it under certain conditions.
   Type 'license()' or 'licence()' for distribution details.

   Natural language support but running in an English locale

   R is a collaborative project with many contributors.
   Type 'contributors()' for more information and
   'citation()' on how to cite R or R packages in publications.

   Type 'demo()' for some demos, 'help()' for on-line help, or
   'help.start()' for an HTML browser interface to help.
   Type 'q()' to quit R.

   > install.packages("xts")
   Installing package into '/mnt/lustre/e1000/home/t01/t01/auser/R-packages'
   (as 'lib' is unspecified)
   ...
   ```

!!! important "Remember to set R_LIBS at runtime"
    You must set `R_LIBS` to point to your custom directory each time you want
    to use R and use packages you have installed using:
    ```
    export R_LIBS=/work/t01/t01/auser/R-packages
    ```

    If you do not do this, the custom packages you have installed will not be
    available in R.

