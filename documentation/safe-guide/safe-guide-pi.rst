SAFE Guide for Principal Investigators: How to Manage your Allocation
=====================================================================

Principal Investigators (grant holders) can manage their allocations
efficiently via `SAFE <https://safe.epcc.ed.ac.uk/safadmin/>`__

`Getting started <#getting-started>`__
--------------------------------------

-  `Your allocation has been set up as a project on the service. Your
   first steps. <#andnext>`__
-  `How to get your own account on the service machine <#selfac>`__
-  `How to check project alerts <#projalert>`__

`Managing your allocated resources <#managing-resources>`__
-----------------------------------------------------------

-  `What is "period allocation"? <#period>`__
-  `How to set up project groups within the project <#projgrp>`__
-  `How to delete a project group <#delgrp>`__
-  `How can I administer time within my project? <#time>`__
-  `How to move time between budgets <#mvtime>`__
-  `How to allocate time to individual user <#oneuser>`__
-  `How to administer disk space <#space>`__
-  `How to create a quota for a project group, or move space between
   quotas <#mvspace>`__
-  `How to set a quota for an individual user <#persquota>`__

`Managing project users <#managing-users>`__
--------------------------------------------

-  `How can project users get registered <#regusers>`__
-  `How to track user sign up requests <#signup>`__
-  `How to designate a user as a project manager <#projman>`__
-  `How to designate a user as a project sub-group
   manager <#groupman>`__
-  `How to add a user to a project group <#addu>`__
-  `How to remove a user from a project group <#remu>`__
-  `How to (temporarily) stop a user from using time in your
   project <#deact>`__
-  `How to remove a user (or users) from your project <#remuser>`__
-  `How to send a mailing to all users in your project <#projmailing>`__

`Tracking your project usage <#track-usage>`__
----------------------------------------------

-  `How to check the current state of your project's time and
   space <#snap>`__
-  `How to track what my project's users and project groups are
   doing? <#phist>`__
-  `How to check how much space my project's users are
   occupying <#udisk>`__
-  `How to request automatic project reports <#autorep>`__
-  `How to request more resources (AUs and disk space) <#more>`__

| 

--------------

Getting Started
---------------

Your allocation has been set up as a project on the service. Your first steps.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Here are some of the things you should consider doing; not all of them
will be needed for every project.

#. `Change your own SAFE password <safe-guide-users.html#chpass>`__
#. `Set up an account on the service machine for yourself <#selfac>`__
#. `Make sure other project users get registered <#regusers>`__
#. `Designate one or more users as managers of your
   project <#projman>`__
#. `Decide whether you need project groups within your project, in order
   to administer time and other resources <#projgrp>`__

How to get your own account on the service machine
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If you are not going to work on the machine yourself, you do not need to
do this. You can administer your project through SAFE alone. But if you
want a service machine account:

#. `Login to SAFE <safe-guide-users.html#login>`__.
#. Go to the Menu *Login accounts* and select *Request login account*
   button.
#. Select the desired project from the pull down list and click *Select
   Project*
#. Select the desired machine from the pull down list and click *Select
   Machine*
#. Enter your Requested username and click on *Request*

You will get an acknowledgment screen, from which you can return to your
main page. Now (as PI) you have to accept your own request for an
account—see the next question.

How can I check project alerts?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

`Login to SAFE <safe-guide-users.html#login>`__. Then:

#. Go to the Menu *Projects managed* and select the *project* you wish
   to check
#. This will display a page with a variety of options for managing your
   project.
#. Project alerts and warning are highlighted in Amber and Red
#. To request emails for alerts, or to change the frequency of the
   emails
#. Click *Update*
#. Beside "Frequency of Alerts" select the required frequency
#. If the emails should go to someone other than the PI, enter the email
   address(es) into the 'Recipients for alerts' box
#. Click *Update* to save the changes.

Do not forget the last step, or nothing will happen.

| 

