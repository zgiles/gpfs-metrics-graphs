#!/usr/bin/expect

set timeout 300

spawn ssh -l manage 1.1.1.1
expect {
        "Password:" { exp_send "!manage\r" } }

# initial grab before reset of stats
send_user "Initial sample includes cumulative data up to now:\n\n\n"
expect -re "# "
exp_send "show controller-statistics\n"
expect -re "# "
exp_send "show disk-statistics\n"
expect -re "# "
exp_send "show host-port-statistics\n"
expect -re "# "
exp_send "show volume-statistics\n"
expect -re "# "
exp_send "show vdisk-statistics\n"
expect -re "# "
sleep 10 


# reset stats
#send_user "Resetting Statistics to ZERO...\n\n\n"
#exp_send "reset all-statistics\n"
#expect -re "# "

# collection loop

set count 1
# count is minutes per sleep below
while {$count < 250} {
        send_user "#####################\n"
        send_user "# iteration $count of 250\n"
        send_user "#####################\n"
        exp_send "\n"
        exp_send "show controller-statistics\n"
        expect -re "# "
        sleep 2 
        exp_send "show disk-statistics\n"
        expect -re "# "
        sleep 2 
        exp_send "show host-port-statistics\n"
        expect -re "# "
        sleep 2 
        exp_send "show volume-statistics\n"
        expect -re "# "
        sleep 2 
        exp_send "show vdisk-statistics\n"
        expect -re "# "

        sleep 60 
        incr count 1
}

exp_send "exit\n"
expect  "closed."
exp_send "\n~.\n"
close -i $spawn_id
