#!/usr/bin/python
# Modify the database connect string below and the path to part1 much more below

import sys
import os
import signal
import subprocess
import time
import MySQLdb
import time

def install_sigint_handler ():
    signal.signal(signal.SIGINT, sigint_handler)

def sigint_handler (signal, frame):
    sys.exit(-1)

def main ():
    install_sigint_handler()
    period = 5
    now = int(time.time())
    first = poll3015()
#    print first
#    time.sleep(period)
#    second = io_s()
    try:
        db = MySQLdb.connect(host="db1", user="usernamefordb", passwd="passwordfordb", db="dbasename")
        cur = db.cursor()
        for k in first['controllers']:
            query = "INSERT INTO ef3015_controllers VALUES (DEFAULT, '" + str(now) + "', '" + str(now) + "', '" + str(k['id']) + "', '" + str(k['load']) + "', '" + str(k['uptime']) + "', '" + str(int(k['bps'])) + "', '" +  str(k['iops']) + "', '" + str(k['reads']) + "', '" + str(k['writes']) + "', '" + str(int(k['dataread'])) + "', '" + str(int(k['datawritten'])) + "')"
            cur.execute(query)
            db.commit()
        for k in first['disks'] + first['vols'] + first['vdisks']:
            query = "INSERT INTO ef3015_blockstats VALUES (DEFAULT, '" + str(now) + "', '" + str(now) + "', '" + str(k['id']) + "', '" + str(k['serial']) + "', '" + str(int(k['bps'])) + "', '" +  str(k['iops']) + "', '" + str(k['reads']) + "', '" + str(k['writes']) + "', '" + str(int(k['dataread'])) + "', '" + str(int(k['datawritten'])) + "')"
            cur.execute(query)
            db.commit()
        for k in first['hostports']:
            query = "INSERT INTO ef3015_hostports VALUES (DEFAULT, '" + str(now) + "', '" + str(now) + "', '" + str(k['id']) + "', '" + str(int(k['bps'])) + "', '" +  str(k['iops']) + "', '" + str(k['reads']) + "', '" + str(k['writes']) + "', '" + str(int(k['dataread'])) + "', '" + str(int(k['datawritten'])) + "', '" + str(k['queuedepth']) + "')"
            cur.execute(query)
            db.commit()
    except MySQLdb.Error, e:
        print "Error: %s" %e
	print query

def poll3015 ():
    part1 = subprocess.Popen(
        ['/home/myuser/mysql-ef3015-part1.sh'],
        stdin  = subprocess.PIPE,
        stdout = subprocess.PIPE,
        )
    output, _ = part1.communicate(input=None)
    raw = [s.strip().split() for s in output.splitlines() if s.startswith(("controller","gs","vol","disk","hostport"))]
    return { 
         'controllers': [controllerchop(s) for s in raw if s[0].startswith("controller")],
         'disks': [diskchop(s) for s in raw if s[0].startswith("disk")],
         'hostports': [hostportchop(s) for s in raw if s[0].startswith("hostport")],
         'vols': [volchop(s) for s in raw if s[0].startswith("vol")],
         'vdisks': [vdiskchop(s) for s in raw if s[0].startswith("gs_")]
         }

def expandscale(l):
   b={'B':1,'KB':1000,'MB':1000000,'GB':1000000000,'TB':1000000000000}
   if (l[-2:] in b):
      c=float(l[0:-2])*float(b[l[-2:]]) 
   elif (l[-1:] in b):
      c=float(l[0:-1])*float(b[l[-1:]]) 
   else: 
      print "problem with: '" + l + "'"
      c=0
   return c

def controllerchop(l):
    return {
        'id': l[0].split("_")[1],
        'load': l[1],
        'uptime': l[2],
        'bps': expandscale(l[3]),
        'iops': l[4],
        'reads': l[5],
        'writes': l[6],
        'dataread': 0,
        'datawritten': 0,
#        'dataread': expandscale(l[7]),
#        'datawritten': expandscale(l[8])
        }

def diskchop(l):
    return {
         'id': l[0].split(".")[1],
         'serial': l[1],
         'bps': expandscale(l[2]),
         'iops': l[3],
         'reads': l[4],
         'writes': l[5],
         'dataread': 0,
         'datawritten': 0,
#         'dataread': expandscale(l[6]),
#         'datawritten': expandscale(l[7])
         }

def hostportchop(l):
    return {
        'id': l[0].split("_")[1],
        'bps': expandscale(l[1]),
        'iops': l[2],
        'reads': l[3],
        'writes': l[4],
	'dataread': 0,
	'datawritten': 0,
	'queuedepth': 0
#        'dataread': expandscale(l[5]),
#        'datawritten': expandscale(l[6]),
#        'queuedepth': l[7]
        }

def volchop(l):
    return {
        'id': l[0],
        'serial': l[1],
        'bps': expandscale(l[2]),
        'iops': l[3],
        'reads': l[4],
        'writes': l[5],
	'dataread': 0,
	'datawritten': 0,
#        'dataread': expandscale(l[6]),
#        'datawritten': expandscale(l[7])
        }

def vdiskchop(l):
    return {
        'id': l[0].split("_")[1],
        'serial': l[1],
        'bps': expandscale(l[2]),
        'iops': l[3],
        'reads': l[4],
        'writes': l[5],
	'dataread': 0,
	'datawritten': 0,
#        'dataread': expandscale(l[6]),
#        'datawritten': expandscale(l[7])
        }

def compare (first, second, key):
    return int(second[key]) - int(first[key])


def div (value, divisor):
    return int(round(1.0 * value / divisor))


main()
