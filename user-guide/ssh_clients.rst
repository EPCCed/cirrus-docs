Logging In To Cirrus 

SSH Clients
===========

Interaction with Cirrus is done remotely, over an encrypted
communication channel, Secure Shell version 2 (SSH-2). This allows
command-line access to one of the login nodes of a Cirrus, from which
you can run commands or use a command-line text editor to edit files.
SSH can also be used to "tunnel" GUI programs such as GUI text editors
and debuggers.

Logging in from Linux and Macs
------------------------------

Linux distributions and OS X each come installed with a terminal
application that can be use for SSH access to the login nodes. Linux
users will have different terminals depending on their distribution and
window manager (e.g. GNOME Terminal in GNOME, Konsole in KDE). Consult
your Linux distribution's documentation for details on how to load a
terminal.

OS X users can use the Terminal application, located in the Utilities
folder within the Applications folder.

You can use the following command from the terminal window to login into
Cirrus:

::

    ssh username@login.cirrus.ac.uk

To allow remote programs, especially graphical applications to control
your local display, such as being able to open up a new GUI window (such
as for a debugger), use:

::

    ssh -X username@login.cirrus.ac.uk 

Some sites recommend using the ``-Y`` flag. While this can fix some
compatibility issues, the ``-X`` flag is more secure.

Current OS X systems do not have an X window system. Users should
install the XQuartz package to allow for SSH with X11 forwarding on OS X
systems:

::

    http://www.xquartz.org/ 

Logging in from Windows using MobaXterm
---------------------------------------

A typical Windows installation will not include a terminal client,
though there are various clients available. We recommend all our Windows
users to download and install MobaXterm to access Cirrus. It is very
easy to use and includes an integrated X server with SSH client to run
any graphical applications on Cirrus.

You can download MobaXterm Home Edition (Installer Edition) from the
following link:

::

    http://mobaxterm.mobatek.net/download-home-edition.html 

Double-click the downloaded Microsoft Installer file (.msi), and the
Windows wizard will automatically guides you through the installation
process. Note, you might need to have administrator rights to install on
some Windows OS. Also make sure to check whether Windows Firewall hasn't
blocked any features of this program after installation.

Start MobaXterm using, for example, the icon added to the Start menu
during the installation process.

If you would like to run any small remote GUI applications, then make
sure to use -X option along with the ssh command (see above) to enable
X11 forwarding, which allows you to run graphical clients on your local
X server.


Alternative programs to logging in from Windows
===============================================

**Putty**

Alternatively, a suitable and free client, called PuTTY, is available
for all recent versions of Windows. It can be downloaded and installed
following the instructions on the PuTTY website, provided you have the
appropriate permissions for your computer. Otherwise, you may need to
ask a system administrator to complete the installation for you.

::

    http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html

But, if you wish to run graphical applications such as an editor, a
debugger, or a visualisation tool on Cirrus, then you will also need an
X Server. Again, this is not usually part of a Windows installation,
though there are various options including XMing for which there is both
a free and a paid-for version. Putty does not have its own X server.
XMing can be downloaded from the following link:

::

    http://sourceforge.net/projects/xming/ 

Start PuTTY using, for example, the icon added to the Start menu during
the installation process, which will open a configuration window.

The configuration window may look a little daunting, as it presents the
full configurability of PuTTY on a single screen. However, it is
relatively straightforward to set up a simple session using the
following steps.

(If necessary, click on Session in the list of configuration items in
the left-hand pane) then enter the hostname *login.cirrus.ac.uk* into
the Host Name field on the right and check that the Connection type is
set to SSH.

If you want to run remote GUI applications, then in the left-hand pane,
expand the configuration options for SSH (by clicking on the + symbol
immediately to the left of it) and then click on X11. Then make sure
that the option "Enable X11 forwarding" in the right-hand pane is
checked. This allows you to run graphical clients on your local X
server.

Return to the Session section (as edited in step 1) and enter a
memorable name, such as the short hostname, in the field immediately
below Saved Sessions text. Then click the Save button to add your new
session to the list of saved sessions. This means that you will not
repeat the configuration process next time you run PuTTY: instead you
can simply highlight it in the list of Saved Sessions and click the Load
button.

Finally, click Open to start the session. The configuration window will
disappear and be replaced by a terminal window.

Assuming this is first time you have connected to the remote host from
your computer, you will be asked to confirm that you trust the host.
Confirm so by clicking Yes. PuTTY will then remember the fingerprint of
this remote host and will not prompt you to trust this host again.

You may now enter your username and password, as prompted, to log in.

You may explore other PuTTY configuration options: for example, setting
colours and mouse-interaction options, at your leisure. Make sure to
save any changes you make in your session object. At this time, you may
wish to check that your X Server is also installed correctly, with the
following steps:

Start XMing (or your chosen X Server) from the Windows Start menu:
typically the X server will start in the background and wait quietly for
you to start an application in your terminal client. To do this, change
the focus to the terminal and type the command:

::

    xclock

at the prompt. If everything is in order, a simple clock application
should appear on your desktop. However, your firewall software may pop
up a warning, since the X Server sets up a connection to the remote host
that many firewalls are not familiar with. You should allow the
connection through the firewall in order to run the application.

**Cygwin**

Apart from MobaXterm and Putty, Cygwin can also be used to login from
Windows and is a port of many applications to Windows, including ssh and
X, which is available from the following link:

::

    http://www.cygwin.com


