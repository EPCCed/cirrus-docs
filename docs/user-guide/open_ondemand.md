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

When you are finished working on the system, run the `exit` command in your Cirrus prompt or simply close the tab 
containing the terminal.

## Working with data in Open OnDemand

The first item on the top menu bar in Open OnDemand is 'Files'. Clicking this drop-down menu gives options that, if you
select one, will take you to either your Home or Work file system directory, *i.e.* your 
`/home/<projectid>/<projectid>/<username>` and `/work/<projectid>/<projectid>/<username>` directories.

The new window that opens will show you the contents of the directory you pick. You can click on a directory to move 
into it. Clicking on a text-based file will open a new tab containing its contents.

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

## Creating and submitting jobs to the queue

## Running Jupyter Notebooks on Open OnDemand