Managing your allocated resources
---------------------------------

What is "period allocation"?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

A period allocation contains AUs which have been allocated for a project
to use within the specified time period. Period allocations are valid
for a specific resource pool (machine) and have definitive start and end
dates. When the end date of the period allocation passes, any leftover
kAUs will automatically expire.

You can view and manage your period allocation via SAFE.

`Login to SAFE <safe-guide-users.html#login>`__. Then:

#. Go to the Menu *Projects managed* and select the *project* you wish
   to work with
#. This will display a screen with a variety of options for managing the
   project.
#. Click on *Manage Project Resources*
#. Click on *Manage Group Time Allocations for Resource Pool (Cirrus)*

You will then see the details of your allocation. *Please check them
carefully to make sure you are looking at the correct one.*

-  **Resource Pool (machine)**. "Cirrus" refers to Cirrus.
-  **Amount of kAUs**
-  **Dates** It is possible to have multiple successive period
   allocations, but they can never overlap if they are for the same
   resource pool. Before carrying out any project management tasks
   please check the dates and make sure you are managing the correct
   allocation. You can skip between the period allocations by clicking
   on the ">>>" (next period) and "<<<" (previous) buttons at the bottom
   of the page.

You can manage the allocation by `setting up project
groups <#projgrp>`__ and `allocating kAUs to project
groups <#mvtime>`__. Project management tasks for the period allocation
can be carried out at any time, but the allocation will be active, i.e.
usable, only between the specified dates. Thus, you can set up project
groups in advance.

How can I set up project groups within my project?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Project groups can be used to administer time and other resources within
your project.

#. `Login to SAFE <safe-guide-users.html#login>`__.
#. Go to the Menu *Projects managed* and select the *project* you wish
   to create the group
#. This will display a screen with a variety of options for managing the
   project.
#. Click *Project Group Administration*
#. Click *Add new sub-group*
#. This will take you to the screen for creating new project groups.
   Fill in a suffix to your project code in the box: for example, if
   your project code is t01, you might chose t01-a. Project group names
   cannot be more than eight characters in total.
#. If this group is to be used for guest budget users, tick "Guest
   Budget"
#. click *Create*

Single user accounts can only belong to one project group.

How can I delete a project group?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

You can only delete a project group if it has no resources or members.
You must remove all its `members <#remu>`__ and all its
`time <#mvtime>`__. Also, if it has `disk quotas set <#space>`__, it
cannot be deleted; they will have to be removed first. Then:

#. Go to the Menu *Projects managed* and select the *project* you wish
   to delete the sub-group from.
#. Click on *Project Group Administration*
#. Select the project sub-group you want to delete. You will only be
   able to select the groups which have no time, space or members.
#. Click *Delete*. This will ask for confirmation that you wish to
   delete the sub-group. Click *Yes*.

Deleting a group involves removing its various directories. A human has
to do this, so there will be a short delay.

How can I administer time within my project?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Time is measured in `*allocation
units* <http://www.cirrus.ac.uk/access/au-calculator/>`__ (kAUs), and is
held in *budgets*. Every project group has its own budget. There are
always at least two project groups in your project:

-  The *general group*, which has the same code as the project itself.
   Every member of the project is a member of this group, so the time in
   its budget is available to them all.
-  The *reserve* project group, which has a name of form *t01-reserve*.
   It has no members, so no one can use the time in its budget. This
   budget can be used to hold time which the PI or project manager
   wishes to hold in reserve for later use.

Initially, all your time is in the general group's budget. If you are
happy with all your users using the same budget, you can leave things as
they are.

If you wish to divide the time up between groups, you can `create a
project group <#projgrp>`__ for each group. In this case you will
probably want to move all the time out the general group, since this can
be used by everyone.

You may wish to `give time just to a single user <#oneuser>`__. This is
a special case of a project group: one with only one member.

