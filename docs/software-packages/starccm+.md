# STAR-CCM+

STAR-CCM+ is a computational fluid dynamics (CFD) code and beyond. It
provides a broad range of validated models to simulate disciplines and
physics including CFD, computational solid mechanics (CSM),
electromagnetics, heat transfer, multiphase flow, particle dynamics,
reacting flow, electrochemistry, aero-acoustics and rheology; the
simulation of rigid and flexible body motions with techniques including
mesh morphing, overset mesh and six degrees of freedom (6DOF) motion;
and the ability to combine and account for the interaction between the
various physics and motion models in a single simulation to cover your
specific application.

## Useful Links

> - [Information about STAR-CCM+ by
>   Siemens](https://mdx.plm.automation.siemens.com/star-ccm-plus)

## Licensing

All users must provide their own licence for STAR-CCM+. Currently we
only support Power on Demand (PoD) licenses

For queries about other types of license options please contact the
[Cirrus Helpdesk](mailto:support@cirrus.ac.uk) with the relevant
details.

## Using STAR-CCM+ on Cirrus: Interactive remote GUI Mode

A fast and responsive way of running with a GUI is to install STAR-CCM+
on your local Windows(7 or 10) or Linux workstation. You can then start
your local STAR-CCM+ and connect to Cirrus in order to submit new jobs
or query the status of running jobs.

You will need to setup passwordless SSH connections to Cirrus.

### Jobs using Power on Demand (PoD) licences

You can then start the STAR-CCM+ server on the compute nodes. The
following script starts the server:

    #!/bin/bash

    # Slurm job options (name, compute nodes, job time)
    #SBATCH --job-name=STAR-CCM_test
    #SBATCH --time=0:20:0
    #SBATCH --exclusive
    #SBATCH --nodes=14
    #SBATCH --tasks-per-node=36
    #SBATCH --cpus-per-task=1

    # Replace [budget code] below with your budget code (e.g. t01)
    #SBATCH --account=[budget code]
    # Replace [partition name] below with your partition name (e.g. standard,gpu)
    #SBATCH --partition=[partition name]
    # Replace [qos name] below with your qos name (e.g. standard,long,gpu)
    #SBATCH --qos=[qos name]

    # Load the default HPE MPI environment
    module load mpt
    module load starccm+

    export SGI_MPI_HOME=$MPI_ROOT
    export PATH=$STARCCM_EXE:$PATH
    export LM_LICENSE_FILE=48001@192.168.191.10
    export CDLMD_LICENSE_FILE=48001@192.168.191.10

    scontrol show hostnames $SLURM_NODELIST > ./starccm.launcher.host.$SLURM_JOB_ID.txt
    starccm+ -clientldlibpath /scratch/sw/libnsl/1.3.0/lib/ -ldlibpath /scratch/sw/libnsl/1.3.0/lib/ -power -podkey <PODkey> -licpath 48001@192.168.191.10 -server -machinefile ./starccm.launcher.host.$SLURM_JOB_ID.txt -np 504 -rsh ssh 

You should replace "<PODkey\>" with your PoD licence key.

### Automatically load and start a Star-CCM+ simulation

You can use the "-batch" option to automatically load and start a
Star-CCM+ simulation.

Your submission script will look like this (the only difference with the
previous examples is the "starccm+" line)

    #!/bin/bash

    # Slurm job options (name, compute nodes, job time)
    #SBATCH --job-name=STAR-CCM_test
    #SBATCH --time=0:20:0
    #SBATCH --exclusive
    #SBATCH --nodes=14
    #SBATCH --tasks-per-node=36
    #SBATCH --cpus-per-task=1

    # Replace [budget code] below with your budget code (e.g. t01)
    #SBATCH --account=[budget code]
    # Replace [partition name] below with your partition name (e.g. standard,gpu)
    #SBATCH --partition=[partition name]
    # Replace [qos name] below with your qos name (e.g. standard,long,gpu)
    #SBATCH --qos=[qos name]

    # Load the default HPE MPI environment
    module load mpt
    module load starccm+

    export SGI_MPI_HOME=$MPI_ROOT
    export PATH=$STARCCM_EXE:$PATH
    export LM_LICENSE_FILE=48001@192.168.191.10
    export CDLMD_LICENSE_FILE=48001@192.168.191.10

    scontrol show hostnames $SLURM_NODELIST > ./starccm.launcher.host.$SLURM_JOB_ID.txt
    starccm+ -clientldlibpath /scratch/sw/libnsl/1.3.0/lib/ -ldlibpath /scratch/sw/libnsl/1.3.0/lib/ -power -podkey <PODkey> -licpath 48001@192.168.191.10 -batch simulation.java -machinefile ./starccm.launcher.host.$SLURM_JOB_ID.txt -np 504 -rsh ssh

This script will load the file "simulation.java". You can find
instructions on how to write a suitable "simulation.java"
[here](https://mdx.plm.automation.siemens.com/star-ccm-plus)

The file "simulation.java" must be in the same directory as your Slurm
submission script (or you can provide a full path).

### Local Star-CCM+ client configuration

Start your local STAR-CCM+ application and connect to your server. Click
on the File -\> "Connect to Server..." option and use the following
settings:

- Host: name of first Cirrus compute node (use 'qtsat', e.g. r1i0n32)
- Port: the number that you specified in the submission script

Select the "Connect through SSH tunnel" option and use:

- SSH Tunnel Host: cirrus-login0.epcc.ed.ac.uk
- SSH Tunnel Host Username: use your Cirrus username
- SSH Options: -agent

Your local STAR-CCM+ client should now be connected to the remote
server. You should be able to run a new simulation or interact with an
existing one.
