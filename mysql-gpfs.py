#!/usr/bin/python
# Modify the database connect string below and also maybe a commented line much more down regarding host name of cluster nodes.

import sys
import os
import signal
import subprocess
import time
import MySQLdb
import time

# bytes read
# bytes written
# opens
# closes
# reads
# writes
# readdir
# inode updates

# _io_s_ _n_ 1.1.1.1 _nn_ interactive1.ib.hpc.mssm.edu _rc_ 0 _t_ 1371756771 _tu_ 274068 _br_ 106724240336929 _bw_ 12404551988702 _oc_ 14050302 _cc_ 12763781 _rdc_ 1686627889 _wc_ 2049998992 _dir_ 24234904 _iu_ 16556310

def install_sigint_handler ():
    signal.signal(signal.SIGINT, sigint_handler)


def sigint_handler (signal, frame):
    sys.exit(-1)


def main ():
#    install_sigint_handler()
    period = 5
    first = io_s()
    time.sleep(period)
    second = io_s()
    now = int(time.time())
    try:
        db = MySQLdb.connect(host="db1", user="usernamefordb", passwd="passwordfordb", db="dbasename")
        cur = db.cursor()
        for k in first.keys():
            stat_gpfs_br = div(compare(first[k], second[k], '_br_'), period)
            stat_gpfs_bw = div(compare(first[k], second[k], '_bw_'), period)
            stat_gpfs_oc = div(compare(first[k], second[k], '_oc_'), period)
            stat_gpfs_cc = div(compare(first[k], second[k], '_cc_'), period)
            stat_gpfs_rdc = div(compare(first[k], second[k], '_rdc_'), period)
            stat_gpfs_wc = div(compare(first[k], second[k], '_wc_'), period)
            stat_gpfs_dir = div(compare(first[k], second[k], '_dir_'), period)
            stat_gpfs_iu = div(compare(first[k], second[k], '_iu_'), period)
            query = "INSERT INTO fsios VALUES (DEFAULT,'" + str(second[k]['_fs_']) + "','" + str(second[k]['_nn_']) + "','" + str(second[k]['_t_']) + "','" + str(now) + "','" + str(stat_gpfs_br) + "','" + str(stat_gpfs_bw) + "','" + str(stat_gpfs_oc) + "','" + str(stat_gpfs_cc) + "','" + str(stat_gpfs_rdc) + "','" + str(stat_gpfs_wc) + "','" + str(stat_gpfs_dir) + "','" + str(stat_gpfs_iu) + "')"
            cur.execute(query)
            db.commit()
    except MySQLdb.Error, e:
        print "Error: %s" %e
	print query
    first = second


def io_s ():
    mmpmon = subprocess.Popen(
        ['/usr/lpp/mmfs/bin/mmpmon', '-p', '-s'],
        stdin  = subprocess.PIPE,
        stdout = subprocess.PIPE,
        )
    output, _ = mmpmon.communicate("nlist add *\nfs_io_s\n")
    return dict(nodechunk([dict(chunks(s.strip().split()[1:], 2)) for s in output.splitlines() if s.startswith("_fs_io_s_")]))


def gmetric (name, hostarray, value):
    hostgpfsip = hostarray['_n_'].split('.')
    hostmgmtip = str(hostgpfsip[0]) + '.' + str(hostgpfsip[1]) + '.' + str(int(hostgpfsip[2])-4) + '.' + str(hostgpfsip[3])
    hostgpfsname = hostarray['_nn_'].split('.')
    hostmgmtname = hostgpfsname[0] # + '.yourclustername.edu' # Might need to put this for example
    spoofstring = '"' + hostmgmtip + ':' + hostmgmtname + '"'
    gmetric_ = subprocess.Popen(
            [
            '/usr/bin/gmetric',
            '--name', name,
            '--value', str(value),
            '--type', 'uint32',
            '-S', spoofstring,
            ],
        )
    gmetric_.wait()


def chunks (l, n):
    for i in xrange(0, len(l), n):
        yield l[i:i+n]

def nodechunk(l):
    for i in l:
        yield [i["_nn_"],i]

def compare (first, second, key):
    return int(second[key]) - int(first[key])


def div (value, divisor):
    return int(round(1.0 * value / divisor))


main()
