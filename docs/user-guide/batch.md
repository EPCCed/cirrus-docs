# Running Jobs on Cirrus

As with most HPC services, Cirrus uses a scheduler to manage access to
resources and ensure that the thousands of different users of system are
able to share the system and all get access to the resources they
require. Cirrus uses the Slurm software to schedule jobs.

Writing a submission script is typically the most convenient way to
submit your job to the scheduler. Example submission scripts (with
explanations) for the most common job types are provided below.

Interactive jobs are also available and can be particularly useful for
developing and debugging applications. More details are available below.


!!! Hint

    If you have any questions on how to run jobs on Cirrus do not hesitate to contact the
    [Cirrus Service Desk](mailto:support@cirrus.ac.uk).



You typically interact with Slurm by issuing Slurm commands from the
login nodes (to submit, check and cancel jobs), and by specifying Slurm
directives that describe the resources required for your jobs in job
submission scripts.

## Use of the `/work` file system

Jobs executing in the batch system should use the `/work` file system. In
particular, the `/home` file system (including home directories `${HOME}`)
are not available to batch jobs. All relevant software installation, scripts,
executable files, and input data should be stored in an appropriate
location in `/work` before submitting batch jobs.


## Basic Slurm commands

There are three key commands used to interact with the Slurm on the
command line:

- `sinfo` - Get information on the partitions and resources available
- `sbatch jobscript.slurm` - Submit a job submission script (in this
  case called: `jobscript.slurm`) to the scheduler
- `squeue` - Get the current status of jobs submitted to the scheduler
- `scancel 12345` - Cancel a job (in this case with the job ID `12345`)

We cover each of these commands in more detail below.

### `sinfo`: information on resources

`sinfo` is used to query information about available resources and
partitions. Without any options, `sinfo` lists the status of all
resources and partitions, e.g.

```bash
[auser@login01 ~]$ sinfo

PARTITION AVAIL  TIMELIMIT  NODES  STATE NODELIST
Compute*     up   infinite      4 drain* cs-n[0086-0087,0112-0113]
Compute*     up   infinite      3  down* cs-n[0050-0051,0170]
Compute*     up   infinite      4  drain cs-n[0019,0104,0165,0239]
Compute*     up   infinite      1  alloc cs-n0166
Compute*     up   infinite    244   idle cs-n[0000-0018,0020-0049,0052-0085,0088-0103,0105-0111,0114-0164,0167-0169,0171-0238,0240-0255]
```

### `sbatch`: submitting jobs

`sbatch` is used to submit a job script to the job submission system.
The script will typically contain one or more `srun` commands to launch
parallel tasks.

When you submit the job, the scheduler provides the job ID, which is
used to identify this job in other Slurm commands and when looking at
resource usage in SAFE.

```bash
[auser@login01 ~]$ sbatch test-job.slurm
Submitted batch job 12345
```

### `squeue`: monitoring jobs

`squeue` without any options or arguments shows the current status of
all jobs known to the scheduler. For example:

```bash
[auser@login01 ~]$ squeue
          JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
          1554  comp-cse CASTEP_a  auser  R       0:03      2 cs-n01[18-19]
```

will list all jobs on Cirrus.

The output of this is often overwhelmingly large. You can restrict the
output to just your jobs by adding the `--me` option:

```bash
[auser@login01 ~]$ squeue --me
```

### `scancel`: deleting jobs

`scancel` is used to delete a jobs from the scheduler. If the job is
waiting to run it is simply cancelled, if it is a running job then it is
stopped immediately. You need to provide the job ID of the job you wish
to cancel/stop. For example:

[auser@login01 ~]$ scancel 12345

will cancel (if waiting) or stop (if running) the job with ID `12345`.

## Resource Limits


!!! Note

	If you have requirements which do not fit within the current QoS, please
  contact the Service Desk and we can discuss how to accommodate your requirements.

There are different resource limits on Cirrus for different purposes.
There are three different things you need to specify for each job:

- The amount of *primary resource* you require (more information on this
  below)
- The *partition* that you want to use - this specifies the nodes that
  are eligible to run your job
- The *Quality of Service (QoS)* that you want to use - this specifies
  the job limits that apply

Each of these aspects are described in more detail below.


!!! Warning
    On Cirrus, you cannot specify the memory for a job using the `--mem`
    options to Slurm (e.g. `--mem`, `--mem-per-cpu`). The
    amount of memory you are assigned is calculated from the amount of
    primary resource you request.