The reserve budget is provided so that if you wish you can control the
use of time by your project members: you can keep most of the time in
your reserve budget, and move it to the other budgets as required. We
recommend that you should do this, even if you don't need to create
other project groups.

How can I move time between budgets?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

`Login to SAFE <safe-guide-users.html#login>`__, and then:

#. Go to the Menu *Projects managed* and select the *project* you wish
   to work with. This displays a panel with information for the project.
#. Click *Manage Project Resources*
#. Click *Manage Group Time Allocations for Cirrus*
#. Click the *Move From* and *Move To* buttons of the project groups you
   want to change
#. Enter the number of kAUs you wish to move in the box
#. Click the *Submit Budget Allocation Changes* button.

Do not forget the last step, or nothing will happen.

` <>`__ How can I allocate time to a single user?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

As all the time in a project group is shared by all its members, the
only way to reserve some time for a single user is to create a project
group for that user alone.

#. `Create a new project group <#projgrp>`__ for the user. For example,
   if we are in project *t01* and the user is *fred*, you might call the
   new project group *t01-fred*
#. `Add the user to the new project group <#addu>`__
#. `Move the time <#mvtime>`__ you wish the user to have into the new
   project group

Remember that time in the general group's budget is accessible to all,
so you will probably want to move all of the project's time away from
there.

How can I administer disk space?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Start by reading the discussion of the `administration of
time <#time>`__, as the administration of disk space is related to this,
and is also done using project groups. The two project groups which
exist in each project can also be used for administering space.

-  The *general group*, which has the same code as the project itself,
   includes every member of the project. The disk quotas of this project
   group can therefore be used by them all.
-  The *reserve* project group, which has a name of form *t01-reserve*,
   has no members, so no one can use the disk space which is in its
   quotas. You can use these quotas to hold space which you want to hold
   in reserve for later.

Homespace and workspace are administered separately. A project has an
overall limit for each of these. Within that limit, every portion of
space must belong to one or other of the project group quotas. Thus, to
start with, all the homespace (for example) allocated to a project is
either in the general homespace quota or the reserve homespace quota.
Space never belongs to more than one group quota. [The reserve quota is
not a real quota, in fact. It has no existence on the service
machine—just in the database.]

Beyond the general and reserve quotas, you can also have quotas for the
project groups which you create. But this is not compulsory. If you're
thinking about using project group quotas, you need to be aware that
they are implemented using Unix groups, which are only just adequate for
the task.

