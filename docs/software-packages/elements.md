# ELEMENTS

ELEMENTS is a computational fluid dynamics (CFD) software tool based on
the HELYX® package developed by ENGYS. The software features an advanced
open-source CFD simulation engine and a client-server GUI to provide a
flexible and cost-effective HPC solver platform for automotive and
motorsports design applications, including a dedicated virtual wind
tunnel wizard for external vehicle aerodynamics and other proven methods
for UHTM, HVAC, aeroacoustics, etc.

## Useful Links

- [Information about ELEMENTS](https://engys.com/products/elements)
- [Information about ENGYS](https://engys.com/about-us)

## Using ELEMENTS on Cirrus

ELEMENTS is only available on Cirrus to authorised users with a valid
license of the software. For any queries regarding ELEMENTS on Cirrus,
please [contact ENGYS](https://engys.com/contact-us) or the [Cirrus
Helpdesk](mailto:support@cirrus.ac.uk).

ELEMENTS applications can be run on Cirrus in two ways:

- Manually from the command line, using a SSH terminal to access the
  cluster's master node.
- Interactively from within the ELEMENTS GUI, using the dedicated
  client-server node to connect remotely to the cluster.

A complete user's guide to access ELEMENTS on demand via Cirrus is
provided by ENGYS as part of this service.

## Running ELEMENTS Jobs in Parallel

The standard execution of ELEMENTS applications on Cirrus is handled
through the command line using a submission script to control Slurm. A
basic submission script for running multiple ELEMENTS applications in
parallel using the SGI-MPT (Message Passing Toolkit) module is included
below. In this example the applications `helyxHexMesh`, `caseSetup` and
`helyxAero` are run sequentially using 4 nodes (144 cores).

    #!/bin/bash --login

    # Slurm job options (name, compute nodes, job time)
    #SBATCH --job-name=Test
    #SBATCH --time=1:00:00
    #SBATCH --exclusive
    #SBATCH --nodes=4
    #SBATCH --ntasks-per-node=36
    #SBATCH --cpus-per-task=1
    #SBATCH --output=test.out

    # Replace [budget code] below with your budget code (e.g. t01)
    #SBATCH --account=t01

    # Replace [partition name] below with your partition name (e.g. standard)
    #SBATCH --partition=standard


    # Replace [QoS name] below with your QoS name (e.g. commercial)
    #SBATCH --qos=commercial

    # Load any required modules
    module load gcc
    module load mpt

    # Load the HELYX-Core environment v3.5.0 (select version as needed, e.g. 3.5.0)
    source /scratch/sw/elements/v3.5.0/CORE/HELYXcore-3.5.0/platforms/activeBuild.shrc

    # Launch ELEMENTS applications in parallel
    export myoptions="-parallel"
    jobs="helyxHexMesh caseSetup helyxAero"

    for job in `echo $jobs`
    do

      case "$job" in
       *                )   options="$myoptions" ;;
      esac

      srun $job $myoptions 2>&1 | tee log/$job.$SLURM_JOB_ID.out

    done

Alternatively, the user can execute most ELEMENTS applications on Cirrus
interactively via the GUI by following these simple steps:

1.  Launch ELEMENTS GUI in your local Windows or Linux machine.
2.  Create a client-server connection to Cirrus using the dedicated node
    provided for this service in the GUI. Enter your Cirrus user login
    details and the total number of processors to be employed in the
    cluster for parallel execution.
3.  Use the GUI in the local machine to access the remote file system in
    Cirrus to load a geometry, create a computational grid, set up a
    simulation, solve the flow, and post-process the results using the
    HPC resources available in the cluster. The Slurm scheduling
    associated with every ELEMENTS job is handled automatically by the
    client-server.
4.  Visualise the remote data from your local machine, perform changes
    to the model and complete as many flow simulations in Cirrus as
    required, all interactively from within the GUI.
5.  Disconnect the client-server at any point during execution, leave a
    utility or solver running in the cluster, and resume the connection
    to Cirrus from another client machine to reload an existing case in
    the GUI when needed.
