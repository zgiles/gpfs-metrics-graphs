#!/usr/bin/expect

set timeout 300

spawn ssh -l manage 1.1.1.1
expect {
        "Password:" { exp_send "!manage\r" } }
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
exp_send "exit\n"
expect  "closed."
exp_send "\n~.\n"
close -i $spawn_id
