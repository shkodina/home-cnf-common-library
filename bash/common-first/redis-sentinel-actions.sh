function fredis-redis-scan-role-by-base-count () {  #  $1 = host_base  $2 = start  $3 = stop
    while true
    do 
        echo 
        sleep 2
        for i in $(seq $2 $3)
        do 
            echo $1$i $(redis-cli -h $1$i -p 6379 info Replication | grep role)
        done
    done
}



function fredis-redis-scan-role-by-host-list () {  #  $@ = hosts splited by space
    while true
    do 
        echo 
        sleep 2
        for i in $@
        do 
            echo $1$i $(redis-cli -h $i -p 6379 info Replication | grep role)
        done
    done
}



function fredis-redis-cmd-by-base-count () {  #  $1 = host_base  $2 = start  $3 = stop  $4 = cmd
    while true
    do 
        echo 
        sleep 2
        for i in $(seq $2 $3)
        do 
            echo $1$i 
            redis-cli -h $1$i -p 6379 $4
        done
    done
}




function fredis-sentinel-scan-roles-by-base-count () {  #  $1 = host_base  $2 = start  $3 = stop
    while true
    do 
        echo 
        sleep 2
        for i in $(seq $2 $3)
        do 
            echo $1$i master: $(redis-cli -h $1$i -p 26379 sentinel master mymaster | grep -A 1 ip | grep -v ip )
            echo $1$i slaves: $(redis-cli -h $1$i -p 26379 sentinel slaves mymaster | grep -A 1 ip | grep -v ip )
        done
    done
}



function fredis-sentinel-scan-roles-by-host-list () {  #  $@ = hosts splited by space
    while true
    do 
        echo 
        sleep 2
        for i in $@
        do 
            echo $1$i master: $(redis-cli -h $i -p 26379 sentinel master mymaster | grep -A 1 ip | grep -v ip )
            echo $1$i slaves: $(redis-cli -h $i -p 26379 sentinel slaves mymaster | grep -A 1 ip | grep -v ip )
        done
    done
}
