Debugging using Arm DDT
===========================

The Arm Forge tool suite is installed on Cirrus. This includes DDT,  which is a
debugging tool for scalar, multi-threaded and large-scale parallel applications.
To compile your code for debugging you will usually want to specify the ``-O0``
option to turn off all code optimisation (as this can produce a mismatch between
source code line numbers and debugging information) and ``-g`` to include
debugging information in the compiled executable. To use this package you will
need to log in to Cirrus with X11-forwarding enabled, load the Arm Forge module
and execute ``forge``:

::

    module load forge
    forge

Debugging runs on the login nodes
---------------------------------

You can execute and debug your MPI code on the login node which is useful for
immediate development work with short, small, simple runs to avoid having to wait in
the queue. Firstly ensure you have loaded the ``mpt`` module and any other
dependencies of your code, then start Forge and click *Run*. Fill in the
necessary details of your code under the *Application* pane, then tick the *MPI*
tick box, specify the number of MPI processes you wish to run and ensure the
implementation is set to *HPE MPT (2.18+)*. If this is not set correctly then
you can update the configuration by clicking the *Change* button and selecting
this option on the *MPI/UPC Implementation* field of the system pane. When you
are happy with this hit *Run* to start.

Debugging runs on the compute nodes
-----------------------------------

This involves DDT submitting your job to the queue, and as soon as the compute
nodes start executing you will drop into the debug session and be able to
interact with your code. Start Forge and click on *Run*, then in the
*Application* pane provide the details needed for your code. Then tick the *MPI*
box -- when running on the compute nodes, you must set the MPI implementation to
*Slurm (generic)*. You must also tick the *Submit to Queue* box. Clicking the
*Configure* button in this section, you must now choose the submission template.
One is provided for you at
``/mnt/lustre/indy2lfs/sw/arm/forge/latest/templates/cirrus.qtf`` which you should copy
and modify to suit your needs. You will need to load any modules required for
your code and perform any other necessary setup, such as providing extra sbatch
options, i.e., whatever is needed for your code to run in a normal batch job.

.. note::
  The current Arm Forge licence permits use on the Cirrus CPU nodes only.
  The licence does not permit use of DDT/MAP for codes that run on the Cirrus GPUs.

Back in the DDT run window, you can click on *Parameters* in the same queue pane
to set the partition and QoS to use, the account to which the job should be
charged, and the maximum walltime. You can also now look at the *MPI* pane again
and select the number of processes and nodes to use. Finally, clicking *Submit*
will place the job in the queue. A new window will show you the queue until the
job starts at which you can start to debug.

Memory debugging with DDT
-------------------------

If you are dynamically linking your code and debugging it on the login node then
this is fine (just ensure that the *Preload the memory debugging library* option
is ticked in the *Details* pane.) If you are dynamically linking but intending
to debug running on the compute nodes, or statically linking then you need to
include the compile option ``-Wl,--allow-multiple-definition`` and explicitly
link your executable with Allinea's memory debugging library. The exactly
library to link against depends on your code; ``-ldmalloc`` (for no threading
with C), ``-ldmallocth`` (for threading with C), ``-ldmallocxx`` (for no
threading with C++) or ``-ldmallocthcxx`` (for threading with C++). The library
locations are all set up when the *forge* module is loaded so these libraries
should be found without further arguments.

Remote Client
--------------

Arm Forge can connect to remote systems using SSH so you can run the user
interface on your desktop or laptop machine without the need for X forwarding.
Native remote clients are available for Windows, macOS and Linux. You can
download the remote clients from the `Arm website
<https://developer.arm.com/downloads/-/arm-forge>`__.
No licence file is required by a remote client.

.. note:: The same versions of Arm Forge must be installed on the local and remote systems in order to use DDT remotely.

To configure the remote client to connect to Cirrus, start it and then click on
the *Remote Launch* drop-down box and click on *Configure*. In the new window,
click *Add* to create a new login profile. For the hostname you should provide
``username@login.cirrus.ac.uk`` where ``username`` is your login username. For
*Remote Installation Directory** enter ``/mnt/lustre/indy2lfs/sw/arm/forge/latest``. To
ensure your SSH private key can be used to connect, the SSH agent on your local
machine should be configured to provide it. You can ensure this by running
``ssh-add ~/.ssh/id_rsa_cirrus`` before using the Forge client where you should
replace ``~/.ssh/id_rsa_cirrus`` with the path to the key you normally use to
log in to Cirrus. This should persist until your local machine is restarted --
only then should you have to re-run ``ssh-add``.

If you only intend to debug jobs on the compute nodes no further configuration
is needed. If however you want to use the login nodes, you will likely need to
write a short bash script to prepare the same environment you would use if you
were running your code interactively on the login node -- otherwise, the
necessary libraries will not be found while running. For example, if using MPT,
you might create a file in your home directory containing only one line::

    module load mpt

In your local Forge client you should then edit the *Remote Script* field in the
Cirrus login details to contain the path to this script. When you log in the
script will be sourced and the software provided by whatever modules it loads
become usable.

When you start the Forge client, you will now be able to select the Cirrus login
from the Remote Launch drop-down box. After providing your usual login password
the connection to Cirrus will be established and you will be able to start
debugging.

You can find more detailed information `here
<https://developer.arm.com/documentation/101136/2011/Arm-Forge/Connecting-to-a-remote-system>`__.

Getting further help on DDT
---------------------------

-  `DDT website <https://www.arm.com/products/development-tools/server-and-hpc/forge/ddt>`__
-  `DDT user guide <https://developer.arm.com/documentation/101136/22-1-3/DDT?lang=en>`__
