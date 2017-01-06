FLACS
=====

The Cirrus cluster is best suited to run multiple flacs simulations
simultaneously (using a batch queue). Short lasting simulations (a few
minutes up to a few hours each) can be processed efficiently and you
could get a few hundred done in a day or two. The Cirrus cluster is not
suited for running single big flacs simulations each with many threads.
You are not guaranteed to have exclusive access to a given compute node
for your multi-thread simulation because at times there might be other
heavy jobs running on the same compute node.

CPU time is measured for each job submitted to a back-end node, the
number of core/seconds used. Only jobs submitted to back-end nodes via
qsub are charged. Any processing on a front-end node is not chargeable.
However using front-end nodes for processing other than pre- or post-
processing is not recommended.

Please also note that any license limitations does not apply on the HPC
Service.

To run FLACS on Cirrus, you need to have two accounts: one website account
and one machine account on Cirrus for a given EPCC project. The person
requesting the HPC Service (or another one appointed by the person
requesting the service) will serve as the Principal Investigator or
Project Manager for using Cirrus.

How to sign up for a website account:

#. Register on SAFE: Go to the SAFE New User Signup Form: https://safe.epcc.ed.ac.uk/safadmin/signup.jsp
#. Fill in your personal details and submit the form
#. You are now registered on the SAFE (Secure Systems Administration
   Facility). The support team at EPCC will e-mail you the required
   instructions for how to log in to SAFE once your account has been
   opened (including username and password for your account).
#. After you have received an account on the EPCC SAFE, you can apply
   for an account on the Cirrus Machine. Log in to SAFE:
   https://safe.epcc.ed.ac.uk/safadmin/login.jsp

#. If you are the Project Manager, and you are requesting an account for
   Cirrus, you will receive an email from EPCC with the topic "New EPCC
   Project", where you will find the project code and instructuctions on
   how to proceed (Logging in to the admin website, changing your
   password to the admin website, to get an account on the service
   machine for yourself, how to find out your project password, how your
   users can get accounts on your project, how to accept (or reject) a
   user's request for an account, how to pick up your password for the
   service machine, how to designate a user as a project manager,
   setting up project groups, administering time, more information.

#. Every project has a password. Potential new users need this when they
   register to use the service (this is not the same as your own website
   password - it is only used by new users when getting their accounts).
   As a Project Manager you can find your project password by logging in
   to the admin website as above, find the box headed "You manage the
   following projects", click on the "Administer" button. This will
   display a screen with a variety of options for managing your project.
   Click "Update", this will reveal the project password.

#. If you are not the Project Investigator/ Manager: On the Main page
   after logging in to SAFE, click the "New account request" button.

#. Select the project code (provided by the Project Manager), the
   machine (Cirrus-Linux) and type the Project Password (provided by the
   Project Manager). Once you have applied for the account, the Project
   Manager will need to approve this and then the account will be set
   up. Once your machine account is activated, you will receive an email
#. Log in to https://safe.epcc.ed.ac.uk/safadmin to look up your
   password and other account details
#. Choose the "Account" for the Cirrus-Linux machine, and "View Password".
   You are now ready to start to use FLACS at Cirrus.
   
Further guidance for the SAFE can be found here: https://cirrus.readthedocs.io/en/latest/safe-guide/introduction.html

How to run FLACS on Cirrus (in the instructions/ commands below, change
"username" to your own username):

#. To log in on Cirrus use standard ssh client. To login from UNIX system type
   *ssh -X username@login.cirrus.ac.uk*
#. Change to the correct project space at Cirrus (change "projects" to the
   project code for your project in the command below):
   *cd /lustre/home/projects*
#. Transfer your data from a local folder on your machine to a remote
   folder on Cirrus:  
   *rsync -avz local\_folder username\@login.cirrus.ac.uk:remote\_folder *
   If you want to copy only parts of the data, e.g. only the cg-files
   you can type:
   *rsync -avz --include='cg\*dat3' --include='\*/' --exclude='\*'
   local\_folder username\@login.cirrus.ac.uk:remote\_folder *
   (Please note that modern rsync usually uses ssh, to be sure you can
   specify '-e ssh')
#. To run FLACS on Cirrus you must first change to the directory where
   your FLACS jobs are located, use the change directory command for
   Linux (for example cd projects/sim)
#. Submit your FLACS jobs to Cirrus (for monitoring reasons you need to
   add a flag to the simulations when you run FLACS jobs on Cirrus. You
   need to add the option and label after qsub "-P Label" in the run
   file. The label can for example contain project name and simulation
   type):
   *qsub -P project001 /shared/GexCon/FLACS\_v10.3/bin/run runflacs 010101*
#. After your simulations are finished, transfer the data back from Cirrus:
   *rsync -avz username@Cirrus0.epcc.ed.ac.uk:remote\_folder local\_folder*

Please also confer manual for options related to qsub, qstat and rsync
commands: 'man qsub', 'man qstat' and 'man rsync'.

Further guidance for Cirrus, including further details on Data Transfer, can be found here: https://cirrus.readthedocs.io/en/latest/index.html