### Primary resources on CPU compute nodes

The *primary resource* you request on standard compute nodes are CPU
cores. The maximum amount of memory you are allocated is computed as the
number of CPU cores you requested multiplied by 1/288th of the total
memory available (as there are 288 CPU cores per node). So, if you
request the full node (288 cores), then you will be allocated a maximum
of all of the memory (768 GB or 1,536 GB) available on the node; however,
if you request 1 core, then you will be assigned a maximum of 768/288 = 2.66 GB
of the memory available on a standard memory node or 5.33 GB on a high 
memory node.

!!! Note
    Using the `--exclusive` option in jobs will give you access to the full
    node memory even if you do not explicitly request all of the CPU cores
    on the node.


!!! Warning
    Using the `--exclusive` option will charge your account for the usage of
    the entire node, even if you don't request all the cores in your
    scripts.

!!! Note
    You will not generally have access to the full amount of memory resource
    on the the node as some is retained for running the operating system and
    other system processes.

### Partitions

On Cirrus, compute nodes are grouped into partitions. You will have to
specify a partition using the `--partition` option in your submission
script. The following table has a list of active partitions on Cirrus.

| Partition | Description                                                                                   | Total nodes available | Notes |
|-----------|-----------------------------------------------------------------------------------------------|-----------------------|-------|
| standard  | CPU nodes with 2x 144-core AMD EPYC 9825 processors, 768 GB or 1,536 GB memory                           | 256                   |       |
| highmem   | CPU nodes with 2x 144-core AMD EPYC 9825 processors, 1,536 GB memory                          | 64                     |       |

You can list the active partitions using

    sinfo

!!! Note
    You may not have access to all the available partitions.

### Quality of Service (QoS)

On Cirrus Quality of Service (QoS) is used alongside partitions to set
resource limits. The following table has a list of active QoS on Cirrus.
Note that the number of jobs queued includes both pending and running
jobs.

| QoS Name     | Jobs Running Per User | Jobs Queued Per User | Max Walltime | Max Size                                | Applies to Partitions | Notes |
|--------------|-----------------------|----------------------|--------------|-----------------------------------------|-----------------------|-------|
| standard     | No limit              | 256 jobs             | 48 hours       | 64 nodes              | standard, highmem              | Maximum of 64 nodes in use by any one user at any time.      |
| largescale   | 1 job                 | 4 jobs               | 24 hours     | 192 nodes | standard         |       |
| long         | No limit              | 128 jobs             | 4 days       | 16 nodes                     | standard         | Maximum of 64 nodes in use by any one user at any time. Maximum of 128 nodes in use by this QoS.      |
| highpriority | No limit               | 256 jobs              | 48 hours       | 128 nodes                               | standard, highmem              | Chargd at 1.5x normal rate. Maximum of 128 nodes in use by any one user at any time. Maximum of 128 nodes in use by this QoS. |
| short        | 1 job                 | 2 jobs               | 20 minutes   | 2 nodes                       | standard         |       |
| lowpriority  | No limit              | 100 jobs             | 24 hours       | 64 nodes     | standard        | Usage is not charged. Not available to industrial projects. |
| industry  |              |             |       |      |        | Not available to academic projects. |
| reservation  | No limit              | No limit             | No limit       | No limit     | standard, highmem        | Only usuable within reservation. |

#### Cirrus QoS

You can find out the QoS that you can use by running the following
command:

    sacctmgr show assoc user=$USER cluster=cirrus format=cluster,account,user,qos%50

## Troubleshooting

### Slurm error handling

#### MPI jobs

Users of MPI codes may wish to ensure termination of all tasks on the
failure of one individual task by specifying the `--kill-on-bad-exit`
argument to `srun`. E.g.,

``` bash
srun -n 288 --kill-on-bad-exit ./my-mpi-program
```

This can prevent effective "hanging" of the job until the wall time
limit is reached.

#### Automatic resubmission

Jobs that fail are not automatically resubmitted by Slurm on Cirrus.
Automatic resubmission can be enabled for a job by specifying the
`--requeue` option to `sbatch`.

### Slurm error messages

An incorrect submission will cause Slurm to return an error. Some common
problems are listed below, with a suggestion about the likely cause:

- `sbatch: unrecognized option <text>`

  - One of your options is invalid or has a typo. `man sbatch` to help.

- `error: Batch job submission failed: No partition specified or system default partition`

  > A `--partition=` option is missing. You must specify the partition
  > (see the list above). This is most often `--partition=standard`.

