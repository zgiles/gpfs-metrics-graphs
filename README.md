A new appraoch for correlating GPFS Metrics
============================================

This repo contains the code that is mentioned in MSST 2015 Paper 70 by Zachary Giles.
__ Paper is under review and will be released when it is published __

Some of this code is modified from different vendors' example codes, Others are written directly.

This code is not intended for you to just directly run it, as not everyone will have the same exact hardware or configuration. Rather, use it as an example of a method to gather stats from your controllers, using it for these controllers if you have them, and / or adding your own when you find them.
The instructions will assume you have this hardware, as there are software dependencies, which the installation will help explain.

Setup
---------------
You will need:
* Python 2
* Python MySQLdb
* Python argparse (if your system does not have it for some reason)
* Python ddnapi (DDN_SFA_API-1.5.3.1.g_r13962-py2.6.egg / ddn.sfa.api) from DDN
* An original copy of 'vdstat.py' from DDN
* expect
* A MySQL server with a database with SELECT and INSERT permissions (after you create the tables)
* A web server that can run PHP scripts and serve static files
* PHP
* PHP MySQLdb library

Access to:
* IP access to the management interfaces of the EF3015 metadata controller
* IP access to the DDN SFA10K couplet controller(s)
* root access to a server in the GPFS cluster
* Access to the MySQL server from the server that will run the above scripts

Order:
* Put the www folder somewhere in your web server.
* Hardcode all the username/passwords/ips in all the files
* Create the MySQL tables from tables.sql
* Recreate vdstats.py (below)
* Test the scripts, maybe, by commenting out the MySQL lines for print statements instead, or by letting it go to MySQL and check the table contents.
* Test the webpage.
* Run everything (below)


Recreating vdstats.py
---------------
A file mysql-vdstats.py.diff is included that shows the differences between the vendor file and my file. 
The MD5SUMs for each are below, so you can try and make them the same if you'd like.
a284573f0775bcee88b240922696fbf8  mysql-vdstats.py
d495d8b259ddb83ebc034c779a311b6d  vdstats.py


Running
---------------
In 3 separate terminals, launch:
python ./mysql-vdstats.py -H 1.1.1.5 -U admin -P password -d 8 -i 100000
while true; do ./mysql-ef3015-part2.sh ; date +%s; sleep 10; done
while true; do python mysql-gpfs.py ; sleep 5; date +%s; done


Todos:
---------------
* Make testing switches
* Centralize DB configs instead of hardcoding
* Make a single centralized python script to collect all the stats with modules for each controller type
* Add more controllers
* REST interface for adding data to the db instead of hitting the DB directly
* Merge three REST interfaces for graphs into single file
* Convert PHP to Python so we have only one language in the project
* Clean up Highcharts JS 
* Switch to React? 
