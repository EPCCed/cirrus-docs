SAFE Guide for Individual Users
===============================

`SAFE <https://safe.epcc.ed.ac.uk/safadmin/>`__ is an online user
service management system. Through SAFE, individual users can request
machine accounts, reset passwords, see available resources and track
their usage. All users must be registered on SAFE before they can apply
for their machine account.

`Registering, logging in, passwords <#reg-log-pass>`__
------------------------------------------------------

-  `How to register on SAFE <#register>`__
-  `How to login to SAFE <#login>`__
-  `How to change your personal details on SAFE <#details>`__
-  `How to change your email address on SAFE <#chemail>`__
-  `How to change your SAFE password <#chpass>`__
-  `How to reset your SAFE password if lost or forgotten <#reset>`__
-  `How to request a machine account <#getac>`__
-  `How to reset a password on your machine account <#reset_machine>`__
-  `How can to pick up your password for the service
   machine <#getpass>`__
-  `How to request access to a Package Group <#package-group>`__

`User Mailing Options <#user-mailing>`__
----------------------------------------

-  `How to view user mailings <#mailings>`__
-  `How to get added to, or removed from the email mailing
   list? <#mlist>`__

`Tracking and managing available resources <#tracking>`__
---------------------------------------------------------

-  `How to check how much time and space are available <#ures>`__
-  `How to request more AUs/disk space <#resources>`__
-  `How to review your usage of the service, or the activity of the
   service as a whole <#uhist>`__

`Miscellaneous <#miscellaneous>`__
----------------------------------

-  `How to check the queries you have submitted to the
   helpdesk <#checkq>`__
-  `How to register your approval — or your annoyance <#token>`__

| 

--------------

Registering, logging in, passwords
----------------------------------

How to register on SAFE
~~~~~~~~~~~~~~~~~~~~~~~

#. Go to the SAFE `New User Signup
   Form <https://safe.epcc.ed.ac.uk/safadmin//signup.jsp>`__
#. Fill in your personal details. You can come back later and change
   them if you wish
#. Click "Submit"
#. You are now registered. Your SAFE password will be emailed to the
   email address you provided. You can then login with that email
   address and password

| At this point your account is registered on the SAFE but you do not
  have a machine account for Cirrus. To obtain a machine account on
  Cirrus you require a *Project Code*. Your project's PI or Project
  Manager should be able to supply you with these details.
| Once you have them you should:

#. Log into SAFE
#. On the Main page, click the "Request New Account" button.
#. Select the correct project from the drop down list

How to login to SAFE and Overview of Main Page
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#. Go to the SAFE https://safe.epcc.ed.ac.uk/safadmin/
#. Type in the email address you have registered with
#. Type in your SAFE password
#. Click "Login"
#. You are now on the Main Page and here you can see Menus along the top
   which give access to SAFE functionality

How to change your personal details on SAFE
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

`Login to SAFE <#login>`__. Then:

#. Go to the Menu *Your details* and select *Update personal details*
#. Make the changes you wish
#. Click *Commit Update* to save the changes
#. Go back to *Your details* and you will see the revised information

Do not forget the last step, or nothing will happen. Note that your
postal address does not automatically include the name of your
department and institution; if you want these in your postal address,
you must type them again.

How to change your email address on SAFE
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

`Login to SAFE <#login>`__. Then:

#. Go to the Menu *Your details* and select *Update email*
#. Enter the new email address and click *Request*

A verification email will then be sent to the new email address. This
email contains a link which you must use to verify your new address. On
acknowledging your new address the change will be committed and you must
use the new email address when logging into SAFE

How to change your SAFE password
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

`Login to SAFE <#login>`__. Then:

#. Go to the Menu *Your details* and select *Change SAFE password*
#. Fill in the boxes and click *Change*

How to reset your SAFE password
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Go to https://safe.epcc.ed.ac.uk/safadmin/. Then:

#. Enter your email address
#. Click *Email*
#. SAFE will mail your password to your email address

SAFE will only mail to email addresses it already knows. But email is
not a secure medium, so if you change your password this way, you should
immediately change it again `from inside the SAFE. <#chpass>`__