- `error: invalid partition specified: <partition>`

  > `error: Batch job submission failed: Invalid partition name specified`
  >
  > Check the partition exists and check the spelling is correct.

- `error: Batch job submission failed: Invalid account or account/partition combination specified`

  > This probably means an invalid account has been given. Check the
  > `--account=` options against valid accounts in SAFE.

- `error: Batch job submission failed: Invalid qos specification`

  > A QoS option is either missing or invalid. Check the script has a
  > `--qos=` option and that the option is a valid one from the table
  > above. (Check the spelling of the QoS is correct.)

- `error: Your job has no time specification (--time=)...`

  > Add an option of the form `--time=hours:minutes:seconds` to the
  > submission script. E.g., `--time=01:30:00` gives a time limit of 90
  > minutes.

- `error: QOSMaxWallDurationPerJobLimit`
  `error: Batch job submission failed: Job violates accounting/QOS policy`
  `(job submit limit, user's size and/or time limits)`

  The script has probably specified a time limit which is too long for
  the corresponding QoS. E.g., the time limit for the short QoS is 20
  minutes.

### Slurm queued reasons

The `squeue` command allows users to view information for jobs managed
by Slurm. Jobs typically go through the following states: PENDING,
RUNNING, COMPLETING, and COMPLETED. The first table provides a
description of some job state codes. The second table provides a
description of the reasons that cause a job to be in a state.

| Status        | Code | Description                                                                                                     |
|---------------|------|-----------------------------------------------------------------------------------------------------------------|
| PENDING       | PD   | Job is awaiting resource allocation.                                                                            |
| RUNNING       | R    | Job currently has an allocation.                                                                                |
| SUSPENDED     | S    | Job currently has an allocation.                                                                                |
| COMPLETING    | CG   | Job is in the process of completing. Some processes on some nodes may still be active.                          |
| COMPLETED     | CD   | Job has terminated all processes on all nodes with an exit code of zero.                                        |
| TIMEOUT       | TO   | Job terminated upon reaching its time limit.                                                                    |
| STOPPED       | ST   | Job has an allocation, but execution has been stopped with SIGSTOP signal. CPUS have been retained by this job. |
| OUT_OF_MEMORY | OOM  | Job experienced out of memory error.                                                                            |
| FAILED        | F    | Job terminated with non-zero exit code or other failure condition.                                              |
| NODE_FAIL     | NF   | Job terminated due to failure of one or more allocated nodes.                                                   |
| CANCELLED     | CA   | Job was explicitly cancelled by the user or system administrator. The job may or may not have been initiated.   |

Slurm Job State codes

