The Object Store
================

In addition to the lustre file-system Cirrus also has access to an high-capacity, object store system.
This web service provides an additional place for you to store your data but it works in a different way from
the file system. Normally you would not access the object store directly from
within your programs but it is a good place to archive data to free up space for new calculations.
The object store uses the same API as the Amazon S3 object store so many compatible clients and tools are available

+ Unlike files, objects cannot be modified or appended to. They are uploaded and downloaded as complete objects.
  However it is possible to replace an Object with an entirely new version.
+ The object store can be accessed from anywhere with an internet connection, not just Cirrus.

.. note:: If you would like access to the object store for your project, please contact the Cirrus helpdesk: support@cirrus.ac.uk


Access Keys
-----------

Object store access permissions and storage quotas are based on AccessKeys. An access key consists of two parts:

#. The name of the AccessKey
#. A corresponding AccessSecret

There is also a UUID that can be used as a unique identifier for the key

For example:

:AccessKey: AKIA74IP98S48W5D9EPR
:AccessSecret: xKvB5lXB3gbP47T+TLkRT+DUfl98BY20io0nkV9q
:UUID: 	3a36a0fef03518827ca41992e934850b8bbf7c28

These are a little bit like a randomly generated Username/Password pair which makes them difficult to guess but as you will need to store the secret in
tools and scripts care needs to be taken to ensure that they are kept secret.

Buckets
-------

Objects in the store are organised in collections called buckets. Every object has a URL of the form

https://cirrus-s3.epcc.ed.ac.uk/bucket-name/object-name

If an object is set to be "public" then *anyone* can download the object using a web-browser and this URL. For non-public objects additional parameters or http headers are needed to handle authentication.

Bucket and object names should therefore be chosen to ensure these URLs are valid. Good practice is to stick to alphanumeric characters underscores and hyphens.
In particular you should avoid spaces as these cause problems with some tools. An object name *can* contain slashes giving the appearance of a directory structure within
the bucket. However this is purely cosmetic. File browsing tools usually present object names with slashes as a directory hierarchy but the object store just sees them as part of the object name.

Depending on the permissions the objects within a bucket may belong to different access-keys to the bucket itself. However storage quotas are always calculated based on the owner of the bucket not the object.

Permissions and ACLs
--------------------

Access permissions can be set on both buckets and objects. The Cirrus object store supports a combination of three permissions.

1) Read
2) Write
3) Full-control

For buckets:

+ Read permission allows you to lists its contents. You do *not* need this to access the object itself as long as you know the object name.
+ Write permission allows you to add or delete objects.
+ Full-control allows you to change permissions on the bucket.

For objects:

+ Read permission allows the object to be downloaded.
+ Full-control allows you to change permissions on the object.

These permissions can be granted to individual keys using an AccessControlList (ACL). You will usually need to specify the key using its UUID when doing this.
You can also grant permissions to two additional classes of users:

:Authenticated users: This means *any* active key known to the object store.
:All users: This means *everyone* with an internet connection.

You may want to set *read* permissions of this type when publishing *public* data but you should never grant write or full-control permissions to these groups.

The simplest way of using the object-store is for each user to have a personal access-key and quota. This will allow each user to store and retrieve their own data independently. However this
makes large scale data sharing difficult. ACLs need to be set for every object that include the key of every user that needs access. Whenever membership of the access group changes, the ACLs of every object needs to be updated.

If you want to support data sharing you may wish to generate additional keys
representing different levels of access. For example a key that is allowed to modify a shared data-set and another that is only allowed to read it. You can then share these keys with the appropriate groups of people. This makes managing the ACLs much less work as they only have to reference the shared keys.
When someone leaves a group you can revoke their access by changing the AccessSecret for the shared key and re-distributing the new secret to the remaining members.

ACLs should be set using the client interface to the object store - it is not possible to set ACLs through the SAFE interface.


Managing the Object Store from SAFE
-----------------------------------

