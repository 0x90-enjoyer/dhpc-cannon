ip_prefix="142.1.46."
range_start=4
range_end=120

ssh-keygen -t rsa

for ((i=range_start; i<=range_end; i++))
do
    hostname="$ip_prefix$i"
    mkdir_command="mkdir .ssh"

    {
        ssh -o "StrictHostKeyChecking no" $hostname $mkdir_command
        cat ~/.ssh/id_rsa.pub | ssh $hostname 'cat >> .ssh/authorized_keys'
    } &
done
