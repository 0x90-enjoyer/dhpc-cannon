range_start=$1
range_end=$2
uid=$3

ip_prefix="142.1.46."

i=$range_start

while [ $i -le $range_end ]; do
    ip_address="$ip_prefix$i"

    nc -zv -w 1 $ip_address ssh
    if [ $? -eq 0 ]; then
        ssh -o "StrictHostKeyChecking no" $ip_address "pkill -U $uid ergo; pkill -U $uid python3" &
    fi

    (( ++i ))
done
