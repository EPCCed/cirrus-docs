# Using Open OnDemand on Cirrus

The [Cirrus Open OnDemand portal](https://ood.cirrus.ac.uk) allows you to use the Cirrus file system, submit and control
jobs, and run Jupyter Python notebooks through a web-based GUI. It also grants access to a web-based terminal, if you
might prefer to access the system in this way.

## Accessing Open OnDemand

The Cirrus Open OnDemand portal is found at [https://ood.cirrus.ac.uk](https://ood.cirrus.ac.uk). Access is 
authenticated via the SAFE. Click on the 'Log in using SAFE' button to proceed. If there are multiple machine accounts
on Cirrus associated with your SAFE account, the SAFE will prompt you to choose which one you want to use to log in.
Naturally, you must have a Cirrus account set up through the SAFE in the first place to log in.

Once logged in to Open OnDemand, you will see the landing page where you will see icons for the Jupyter and job composer 
apps. The menu along the top bar gives access to more functions.

## Opening a Cirrus terminal in your browser

Open OnDemand enables users to log in to Cirrus using a traditional SSH terminal that runs in your browser. Note that 
you will not need to generate or provide an SSH key in order to authenticate yourself for login in this way.

!!! tip
    As logging in to Cirrus through Open OnDemand doesn't require an SSH key to be set up for Cirrus on the machine 
    you're using, this can make a quick and easy way to log in from a machine different from the one you normally use.

To do so click on the 'Clusters' item on the top menu bar followed by 'Cirrus Shell Access' from the drop-down menu that
it opens. This will open a new tab running the terminal. As always, you will be prompted to provide your TOTP the 
first time you log in each day. Once you are logged in, you can work just as you would do if you were connecting through
the `ssh` command from a local terminal running on your machine; a notable exception to this is that any commands 
that otherwise would have opened a GUI through X11 forwarding will instead fail.

When you are finished working on the system, simply close the browser tab containing the terminal.

## Working with the Cirrus file systems

The first item on the top menu bar in Open OnDemand is 'Files'. Clicking this drop-down menu gives options that, if you
select one, will take you to either your Home or Work file system directory, *i.e.* your 
`/home/<projectid>/<projectid>/<username>` and `/work/<projectid>/<projectid>/<username>` directories.

The new window that opens is the File Manager, showing you the contents of the directory you pick. You can click on a 
directory to move into it. Clicking on a text-based file will open a new tab containing its contents.

- 'Open in terminal': Open an SSH terminal in this directory, working as described in the section on [opening a 
  terminal](#opening-a-cirrus-terminal-in-your-browser).
- 'Refresh': The file browser shows you the contents of the current directory at the point you moved to it. Later
  changes, such as from a currently running job's generated output, will not be reflected without first clicking on the
  'Refresh' button
- 'New file' / 'New directory: Create a new file or directory with a given name in this directory.
- 'Upload': Select a file or files on your local machine to upload to this location on Cirrus.
- 'Download': Download to your local machine any ticked files or directories from the contents below.
- 'Copy/Move': Copy or move the selected files or directories to another location on Cirrus. Firstly, tick the items you
  wish to copy or move, then click the 'Copy/Move' button. You will see a dialogue open on the left of the page to 
  confirm copying or moving to the current directory. You can now move to a different target location in the file 
  browser, then click on 'Copy' or 'Move' in the new dialogue window to complete that operation.
- 'Delete': Delete the files or directories currently marked with ticks. You will be prompted Yes/No to confirm 
  before the operation is completed.

## Working with jobs in Open OnDemand

### Creating jobs with the Job Composer

You can use the Open OnDemand job composer to create jobs for submission to the Cirrus compute nodes. Start it by 
clicking on the 'Job Composer' icon on the main dashboard, or through the 'Jobs' item in the top menu bar and then 
clicking on 'Job Composer'. The job composer has two tabs: 'Jobs' and 'Templates'. You will land on the 'Jobs' tab.

The 'New Job' button allows you to create a basic job from a default template of a serial job. This will then appear 
in the table on the left hand panel of the window. As you create more jobs, they will be listed here; you can sort 
and search your jobs as required.

The 'Job Options' button allows you to then edit the name (that is, the name given in Open OnDemand) and other details
of whichever job is currently selected. You might want to at a minimum set a job name right away to allow you to 
distinguish this from any later ones generated from the default template, which would otherwise have the same name.

You will see that the default job sets up a directory for it to run in, located within an `ondemand` directory in your
work directory, as well as a `main_job.sh` job script. These directories are dynamically created for you as you set 
up new jobs. The files in the directory and the job script's contents are shown on the right hand side of the page. You
should edit or replace this job script, leaving in its place a valid Cirrus job script as described in the Cirrus
documentation's [section on running jobs](batch.md). Use Open OnDemand's in-browser editor by clicking 'Open Editor', or
work as you otherwise do normally.

!!! tip
    Once you have created one job, you can quickly create a new one from it by going to 'New Job' and then 'From 
    Selected Job'. This will essentially copy the currently highlighted job's files into a new directory to be 
    further worked on before submission there.

!!! note
    Clicking the button to delete a job in Open OnDemand deletes the directory containing it on the Cirrus work file
    system. This means that the job script as well as any input data and previously generated output data will be 
    deleted. Before you delete a job, make sure that there is nothing listed in this directory that you want keep.

Once you are happy with a job, make sure it is highlighted in the job table and click the green 'Submit' button to 
send it to Slurm.

### Checking job status

Jobs in the table are listed with a status. When you submit one to Slurm, you will see that its status changes from 
'Not submitted' to 'Queued', and its Slurm job ID will appear in that column of the table. If all goes well, the job's
status will proceed to 'Running' and then 'Completed'. If there is an error, you will see its status as a 
red-highlighted 'Failed'.

!!! note
    A job submitted through Open OnDemand will appear in Slurm, such as by using `squeue --me`, not under the Open 
    OnDemand job name but under whatever was provided in the job script itself. For example, a job with
    ```bash
    #SBATCH --job-name=hello_world
    ```
    would appear in Slurm as `hello_world` irrespective of the name given to it in the Open OnDemand interface.

You can cancel a job through Open OnDemand by highlighting it in the table of jobs and then clicking on the 'Stop' 
button next to 'Submit'.

Otherwise, the job will run just the same as one set up manually and submitted through a terminal session.

The top level menu item 'Jobs' also has an item 'Active Jobs'. This is the closest equivalent to running `squeue` in 
a terminal. This will display a table of your queued, running and recently completed jobs. Clicking the arrow button 
on the far left produces more information for a given job. By default this page will only show your own jobs, but 
you can view all jobs on the system by clicking on the blue 'Your Jobs' button on the upper right.

### Job templates

Once you have set a job up, meaning that a working job script and all input data are in place, you can create a template
from it by clicking on the 'Create Template' above the table of jobs. This will copy the job directory's contents to
another directory for reuse in later jobs. If you've already performed a run, you may wish to clean up files for the
template before creating it, or else you can manually go to the template directory and do so there post creation. Once
you have created a template, you can use it by going through to the 'Templates' tab at the top of the page, selecting
the template from the table on the left, and then filling out 'Create New' box on the right. This job will receive all
the same files that were used when creating the template.

### Working in a project

So far the jobs created through the Job Composer have been created in a preconfigured `ondemand` directory in your work
directory and are fairly standalone. If you wish to, you can create and work in an Open OnDemand project by going to
'Jobs' in the top menu bar of the window, and then 'Project Manager'. Projects allow you to set up large reusable sets
of job scripts and data, and to configure launchers which provide a way of quickly reconfiguring and resubmitting these
jobs to the queue. A project workflow in turn can chain these launchers together.

If you are interested in setting up a project, please read 
[Open OnDemand's project tutorial](https://osc.github.io/ood-documentation/latest/tutorials/tutorials-project-manager.html).

## Running Jupyter Notebooks on Open OnDemand

You can run Jupyter notebooks on the Cirrus compute nodes and control them from your browser. Doing so through Open 
OnDemand is likely simpler than setting your own JupyterLab installation. To start a job, click on the 'Cirrus 
Jupyter Lab' button on the main Open OnDemand dashboard, or go to 'Apps' and then 'Cirrus Jupyter Lab' on the top 
menu bar.

In the new page that opens, you can provide the job details (which budget to charge, which partition and QoS, the 
number of nodes and cores, maximum walltime) as well as the working directory in which to start Jupyter, and,
importantly, the location of the Python virtual environment to use. If you don't yet have one, and won't need to install
your own packages beyond NumPy and SciPy, you can tick the box to tell Open OnDemand to create a simple one for you at 
the selected location.

!!! tip
    If you need to use your own Python packages in a notebook, create a virtual environment for them first in a terminal
    session on the login nodes. Then, tell Open OnDemand the virtual environment's install location on the Jupyter 
    launch menu.

When your job is configured, click the large 'Launch' button at the bottom of the page. This will submit the job to the
Slurm queue and take you to the 'My Interactive Sessions' page in Open OnDemand, which lists any queued and running
JupyterLab jobs (as well as, helpfully, the remaining wall time on them). Your new job will be listed here now. You can 
always get back to this page by clicking 'My Interactive Sessions' on the top menu bar.

Your new job will appear in the 'Queued' state. You'll see this move to 'Starting'; if you chose to install a new 
Python virtual environment for this job, this status might take a minute or so to move on. When it does, you will 
see the job is now 'Running'. Click the 'Connect to Jupyter' button and your browser will open a new window 
connected to the JupyterLab instance running in the job on the Cirrus compute nodes.

When you are done working, return to the 'My Interactive Sessions' page in Open OnDemand and click the 'Delete' 
button on the job to end it.