Let's use homespace as an example—workspace is similar. Suppose you are
project *t01*. To start with, one Unix group will be assigned to this
project. The homespace directories for all users will be in directory
``/home/t01/t01/`` —this is where the general group is held. User
*john*, for example, will have directory ``/home/t01/t01/john/`` as his
homespace directory. (In fact, if this is the first project he joined,
that's where he will log in.) Any file created in any of the
directoriesunder ``/home/t01/t01/`` will belong to the Unix group for
project *t01*.

If you create a project group *t01-a* with no homespace quota, this will
not change. But the moment you give a homespace quota to this project
group, a Unix group will be assigned to it and a directory will be
created for it: ``/home/t01/t01-a/`` . If user *john* is a member of
this project group, he will have a directory ``/home/t01/t01-a/john/`` .
Any files he creates under that directory will belong to *t01-a* and
will be counted against its quota.

Of course, *john* is still a member of the general project group, so he
can still create files there. If he belongs to other project groups
which have quotas, he'll have directories for these as well. He can only
create files in the project groups he is a member of, since he can't
access the directories of the other groups. It's up to him to make sure
that he creates his files in the right places, so that they get charged
to the right project groups.

You should also note that once you have instituted project group quotas,
there's no easy way back. Removing them and reassigning all the files to
other groups is a complex job and will require special arrangement with
the system team—send a request to the
`helpdesk <mailto:support@epcc.ed.ac.uk>`__ if you need to do this.

Most projects in fact use their project groups only for administering
time, and allow their users to have access to all their space. You could
if you wish make use of `user quotas <#persquota>`__ to stop individual
users from taking too much space.

[Note that the above points do not apply to the reserve quotas, since
they don't exist on the service machine. They're just a book-keeping
fiction, and using them is cost free. We recommend this to any project
which is concerned about running out of space.]

How can I create a quota for a project group, or move space between quotas?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

First, read the `discussion of space administration <#space>`__. If you
are still determined to use project group quotas, this is how.

#. `Login to SAFE <safe-guide-users.html#login>`__
#. Go to the Menu *Projects manaaged* and select the *project* you wish
   to work on. This will display a panel with the project information.
#. Click *Manage Project Resources*
#. In the *Group Quotas* section, click on *Archive*, *Home* or *Work*
   depending on which kind of quota you wish to create
#. You will now see a list of your project groups, including the general
   and reserve groups. Project groups which have no quota will show the
   note *No quota set*
#. Click the *Move From* and *Move To* buttons of the groups you want to
   change
#. Fill in the number of Gb to move in the box
#. Click *Submit Group Allocation Changes*

Do not forget the final step, or nothing will happen. The act of moving
quota space to a project group which has no quota set converts that
project group to one with a group quota, administered by a Unix group,
as discussed `earlier <#space>`__.

Quota changes are actually carried out by a human being. Once this has
been done, you will receive an email informing you. If you ask for the
quota to be reduced below the current size of the files in the project
group, the human will reject your request, and you will get an email
saying this.

How can I set a quota for an individual user?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

User disk quotas are completely separate from project group quotas. A
user quota simply places a limit on the amount of space which a
particular user can occupy in workspace or homespace. There's nothing to
stop you setting user quotas which add up to more (or less) than the
total space. To set a quota for a user or users:

#. `Login to SAFE <safe-guide-users.html#login>`__
#. Go to the Menu *Projects managed* and select the *project* you wish
   to work on. This will display a panel with the project information.
#. Click *Manage Project Resources*
#. In the *User Quotas* section, click *Home* or *Work*
#. You will see a list of users. Enter a value for each of the users
   whose quota you wish to change
#. Click *Submit Changes*

Once again, these quota changes are carried out by a human. Once they
have finished, you will receive an email.

As with group quotas on the work file-system you can only be absolutely
sure of writing data when you are more than 7Gb below your quota limit.

| 

Managing Project Users
----------------------

How can project users get registered?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

You must not apply for machine accounts on behalf of other users, or let
others use accounts that belong to you. Account sharing is strictly
forbidden on Cirrus. Every user must `register on
SAFE <safe-guide-users.html#register>`__ and then `apply for their own
machine account <safe-guide-users.html#getac>`__

In order to get an account, a potential user needs to know your project
code. This is included in the email which SAFE sends to you, as PI, when
your project is set up.

#. Give the users the project code.
#. Every user must `register on SAFE <safe-guide-users.html#register>`__
   and then `apply for their own machine
   account <safe-guide-users.html#getac>`__
#. If you notice that the Menu *Projects managed* is highlighted orange,
   then this indicates that there is a request for project membership.
   Now you have to accept (or reject) each user's request. `Login to
   SAFE <safe-guide-users.html#login>`__.
#. Go to the Menu *Projects managed* and select *project requests* and
   you will see the details of the user who has applied.
#. Click the button next to the user
#. You will see the user's details, and at the bottom of the page
   buttons to accept or reject them

If you now accept the user, they will get an account. This is the last
chance to stop someone who should not be there! Take a few seconds to
check the user's details, especially their email address, to make sure
that they are who they say they are. Please check their nationality as
well: it's your responsibility to make sure this is right.

When you accept a user, the systems team is automatically requested to
create the account on the service machine. When this has been done, the
user is emailed; allow a working day for this. The user can then login
to SAFE and `pick up their password on the service
machine <safe-guide-users.html#getpass>`__.

How to track user sign up requests
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

`Login to SAFE <safe-guide-users.html#login>`__. Then:

#. Go to the Menu *Projects managed* and select the *project* you wish
   to affect.
#. Click the *Update* button.
#. Enter your email address in the *New Account Signup Notification
   List* box. By default, the PI is notified.
#. Click *Commit Update*.

Do not forget the last step, or nothing will happen.

How can I designate a user as a project manager?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

A project manager can do everything in a project that a PI can do,
except designate another project manager. You can designate as many
project managers as you wish.

#. Make sure the user has an account in your project.
#. `Login to SAFE <safe-guide-users.html#login>`__.
#. Go to the Menu *Projects managed* and select the *project* you wish
   to appoint a project manager for. This will display a screen with a
   variety of options for managing the project.
#. Click *Add project manager*
#. A drop down list will be displayed which contains all the users
   within the project. Select the user you wish to make a manager and
   click *Add*

If you later wish to remove a project manager, click *Remove project
manager*, select the *project manager* and then click *Remove*.

How can I designate a user as a project sub-group manager?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

A project sub-group manager can only move time and disk quota between
the groups they manage. They can also create new sub-groups underneath
these groups. (If you manage a parent group you automatically manage all
its children). Sub-group managers can also accept new people into the
project and run reports on the project.

#. Make sure the user has an account in your project.
#. `Login to SAFE <safe-guide-users.html#login>`__.
#. Go to the Menu *Projects managed* and select the *project* you wish
   to appoint a project sub-group manager for.
#. Scroll down to project groups and click on *Project Group
   Administration*.
#. Select the project-subgroup that you wish to assign a sub-group
   manager for. Click on *Add Manager*.
#. You will now have a drop down list of all the users who are sub-group
   members but not currently managers. Select the new manager from this
   list and click *Add* and then confirm the change.

To add users to the new project group, see the next question. A user can
belong to more than one project group.

How can I add users to an existing project group?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

`Login to SAFE <safe-guide-users.html#login>`__. Then:

#. Go to the Menu *Projects Managed *and select the *project* you wish
   to are work on. This will display a screen with a variety of options
   for managing the project.**
#. Click on *Project Group Administration*
#. Scroll down and click on the *project sub-group* that you wish to add
   members to
#. Scroll down and click on *Add accounts*
#. This lists all of the active users accounts within project, select
   the users that you should have access to the project group clicking
   the boxes next to their names and click *Add*

To see which members have access to the project group, select *project
sub-group* and click *List Members.*

If the project group is using `disk quotas <#space>`__, this operation
is carried out by a human, so there may be a short delay. Otherwise, it
happens at once.

A user can belong to more than one project group.

How can I remove a user from a project group?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

`Login to SAFE <safe-guide-users.html#login>`__. Then:

#. Go to the Menu *Projects managed* and select the *project* you wish
   to work on. This will display a screen with a variety of options for
   managing the project.
#. Click on *Project Group Administration*
#. Scroll down and click on the group you wish to work with
#. Click on *Set membership* and you will see the list of users with a
   tick beside those who are members.
#. Tick or Untick the users as required for membership.

To see the membership of a group, select *project group* and then click
*List members* which shows the list of current members.

If the project group is using `disk quotas <#space>`__, this operation
is carried out by a human, so there may be a short delay. Otherwise, it
happens at once.

Can I temporarily stop a user from using any time in my project?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Yes. This is called *deactivating* a user. A user who has been
deactivated cannot use any of your budgets. This means that they cannot
do any work, in effect, so we recommend that you use this facility with
care.

#. `Login to SAFE <safe-guide-users.html#login>`__
#. Go to the Menu *Projects managed* and select the *project* you are
   working on.
#. Click *Administer Users*
#. Select the user or users you wish to deactivate
#. Click *Deactivate*

To reactivate the users, do the same, but click *Activate* instead.

How can I remove a user (or users) from my project?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Before doing this, bear in mind that it will result in all their files
in your project being deleted. Are you sure that this is what you want?
If so:

-  `Login to SAFE <safe-guide-users.html#login>`__
-  Go to the Menu *Projects managed* and select the *project* you wish
   to work on. This will display a screen with a variety of options for
   managing the project.
-  Click *Administer Users*
-  A list of all your users will be displayed. Tick the box next to the
   user (or users) in question, then go to the bottom and click *Remove
   User from Project*

SAFE will now ask you to confirm your action. If you do, all the files
and directories in your project which belong to the users will be
deleted, and the users will be removed from any of your project groups,
so that they will not be able to use your time. In addition, if a user
does not belong to any other project, their account on the service
machine will be closed.

` <>`__ How can I send a mailing to all users in my project
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-  `Login to SAFE <safe-guide-users.html#login>`__
-  Go to the Menu *Projects Managed* and select the *project* you wish
   to work on. This will display a screen with a variety of options for
   managing the project.
-  By *Project mailings* click on *View*
-  You will see a list of all of the previous project mailings, and the
   option to compose a new one.
-  Select *Compose*
-  To change the mailing or content, you can use the *Edit Subject* and
   *Edit* buttons. Once you have changed the text select *Update*.
-  To send the mail click *Send*. There is an option to *Start Over* -
   this will wipe the content of the email. The *Abort* option will take
   you out of the mailing page completely.

| 

Tracking your Project Usage
---------------------------

How to check the current state of your project's time and space
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

`Login to SAFE <safe-guide-users.html#login>`__. Then:

#. Go to the Menu *Projects managed* and select the *project* you wish
   to work on.
#. Under *Project groups* you can see the current state of each project
   group's budgets. If it uses disk quotas, you will see these, together
   with how much of is in use.

If a project group's use of a quota is getting close to the maximum, it
is highlighted in pink.

The budget values displayed are updated every morning, and the values
shown for disk use are updated four times a day. For this reason, these
values may not all be completely up-to-date. If there is a lot of
activity in your project, the numbers shown could be significantly
different from the current ones.

How to track what my project's users and project groups are doing?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This can be done using the Report Generator

#. `Login to SAFE <safe-guide-users.html#login>`__.
#. Go to the Menu *Service information* and select *Report generator*
#. Choose a report format: HTML, PDF or CSV (comma-separated values—good
   for input to Excel, *etc.*)