Of course, anyone could go to SAFE, type your email address and request
a new password by clicking "Email". If that happens you will receive an
email message out of the blue saying that your password has been
changed. In this case you should certainly change your password again.

How to request a machine account
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

`Login to SAFE <#login>`__. Then:

#. Go to the Menu *Login accounts* and select *Request login account*
#. Choose the project you want the account for in the "Choose Project
   for Machine Account" box.
#. Choose the machine you want the account for in the "Machine Name"
   box.
   By default, it contains the current service machine.
#. Enter the username you would prefer to use on the service machine
   Every username must be unique, and you must create a new machine
   account with a unique username for each project you work on.
   Usernames cannot be used on multiple projects, even if the previous
   project has finished.

Next you will be asked to accept the `Terms and Conditions of
Access <http://www.cirrus.ac.uk/about-cirrus/policies/>`__, by clicking
the appropriate button. When you do this, you will be sent an
acknowledgment by email, which will include your SAFE password— you
should `change this as soon as possible. <#chpass>`__

Now you have to wait for your PI or project manager to accept your
request to register. When this has happened, the systems team are
prompted to create your account on the service machine. Once this has
been done, you will be sent an email. You can then `pick up your
password <#getpass>`__ for the service machine from your SAFE account.

How to reset a password on your machine account
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If you still remember your current machine account password, you can
simply log in to Cirrus as normal and then use the passwd command

::

    passwd

You will then be prompted to enter your current password, and then your
new password twice. Your password must comply with the `password
policy <https://www.cirrus.ac.uk/about-cirrus/policies/passwords_usernames.php>`__.

If you have forgotten your current password, or it has expired, then you
can ask for it to be reset:

`Login to SAFE <#login>`__. Then:

#. Go to the Menu *Login accounts* and select the account you need the
   new password for
#. Click *username* which displays details of this service machine
   account.
#. Click *New Login Account Passwd*

Now the systems team will change your password. When this has been done,
you will be informed by email; this means that you can come back to SAFE
and `pick up your new password <#getpass>`__.

How can I pick up my password for the service machine?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Wait till you receive the email with your details. Then:

#. `Login to SAFE <#login>`__.
#. Go to the Menu *Login accounts* and you will see your account on the
   service machine listed. Click *username*
#. This will display details of your account. Click *View Login Account
   Password* You will need to enter in your SAFE password and then click
   *view*, and you will see your password to the service machine

This password is generated randomly by the software. It's best to
copy-and-paste it across when you log in to the service machine.

After you login, you will be prompted to change it. You should paste in
the password retreived from SAFE again, and then you will be prompted to
type in your new, easy-to-remember password, twice. Your password must
comply with the `password
policy <https://www.cirrus.ac.uk/about-cirrus/policies/passwords_usernames.php>`__.

Note that when you change your password on the service machine in this
way, this is not reflected on the SAFE.

How to request access to a Package Group
----------------------------------------

Some software which is installed on Cirrus can only be accessed once the
user's license has been confirmed.

For some of these packages, such as gamessuk, VASP4 and VASP5 you can
request access via SAFE

#. `Log in to SAFE <#login>`__
#. Go to the Menu *Login accounts* and select the account which requires
   access to the package
#. Click "New Package Group Request"
#. Select the package from the list of available packages and click
   "Select Package Group"
#. Fill in as much information as possible about your license, at the
   very least, the information requested at the top of the screen such
   as the licence holder's name and contact details.
   If you are covered by the license because the licence holder is your
   supervisor, for example, please state this.
#. Click "Submit"

Your request will then be processed by the Cirrus support team who will
confirm your license with the package developers before enabling your
access to the package on Cirrus. This can take several days but you will
be advised once this has been done.

If you require access to a package which does not yet appear in the list
of available packages then please just send an email to helpdesk to
request access. We are still working to add the available packages.

| 

User Mailing Options
--------------------

How to view user mailings
~~~~~~~~~~~~~~~~~~~~~~~~~

| All mailings are archived and can be viewed in
  `SAFE <https://safe.epcc.ed.ac.uk/safadmin/>`__.