Keys and quotas are managed through the SAFE. If a SAFE project has an allocation on the object store there will be a "Object store quotas" section in the Project Administration page for that project.
Project managers can click on the button in that section to manage keys and quotas. From the quota management page you have two options:

New key
   To create a new AccessKey
List keys
   To show and manage existing keys.

When creating a key you need to provide a name for the key and a storage quota for the new key. The sum of all the key quotas within a project must be less than the total storage allocation of the project.

The List-keys page shows a list of the existing keys for the project. Click on one of the links to manage the corresponding key. The following options are available for each key:

View secret
   This shows details about the key including the AccessKey name, the AccessSecret and the UUID.
Set permissions
   This allows a project manager to share the key with selected members of the project.
   When a key is shared with somebody they will be able to view and download the key from the SAFE.
   If you want to revoke access to a key you can remove this permission then use *Regenerate* to change the AccessSecret.
   Other people who still have the key shared with them
   will be able to download the new secret as before.
Test
   The SAFE will connect to the object store using the key and check that the key is working.
List Buckets
   This shows the buckets owned by the key.
   You can also click-through to the bucket and browse its contents (using that keys permissions).
Change quota
   This allows a project manager to change the size of the storage quota allocated to the key.
Lock/Unlock
   An AccessKey can be locked/unlocked by a project manager. While a key is locked it cannot be used to access the object store.
Regenerate
   A project manger can use this to change the AccessSecret.
   Permitted Users will be able to download the new value from the SAFE.


When a user had been given access to a key using the "Set permissions" menu the key will appear in their SAFE
navigation menu under "Login accounts"->"Credentials". This will then give them access to the following functions:

+ View secret
+ Test
+ List Buckets

Browsing the Object store from your desktop
-------------------------------------------

Windows: Cloudberry
~~~~~~~~~~~~~~~~~~~

There are a number of File browser UIS that van be used to browse the object store on your desktop. For example the
Cloudberry browser can be used on Windows https://www.cloudberrylab.com/explorer/amazon-s3.aspx and can be setup
in the following way:

+ Download and install the Freeware GUI from the above link.
+ Select File->"New S3 compatible account"->"S3 Compatible"
+ Fill in your AccessKey and AccessSecret. Use ``https://cirrus-s3.epcc.ed.ac.uk`` as the Service end-point.

Others: s3cmd
~~~~~~~~~~~~~

On non-Windows systems and for those that prefer command-line access we recommend that you install ``s3cmd``:

+ https://s3tools.org/s3cmd

This tool can also be installed in user space on other HPC systems using miniconda. Install miniconda using
the command line installer as described in the :doc:`python` chapter of this User Guide and then you can add
``s3cmd`` with:

 conda install -c conda-forge s3cmd

Using s3cmd to work with the object store on Cirrus
---------------------------------------------------

The Object store uses the Amazon S3 protocol so can be accessed using any of the standard tools developed to access AWS-S3.
On the Cirrus command line, we have made ``s3cmd`` available via the standard Anaconda distribution. To get access to the
tool, you first need to load the ``anaconda`` module:

   module load anaconda

Once the module is loaded, you can access the ``s3cmd`` tool.

Configure s3cmd
~~~~~~~~~~~~~~~

.. note:: You only need to do this once, before the first time you manipulate data on the object store.

Before you use ``s3cmd`` on Cirrus to transfer data, you need to first create a configuration file, run:

  s3cmd --configure

and use the following answers to the configuration questions:

+ *Access Key:* use the value from SAFE
+ *Secret Key:* use the value from SAFE
+ *Default Region* ``uk-cirrus-1``
+ *S3 Endpoint:* ``cirrus-s3.epcc.ed.ac.uk``
+ *DNS-style bucket+hostname:port template for accessing a bucket* ``cirrus-s3.epcc.ed.ac.uk/%(bucket)``
+ *Encryption password:* leave blank.
+ *Path to GPG program:* leave blank
+ *Use HTTPS protocol:* ``Yes``
+ *HTTP Proxy server name:* leave blank
+ *Test access with supplied credentials?* ``Y``
+ *Save settings?* ``y`` to save the credential

