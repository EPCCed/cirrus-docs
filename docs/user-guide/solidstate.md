# Solid state storage

In addition to the Lustre file system, the Cirrus login and compute
nodes have access to a shared, high-performance, solid state storage
system (also known as RPOOL). This storage system is network mounted and
shared across the login nodes and GPU compute nodes in a similar way to
the normal, spinning-disk Lustre file system but has different
performanc characteristics.

The solid state storage has a maximum usable capacity of 256 TB which is
shared between all users.

## Backups, quotas and data longevity

There are no backups of any data on the solid state storage so you
should ensure that you have copies of critical data elsewhere.

In addition, the solid state storage does not currently have any quotas
(user or group) enabled so all users are potentially able to access the
full 256 TB capacity of the storage system. We ask all users to be
considerate in their use of this shared storage system and to delete any
data on the solid state storage as soon as it no longer needs to be
there.

We monitor the usage of the storage system by users and groups and will
potentially remove data that is stopping other users getting fair access
to the storage and data that has not been actively used for long periods
of time.

## Accessing the solid-state storage

You access the solid-state storage at `/scratch/space1` on both the
login nodes and on the compute nodes.

Everybody has access to be able to create directories and add data so we
suggest that you create a directory for your project and/or user to
avoid clashes with files and data added by other users. For example, if
my project is `t01` and my username is `auser` then I could create a
directory with

    mkdir -p /scratch/space1/t01/auser

When these directories are initially created they will be
*world-readable*. If you do not want users from other projects to be
able to see your data, you should change the permissions on your new
directory. For example, to restrict the directory so that only other
users in your project can read the data you would use:

    chmod -R o-rwx /scratch/space1/t01

## Copying data to/from solid-state storage

You can move data to/from the solid-state storage in a number of
different ways:

- By copying to/from another Cirrus file system - either interactively
  on login nodes or as part of a job submission script
- By transferring directly to/from an external host via the login nodes

### Local data transfer

The most efficient tool for copying to/from the Cirrus file systems
(<span class="title-ref">/home</span>,
<span class="title-ref">/work</span>) to the solid state storage is
generally the `cp` command, e.g.

    cp -r /path/to/data-dir /scratch/space1/t01/auser/

where `/path/to/data-dir` should be replaced with the path to the data
directory you are wanting to copy and assuming, of course, that you have
setup the `t01/auser` subdirectories as described above).



!!! Note



	If you are transferring data from your `/work` directory, these commands
	can also be added to job submission scripts running on the compute nodes
	to move data as part of the job. If you do this, remember to include the
	data transfer time in the overall walltime for the job.
	
	Data from your `/home` directory is not available from the compute nodes
	and must therefore be transferred from a login node.



### Remote data transfer

You can transfer data directly to the solid state storage from external
locations using `scp` or `rsync` in exactly the same way as you would
usually do to transfer data to Cirrus. Simply substitute the path to the
location on the solid state storage for that you would normally use for
Cirrus. For example, if you are on the external location (e.g. your
laptop), you could use something like:

    scp -r data_dir user@login.cirrus.ac.uk:/scratch/space1/t01/auser/

You can also use commands such as `wget` and `curl` to pull data from
external locations directly to the solid state storage.



!!! Note

	You cannot transfer data from external locations in job scripts as the
	Cirrus compute nodes do not have external network access.