| Please `login to SAFE <#login>`__ and go to the section *View user
  mailings*. Press the *View* button to access the mailings.

How to get added to, or removed from the email mailing list?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

There are three mailing list options available.

-  The *Major Announcements* mailings will contain information on major
   service upgrades and future plans. This option is enabled for all
   users by default.
-  The *Service News* mailings will contain information on training
   courses, newsletters, events, and other general announcements. This
   option is enabled for all users by default.
-  The *System Status Notifications* will inform users when the service
   goes up or down, including the reminders of the next planned
   maintenance shutdowns. This option is not enabled by default, those
   wishing to receive this information will need to explicitly subscribe
   to it.

Any combination of these three options may be selected via SAFE:

#. `Login to SAFE <#login>`__.
#. Go to the Menu *Your details* click *Email list settings*
#. In the panel headed *Mailing list preferences* click on the options
   you would like to subscribe to.
#. Click *Update List Preferences*

**Note 1:** There is an option to unsubscribe from the user mailings
completely, which overrides any option enabled in *Mailing list
preferences* panel.

#. Click on the Menu *Your details* click *Update personal details* find
   *Opt out of user emails* field and click it
#. Click *Commit Update*

Do not forget the last step, or nothing will happen.

**Note 2:** Regardless of whether you are subscribed to a particular
mailing list, you can still view ALL user mailings which have been sent,
in SAFE. See `here <#mailings>`__ for details.

| 

Tracking and Managing Available Resources
-----------------------------------------

How to check how much time and space are available to you
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

`Login to SAFE <#login>`__ and Go to the Menu *Login accounts*, select
the *username* which you wish to see details for. You will then see the
information for this account. You will see the quotas for the disk space
(if the project group is using these) and how much is in use. You can
also see which file systems your project is using. Under the heading
'Volume' you will see entries for RDF (if used by your project), home
and work and in brackets after each, the name of the filesystem they are
hosted on, followed by the current usage by your project, and total
quota.

The budget values displayed are updated every morning, and the values
shown for disk use are updated four times a day. For this reason, all
these values may not be completely up-to-date. If there is a lot of
activity in your project, the numbers shown could be significantly
different from from the current ones.

How to request more kAUs/disk space
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

In the first instance, please contact the principal investigator, or the
project manager of your project. The PI will then take the necessary
steps to either allocate you more resources out of the project reserve,
or to request an increase from the helpdesk/research councils.

The helpdesk does not own project resources and has no authority to
allocate them to individual users. This responsibility lies with the
project PI/project manager.

How to review the use you have made of the service, or the activity of the service as a whole
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

`Login to SAFE <#login>`__. Then:

#. Go to the Menu *Service information* and select *Report Generator*
#. Select the report you wish to run and the format you want the output
   in (web, PDF, CSV, XML) by clicking the appropriate icon in the list.
#. Complete the required information in the form: this will usually
   consist of at least a date range to analyse and may have other
   options depending on the report you are running.
#. Click *Generate Report*

If you are a PI or Project Manager, you will have access to additional
reports to generate information on whole projects or groups as well as
your own usage and the usage of the service as a whole.

| 

Miscellaneous
-------------

How to check the queries you have submitted to the helpdesk
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

`Login to SAFE <#login>`__. Then:

#. Go to the Menu *Help and Support* and select *Your support requests*
#. Click the number of a query to check the contents of the query log

This will show you the queries of yours that haven't yet been resolved.
Note that some of the internal correspondence about a query will not be
shown. You can also use SAFE to submit a query—use *New support
request*.

How to register your approval — or your annoyance
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

`Login to SAFE <#login>`__. Then:

#. Go to the Menu *Help and Support* and select *Service feedback*
#. Click on the scale somewhere between 5 penalty points and 5 gold
   stars indicating your level of anger or delight.
#. Optionally: enter a comment in the comment box.
#. Click *Set Token*

The tokens may appear in the public service reports, although your name
will not be published with them. Although an entry in the comment field
is optional, it necessarily gives greater weight to your
feelings—without it we cannot tell why you have set a token.

|
