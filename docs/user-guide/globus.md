# Using Globus to transfer data to/from Cirrus /work filesystem

## Setting up Cirrus /work

Navigate to [https://app.globus.org](https://app.globus.org)

Log in with your Globus identity (this could be a globusid.org or other identity)

![image](../images/globus/1-login.jpg)


In File Manager, use the search tool to search for “e1000-fs1 directories”. Select it.

![image](../images/globus/2-e1000-search.jpg)

In the transfer pane, you are told that Authentication/Consent is required. Click Continue.

![image](../images/globus/3-continue.jpg)

![image](../images/globus/4-link-eidf.jpg)

Click on the EIDF safe (safe.epcc.ed.ac.uk) link

![image](../images/globus/5-safe.jpg)

Select the correct User account (if you have more than one)

Click Accept

![image](../images/globus/6-continue.jpg)

Now confirm your Globus credentials – click Continue


![image](../images/globus/7-identity.jpg)

Click on the SAFE id you selected previously

![image](../images/globus/8-safe.jpg)

Make sure the correct User account is selected and Accept again

Your Cirrus /work directory will be shown 

![image](../images/globus/9-work.jpg)

!!! Warning 
    Your Cirrus `/work` directory will be listed as `/home/projectID/projectID/username`  <br>
    The file system which is used for `/work` on Cirrus is mounted as `/home` on the e1000

## Setting up the other end of the transfer

### Laptop

![image](../images/globus/10-destination.jpg)

If you wish to transfer data to/from your personal laptop or other device, click on the Collection Search

![image](../images/globus/11-globus-connect-personal.jpg)

Use the link to “Get Globus Connect Personal” to create a Collection for your local drive.

![image](../images/globus/12-to-laptop.jpg)

### Other server e.g. JASMIN 

If you wish to connect to another server, you will need to search for the Collection e.g. JASMIN Default Collection and authenticate

Please see the [JASMIN Globus page for more information](https://help.jasmin.ac.uk/docs/data-transfer/globus-transfers-with-jasmin/)

![image](../images/globus/13-jasmin.jpg)

Once you are connected to both the Source and Destination Collections, you can use the File Manager to select the files to be transferred, and the click the Start button to initiate the transfer

![image](../images/globus/14-transfer.jpg)

A pop-up will appear once the Transfer request has been submitted successfully

Clicking on the “View Details” will show the progress and final status of the transfer

![image](../images/globus/15-result.jpg)

![image](../images/globus/16-transferred.jpg)

## Using a different Cirrus account

If you want to use Globus with a different account on Cirrus, you will have to go to Settings

![image](../images/globus/17-settings.jpg)

Manage Identities

![image](../images/globus/18-unlink.jpg)

And Unlink the current EIDF safe identity, then repeat the link process with the other Cirrus account