You can re-run this command later to change any setting and it will default to your previous selections.

You can run ``s3cmd --help`` to see the various supported commands. We briefly describe how to create buckets,
upload data from Cirrus, list buckets and their contents and download data to Cirrus in the sections below.

.. note:: Cirrus object-store does not support the CloudFront or Glacier options.

Create a bucket
~~~~~~~~~~~~~~~

Firstly, you need to create a bucket to store your data using ``s3cmd mb``:

::

  [auser@cirrus-login0 ~]$ s3cmd mb s3://examplebucket
  Bucket 's3://examplebucket/' created

Upload data to the bucket
~~~~~~~~~~~~~~~~~~~~~~~~~

Now, you can upload data (as objects) to the bucket with ``s3cmd put``:

::

  [auser@cirrus-login0 ~]$ s3cmd put ~/random_2G.dat s3://examplebucket/random.dat
  WARNING: Module python-magic is not available. Guessing MIME types based on file extensions.
  upload: '/general/z01/z01/auser/random_2G.dat' -> 's3://examplebucket/random.dat'  [part 1 of 137, 15MB] [1 of 1]
   15728640 of 15728640   100% in    0s    22.16 MB/s  done
  upload: '/general/z01/z01/auser/random_2G.dat' -> 's3://examplebucket/random.dat'  [part 2 of 137, 15MB] [1 of 1]
   15728640 of 15728640   100% in    0s    25.31 MB/s  done

  ...

  upload: '/general/z01/z01/auser/random_2G.dat' -> 's3://examplebucket/random.dat'  [part 137 of 137, 8MB] [1 of 1]
   8388608 of 8388608   100% in    0s    32.80 MB/s  done

By default, any object larger than 15MB in size is uploaded as a multipart upload - the data is split into smaller chunks and uploaded a piece at a time instead of as a single operation. In the example above, ``s3://examplebucket/random.dat`` is uploaded as 137 parts of default chunk size 15MB. This has the advantage that if a ``s3cmd put`` operation is interrupted, it's possible to continue the operation where it left off. If uploading large objects and experiencing issues, you may need to experiment with increasing the multipart chunk size, either with using the ``multipart-chunk-size-mb=N`` option (where N is the desired new chunk size in megabytes), or by altering the default globally in your ``.s3cfg`` file in your home directory. The maximum allowed chunk size is 5GB.

Continue a paused or failed upload by passing ``--upload-id=`` to the put command, plus the hash of the update to be continued. This is given at the point the initial upload is stopped, or details of all pending multipart uploads associated with a bucket can be found with ``s3cmd multipart`` and the name of the bucket:

::

   [auser@cirrus-login0 ~]$ s3cmd multipart s3://examplebucket
   s3://examplebucket/
   Initiated       Path    Id
   2019-12-12T13:22:27.000Z        s3://examplebucket/random.dat        7775611dd0c93819353abf93aa9bc7e6

Please be aware that incomplete multipart uploads do not expire and must be manually either continued or aborted to clear them. If not cleared then they will continue occupying that space in your project storage quota. To delete uploads from this queue rather than continue them, use ``s3cmd abortmp``.

Listing buckets and the contents of buckets (objects)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

You can list your buckets with ``s3cmd ls``:

::

  [auser@cirrus-login0 ~]$ s3cmd ls
  2019-06-05 11:26  s3://examplebucket

and the contents of buckets (i.e. objects) with ``s3cmd ls s3://<bucket>``:

::

  [auser@cirrus-login0 ~]$ s3cmd ls s3://examplebucket
  2019-06-05 11:28 2147483648   s3://examplebucket/random.dat

Downloading objects
~~~~~~~~~~~~~~~~~~~

Use the ``s3cmd get`` command to download data from a bucket:

::

  [aturner@cirrus-login0 ~]$ s3cmd get s3://examplebucket/random.dat
  download: 's3://examplebucket/random.dat' -> './random.dat'  [1 of 1]
  8388608 of 8388608   100% in    15s    32.80 MB/s  done