For a full list of see [Job State
Codes](https://slurm.schedmd.com/squeue.html#lbAG)

| Reason               | Description                                                                                                                                                                                                                                                                                                                                                                                                                     |
|----------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Priority             | One or more higher priority jobs exist for this partition or advanced reservation.                                                                                                                                                                                                                                                                                                                                              |
| Resources            | The job is waiting for resources to become available.                                                                                                                                                                                                                                                                                                                                                                           |
| BadConstraints       | The job's constraints can not be satisfied.                                                                                                                                                                                                                                                                                                                                                                                     |
| BeginTime            | The job's earliest start time has not yet been reached.                                                                                                                                                                                                                                                                                                                                                                         |
| Dependency           | This job is waiting for a dependent job to complete.                                                                                                                                                                                                                                                                                                                                                                            |
| Licenses             | The job is waiting for a license.                                                                                                                                                                                                                                                                                                                                                                                               |
| WaitingForScheduling | No reason has been set for this job yet. Waiting for the scheduler to determine the appropriate reason.                                                                                                                                                                                                                                                                                                                         |
| Prolog               | Its PrologSlurmctld program is still running.                                                                                                                                                                                                                                                                                                                                                                                   |
| JobHeldAdmin         | The job is held by a system administrator.                                                                                                                                                                                                                                                                                                                                                                                      |
| JobHeldUser          | The job is held by the user.                                                                                                                                                                                                                                                                                                                                                                                                    |
| JobLaunchFailure     | The job could not be launched. This may be due to a file system problem, invalid program name, etc.                                                                                                                                                                                                                                                                                                                             |
| NonZeroExitCode      | The job terminated with a non-zero exit code.                                                                                                                                                                                                                                                                                                                                                                                   |
| InvalidAccount       | The job's account is invalid.                                                                                                                                                                                                                                                                                                                                                                                                   |
| InvalidQOS           | The job's QOS is invalid.                                                                                                                                                                                                                                                                                                                                                                                                       |
| QOSUsageThreshold    | Required QOS threshold has been breached.                                                                                                                                                                                                                                                                                                                                                                                       |
| QOSJobLimit          | The job's QOS has reached its maximum job count.                                                                                                                                                                                                                                                                                                                                                                                |
| QOSResourceLimit     | The job's QOS has reached some resource limit.                                                                                                                                                                                                                                                                                                                                                                                  |
| QOSTimeLimit         | The job's QOS has reached its time limit.                                                                                                                                                                                                                                                                                                                                                                                       |
| NodeDown             | A node required by the job is down.                                                                                                                                                                                                                                                                                                                                                                                             |
| TimeLimit            | The job exhausted its time limit.                                                                                                                                                                                                                                                                                                                                                                                               |
| ReqNodeNotAvail      | Some node specifically required by the job is not currently available. The node may currently be in use, reserved for another job, in an advanced reservation, DOWN, DRAINED, or not responding. Nodes which are DOWN, DRAINED, or not responding will be identified as part of the job's "reason" field as "UnavailableNodes". Such nodes will typically require the intervention of a system administrator to make available. |

Slurm Job Reasons

For a full list of see [Job
Reasons](https://slurm.schedmd.com/squeue.html#lbAF)

## Output from Slurm jobs

Slurm places standard output (STDOUT) and standard error (STDERR) for
each job in the file `slurm_<JobID>.out`. This file appears in the job's
working directory once your job starts running.


!!! Note
    This file is plain text and can contain useful information to help
    debugging if a job is not working as expected. The Cirrus Service Desk
    team will often ask you to provide the contents of this file if you
    contact them for help with issues.


## Specifying resources in job scripts

You specify the resources you require for your job using directives at
the top of your job submission script using lines that start with the
directive `#SBATCH`.

!!! Note
    Options provided using `#SBATCH` directives can also be specified as
    command line options to `sbatch`.

If you do not specify any options, then the default for each option will
be applied. As a minimum, all job submissions must specify the budget
that they wish to charge the job too, the partition they wish to use and
the QoS they want to use with the options:

 - `--account=<budgetID>` your budget ID is usually something like
   `t01` or `t01-test`. You can see which budget codes you can charge
   to in SAFE.
 - `--partition=<partition>` The partition specifies the set of nodes
   you want to run on. More information on available partitions is
   given above.
 - `--qos=<QoS>` The QoS specifies the limits to apply to your job.
   More information on available QoS are given above.

Other common options that are used are:

 - `--time=<hh:mm:ss>` the maximum walltime for your job. *e.g.* For a
   6.5 hour walltime, you would use `--time=6:30:0`.
 - `--job-name=<jobname>` set a name for the job to help identify it in
   Slurm command output.

In addition, parallel jobs will also need to specify how many nodes,
parallel processes and threads they require.

 - `--exclusive` to ensure that you have exclusive access to a compute
   node
 - `--nodes=<nodes>` the number of nodes to use for the job.
 - `--tasks-per-node=<processes per node>` the number of parallel
   processes (e.g. MPI ranks) per node.
 - `--cpus-per-task=<threads per task>` the number of threads per
   parallel process (e.g. number of OpenMP threads per MPI task for
   hybrid MPI/OpenMP jobs). **Note:** you must also set the
   `OMP_NUM_THREADS` environment variable if using OpenMP in your job
   and usually add the `--cpu-bind=cores` option to `srun`. See the
   example below for an MPI+OpenMP job for further notes on
   ``--cpus-per-task``.

!!! Note
    For parallel jobs, you should generally request exclusive node access with the
    `--exclusive` option to ensure you get the expected resources and
    performance.


!!! Note
    When submitting your job, the scheduler will check that the requested resources are available e.g. that your account
    is a member of the requested budget, that the requested QoS exists.

    If things change before the job starts and e.g. your account has been removed from the requested budget or the requested QoS has been deleted
    then the job will not be able to start.

    In such cases, the job will be removed from the pending queue by our systems team, as it will no longer be eligible to run.

## `srun`: Launching parallel jobs

If you are running parallel jobs, your job submission script should
contain one or more `srun` commands to launch the parallel executable
across the compute nodes. As well as launching the executable, `srun`
also allows you to specify the distribution and placement (or *pinning*)
of the parallel processes and threads.

If you are running MPI jobs that do not also use OpenMP threading, then
you should use `srun` with no additional options. `srun` will use the
specification of nodes and tasks from your job script, `sbatch` or
`salloc` command to launch the correct number of parallel tasks.

If you are using OpenMP threads then you will generally add the
`--cpu-bind=cores` option to `srun` to bind threads to cores to obtain
the best performance.

!!! Note
    See the example job submission scripts below for examples of using
    `srun` for pure MPI jobs and for jobs that use OpenMP threading.

## Example parallel job submission scripts

A subset of example job submission scripts are included in full below.

!!! Hint
    Do not replace `srun` with `mpirun` in the following examples. Although
    this might work under special circumstances, it is not guaranteed and
    therefore not supported.

### Example: job submission script for MPI parallel job

A simple MPI job submission script to submit a job using 2 compute nodes
and 576 MPI processes per node for 20 minutes would look like:

``` bash
#!/bin/bash

# Slurm job options (name, compute nodes, job time)
#SBATCH --job-name=Example_MPI_Job
#SBATCH --time=0:20:0
#SBATCH --exclusive
#SBATCH --nodes=2
#SBATCH --tasks-per-node=288
#SBATCH --cpus-per-task=1

# Replace [budget code] below with your budget code (e.g. t01)
#SBATCH --account=[budget code]
# We use the "standard" partition as we are running on CPU nodes
#SBATCH --partition=standard
# We use the "standard" QoS as our runtime is less than 4 days
#SBATCH --qos=standard

# Set the number of threads to 1
#   This prevents any threaded system libraries from automatically
#   using threading.
export OMP_NUM_THREADS=1

# Launch the parallel job
#   Using 144 MPI processes and 36 MPI processes per node
#   srun picks up the distribution from the sbatch options
srun --hint=nomultithread --distribution=block:block ./my_mpi_executable.x
```

This will run your executable "my_mpi_executable.x" in parallel on 576
MPI processes using 2 nodes (288 cores per node, i.e. not using
SMT). Slurm will allocate 2 nodes to your job and srun will
place 288 MPI processes on each node (one per physical core).

By default, srun will launch an MPI job that uses all of the cores you
have requested via the "nodes" and "tasks-per-node" options. If you want
to run fewer MPI processes than cores you will need to change the
script.

For example, to run this program on 512 MPI processes you have two
options:

 - set `--tasks-per-node=256` for an even distribution across nodes
   (this may not always be possible depending on the exact combination
   of nodes requested and MPI tasks required)
 - set the number of MPI tasks explicitly using `#SBATCH --ntasks=512`

!!! Note
    If you specify `--ntasks` explicitly and it is not compatible with the
    value of `tasks-per-node` then you will get a warning message from
    srun such as `srun: Warning: can't honor --ntasks-per-node set to 288`.

    In this case, srun does the sensible thing and allocates MPI processes
    as evenly as it can across nodes. For example, the second option above
    would result in 256 MPI processes on each of the 2 nodes.

See above for a more detailed discussion of the different `sbatch`
options.

#### Note on MPT task placement

By default, Slurm will distribute processss to physical cores (cores
0-35 on NUMA region 0, cores 36-71 on NUMA region 1, etc.) in a cyclic fashion. That
is, rank 0 would be placed on core 0, rank 1 on core 36, rank 2 on core
72, and so on (in a single-node job). This may be undesirable. Block,
rather than cyclic, distribution can be obtained with

``` bash
#SBATCH --distribution=block:block
```

The `block:block` here refers to the distribution on both nodes and
NUMA regions (Slurm on Cirrus is configured to treat NUMA regions as
separate sockets). This will distribute rank 0 for core 0, rank 1 to core 1, rank
2 to core 2, and so on.

### Example: job submission script for MPI+OpenMP (mixed mode) parallel job

Mixed mode codes that use both MPI (or another distributed memory
parallel model) and OpenMP should take care to ensure that the shared
memory portion of the process/thread placement does not span more than
one node. This means that the number of shared memory threads should be
a factor of 288.

In the example below, we are using 2 nodes for 6 hours. There are 48 MPI
processes in total (24 MPI processes per node) and 12 OpenMP threads per
MPI process. This results in all 288 physical cores per node being used.

!!! important
    Using 24 MPI processes per node (1 per CCD) and 12 OpenMP processes
    per MPI process is likely to be the highest number of OpenMP threads
    that will produce good performance as each 12-core CCD shares L3 
    cache.

!!! Note

	the use of the `--cpu-bind=cores` option to generate the correct
	affinity settings.

```slurm
#!/bin/bash

# Slurm job options (name, compute nodes, job time)
#SBATCH --job-name=Example_MPI_Job
#SBATCH --time=0:20:0
#SBATCH --exclusive
#SBATCH --nodes=2
#SBATCH --ntasks=48
#SBATCH --tasks-per-node=24
#SBATCH --cpus-per-task=12

# Replace [budget code] below with your project code (e.g. t01)
#SBATCH --account=[budget code]
# We use the "standard" partition as we are running on CPU nodes
#SBATCH --partition=standard
# We use the "standard" QoS as our runtime is less than 4 days
#SBATCH --qos=standard

# Change to the submission directory
cd $SLURM_SUBMIT_DIR

# Set the number of threads to 12
#   There are 12 OpenMP threads per MPI process
export OMP_NUM_THREADS=12
export OMP_PLACES=cores

# Launch the parallel job
#   Using 48 MPI processes
#   24 MPI processes per node
#   12 OpenMP threads per MPI process

srun --cpu-bind=cores --cpus-per-task=12 ./my_mixed_executable.x arg1 arg2
```

In the above we add `--cpus-per-task=12` to the `srun` command to be
consistent with that specified to `#SBATCH`. This is required to ensure
that the correct assignment of threads to physical cores takes place.
The reason for this duplication is that the value specified to `SBATCH`
does not propagate automatically to `srun`. The alternative is to
specify:

```
export SRUN_CPUS_PER_TASK=${SLURM_CPUS_PER_TASK}
```

in the script before the `srun` command. This will allow the `--cpus-per-task` value specified at submission (`SBATCH`) to propagate to `srun`
(the default value would be `--cpus-per-task=1` at the `srun` stage).
Failure to use either of these
approaches may result in threads using the same physical core, which
will cause a significant degradation in performance compared with
that expected.

### Example: job submission script for OpenMP parallel job

A simple OpenMP job submission script to submit a job using 1 CCD
nodes and 12 threads for 20 minutes would look like:

```slurm
#!/bin/bash

# Slurm job options (name, compute nodes, job time)
#SBATCH --job-name=Example_OpenMP_Job
#SBATCH --time=0:20:0
#SBATCH --nodes=1
#SBATCH --tasks-per-node=1
#SBATCH --cpus-per-task=12

# Replace [budget code] below with your budget code (e.g. t01)
#SBATCH --account=[budget code]
# We use the "standard" partition as we are running on CPU nodes
#SBATCH --partition=standard
# We use the "standard" QoS as our runtime is less than 4 days
#SBATCH --qos=standard

# Change to the submission directory
cd $SLURM_SUBMIT_DIR

# Set the number of threads to the CPUs per task
# and propagate `--cpus-per-task` value to srun
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
export OMP_PLACES=cores
export SRUN_CPUS_PER_TASK=$SLURM_CPUS_PER_TASK

# Launch the parallel job
#   Using 12 threads
#   srun picks up the distribution from the sbatch options
srun --cpu-bind=cores ./my_openmp_executable.x
```

This will run your executable `my_openmp_executable.x` in parallel on 12
threads. Slurm will allocate 1 CCD to your job and srun will place 12
threads (one per physical core).

See above for a more detailed discussion of the different `sbatch`
options

## Job arrays

The Slurm job scheduling system offers the *job array* concept, for
running collections of almost-identical jobs. For example, running the
same program several times with different arguments or input data.

Each job in a job array is called a *subjob*. The subjobs of a job array
can be submitted and queried as a unit, making it easier and cleaner to
handle the full set, compared to individual jobs.

All subjobs in a job array are started by running the same job script.
The job script also contains information on the number of jobs to be
started, and Slurm provides a subjob index which can be passed to the
individual subjobs or used to select the input data per subjob.

### Job script for a job array

As an example, the following script runs 56 subjobs, with the subjob
index as the only argument to the executable. Each subjob requests a
single node and uses all 288 cores on the node by placing 1 MPI process
per core and specifies 4 hours maximum runtime per subjob:

```slurm
#!/bin/bash
# Slurm job options (name, compute nodes, job time)

#SBATCH --name=Example_Array_Job
#SBATCH --time=04:00:00
#SBATCH --exclusive
#SBATCH --nodes=1
#SBATCH --tasks-per-node=288
#SBATCH --cpus-per-task=1
#SBATCH --array=0-55

# Replace [budget code] below with your budget code (e.g. t01)
#SBATCH --account=[budget code]
# We use the "standard" partition as we are running on CPU nodes
#SBATCH --partition=standard
# We use the "standard" QoS as our runtime is less than 4 days
#SBATCH --qos=standard

# Change to the submission directory
cd $SLURM_SUBMIT_DIR

# Set the number of threads to 1
#   This prevents any threaded system libraries from automatically
#   using threading.
export OMP_NUM_THREADS=1

srun /path/to/exe $SLURM_ARRAY_TASK_ID
```

### Submitting a job array

Job arrays are submitted using `sbatch` in the same way as for standard
jobs:

```
sbatch job_script.slurm
```

## Job chaining

Job dependencies can be used to construct complex pipelines or chain
together long simulations requiring multiple steps.


!!! Note

	The `--parsable` option to `sbatch` can simplify working with job
	dependencies. It returns the job ID in a format that can be used as the
	input to other commands.

For example:

```
jobid=$(sbatch --parsable first_job.sh)
sbatch --dependency=afterok:$jobid second_job.sh
```

or for a longer chain:

```
jobid1=$(sbatch --parsable first_job.sh)
jobid2=$(sbatch --parsable --dependency=afterok:$jobid1 second_job.sh)
jobid3=$(sbatch --parsable --dependency=afterok:$jobid1 third_job.sh)
sbatch --dependency=afterok:$jobid2,afterok:$jobid3 last_job.sh
```

## Interactive Jobs

When you are developing or debugging code you often want to run many
short jobs with a small amount of editing the code between runs. This
can be achieved by using the login nodes to run small/short MPI jobs.
However, you may want to test on the compute nodes (e.g. you may want to
test running on multiple nodes across the high performance
interconnect). One way to achieve this on Cirrus is to use an
interactive jobs.

Interactive jobs via SLURM take two slightly different forms. The first
uses `srun` directly to allocate resource to be used interactively; the
second uses both `salloc` and `srun`.

### Using srun

An interactive job via `srun` allows you to execute commands directly
from the command line without using a job submission script, and to see
the output from your program directly in the terminal.

A convenient way to do this is as follows.

```bash
[user@login04 ~]$ srun --exclusive --nodes=1 --time=00:20:00 --partition=standard --qos=standard --account=z04 --pty /usr/bin/bash --login
```

This requests the exclusive use of one node for the given time (here, 20
minutes). The `--pty /usr/bin/bash --login` requests an interactive
login shell be started. (Note the prompt has changed.) Interactive
commands can then be used as normal and will execute on the compute
node. When no longer required, you can type `exit` or CTRL-D to release
the resources and return control to the front end shell.

```bash
[user@cs-n0035]$ exit
logout
[user@login04 ~]$
```

Note that the new interactive shell will reflect the environment of the
original login shell. If you do not wish this, add the `--export=none`
argument to `srun` to provide a clean login environment.

Within an interactive job, one can use `srun` to launch parallel jobs in
the normal way, e.g.,

```bash
[user@cs-n0035]$ srun -n 2 ./a.out
```

### Using `salloc` with `srun`

This approach uses the`salloc` command to reserve compute nodes and then
`srun` to launch relevant work.

To submit a request for a job reserving 2 nodes (72 physical cores) for
1 hour you would issue the command:

```bash
[user@login04 ~]$ salloc --exclusive --nodes=2 --tasks-per-node=288 --cpus-per-task=1 --time=01:00:00  --partition=standard --qos=standard --account=t01
salloc: Granted job allocation 8699
salloc: Waiting for resource configuration
salloc: Nodes cs-n00[35-36] are ready for job
[user@login04 ~]$
```

Note that this starts a new shell on the login node associated with the
allocation (the prompt has not changed). The allocation may be released
by exiting this new shell.

```bash
[user@login04 ~]$ exit
salloc: Relinquishing job allocation 8699
[user@login04 ~]$
```

While the allocation lasts you will be able to run parallel jobs on the
compute nodes by issuing the `srun` command in the normal way. The
resources available are those specified in the original `salloc`
command. For example, with the above allocation,

```bash
[user@login04 ~]$ srun ./mpi-code.out
```

will run 576 MPI tasks per node on two nodes.

If your allocation reaches its time limit, it will automatically be
termintated and the associated shell will exit. To check that the
allocation is still running, use `squeue`:

    [user@cirrus-login1]$ squeue -u user
               JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
                8718  standard     bash    user   R       0:07      2 r1i7n[18-19]

Choose a time limit long enough to allow the relevant work to be
completed.

The `salloc` method may be useful if one wishes to associate operations
on the login node with work in the allocation itself.

## Reservations

Reservations are available on Cirrus. These allow users to reserve a
number of nodes for a specified length of time starting at a particular
time on the system.

Reservations require justification. They will only be approved if the
request could not be fulfilled with the standard queues. For example,
you require a job/jobs to run at a particular time e.g. for a
demonstration or course.

!!! Note
	  Reservation requests must be submitted at least 120 hours in advance of
	  the reservation start time. We cannot guarantee to meet all reservation
	  requests due to potential conflicts with other demands on the service
	  but will do our best to meet all requests.

!!! important
    The minimum unit of reservation is a *full node* (288 cores). It is
    not possible to request reservations smaller than this. Reservation
    sizes are in increments of full nodes.

Reservations will be charged at 1.5 times the usual rate and our policy
is that they will be charged the full rate for the entire reservation at
the time of booking, whether or not you use the nodes for the full time.
In addition, you will not be refunded the compute time if you fail to
use them due to a job crash unless this crash is due to a system
failure.

To request a reservation you complete a form on SAFE:

 1.  \[Log into SAFE\](<https://safe.epcc.ed.ac.uk>)
 2.  Under the "Login accounts" menu, choose the "Request reservation"
     option

On the first page, you need to provide the following:

 - The start time and date of the reservation.
 - The end time and date of the reservation.
 - Your justification for the reservation -- this must be provided or
   the request will be rejected.
 - The number of nodes required.

On the second page, you will need to specify which username you wish the
reservation to be charged against and, once the username has been
selected, the budget you want to charge the reservation to. (The
selected username will be charged for the reservation but the
reservation can be used by all members of the selected budget.)

Your request will be checked by the Cirrus User Administration team and,
if approved, you will be provided a reservation ID which can be used on
the system. To submit jobs to a reservation, you need to add
`--reservation=<reservation ID>` and `--qos=reservation` options to your
job submission script or Slurm job submission command.

!!! Tip
	  You can submit jobs to a reservation as soon as the reservation has been
	  set up; jobs will remain queued until the reservation starts.


## Serial jobs

Unlike parallel jobs, serial jobs will generally not need to specify the
number of nodes and exclusive access (unless they want access to all of
the memory on a node). You usually only need the `--ntasks=1` specifier.
For example, a serial job submission script could look like:

``` bash
#!/bin/bash

# Slurm job options (name, compute nodes, job time)
#SBATCH --job-name=Example_Serial_Job
#SBATCH --time=0:20:0
#SBATCH --ntasks=1

# Replace [budget code] below with your budget code (e.g. t01)
#SBATCH --account=[budget code]
# We use the "standard" partition as we are running on CPU nodes
#SBATCH --partition=standard
# We use the "standard" QoS as our runtime is less than 4 days
#SBATCH --qos=standard

# Change to the submission directory
cd $SLURM_SUBMIT_DIR

# Enforce threading to 1 in case underlying libraries are threaded
export OMP_NUM_THREADS=1

# Launch the serial job
#   Using 1 thread
srun --cpu-bind=cores ./my_serial_executable.x
```

!!! Note
    Remember that you will be allocated memory based on the number of tasks
    (i.e. CPU cores) that you request. You will get ~2.7 GB per task/core on 
    standard memory nodess and ~5.3 GB per task/core on high memory nodes.
    If you need more than this for your serial job then you should ask for
    the number of tasks you need for the required memory (or use the
    `--exclusive` option to get access to all the memory on a node) and
    launch specifying a single task using
    `srun --ntasks=1 --cpu-bind=cores`.


## Temporary files and `/tmp` in batch jobs

Applications which normally read and write temporary files from `/tmp`
may require some care in batch jobs on Cirrus. As the size of `/tmp` on
backend nodes is relatively small (\< 150 MB), applications should use a
different location to prevent possible failures.

Note also that the default value of the variable `TMPDIR` in batch jobs
is a memory-resident file system location specific to the current job
(typically in the `/dev/shm` directory). Files here reduce the available
capacity of main memory on the node.

!!! Tip

	Applications should not hard-code specific locations such as `/tmp`.
	Parallel applications should further ensure that there are no collisions
	in temporary file names on separate processes/nodes.