#. Select the start and end dates of the period you are interested in
#. Select *Project Information*. (Only PIs and project managers see this
   section)
#. Select the information you need.
#. Click *Generate Report*

How to request automatic project reports
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#. `Login to SAFE <safe-guide-users.html#login>`__.
#. Go to the Menu *Projects Managed* and select the *project* you wish
   to work on. This will display a screen with a variety of options for
   managing the project.
#. Click on *Update*
#. Enter the email addresses which the reports should be sent to in
   *Recipients for automatic reports.*
#. Set the *Frequency of Automatic Reports* to the preferred frequency.
#. Click *Update* to confirm the changes.

How to check how much space my project's users are occupying
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use the Report Generator (see the `previous question <#phist>`__), and
select *User disk use*. The Report Generator displays the history of
disk use—to see the current use, make sure that the reporting period
includes the present moment. The disk usage values known to the database
are updated four times a day, so if there is a lot of activity in your
project, the numbers shown could be significantly different from the
current ones.

There's an unresolvable problem with this: if a user has an account
which belongs to more than one project, the disk usage shown for that
account will be the total that the account is using in all those
projects combined.

How to request more resources (AUs and disk space)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If you need more home or work space, contact the
`helpdesk <http://www.cirrus.ac.uk/support/helpdesk/>`__. We will always
receive such requests sympathetically, and it is likely that we will be
able to allocate some more to your project.

If you need extra time, you should contact the research council which is
funding your project. The helpdesk cannot allocate time without
authorisation from them.
