#!/bin/sh
dc () {
	docker -H 127.0.0.1:4243 $@
}
while true ; do \
for i in $(dc ps | grep Capture- | sed -e 's/.* //') ; do \
        pid=$(dc inspect $i --format='{{.State.Pid}}')
        tapname=$(dc inspect $i --format='{{.Config.Hostname}}' | sed -e 's/Capture-//')
        CON=$(/opt/unetlab/wrappers/nsenter -t $pid -n netstat -napt | grep ESTABLISHED | wc -l)
        if [ $CON -eq 0 ] ; then \
                sleep 10
                CON=$(/opt/unetlab/wrappers/nsenter -t $pid -n netstat -napt | grep ESTABLISHED | wc -l)
                if [ $CON -eq 0 ] ; then \
                        dc rm --force $i
                        ID=$(echo $i | sed -e 's/Capture-//')
                        iptables -t nat -D PREROUTING -j CAP_PREROUTING_$ID
                        iptables -t nat -D POSTROUTING -j CAP_POSTROUTING_$ID
                        iptables -t nat -F CAP_PREROUTING_$ID
                        iptables -t nat -X CAP_PREROUTING_$ID
                        iptables -t nat -F CAP_POSTROUTING_$ID
                        iptables -t nat -X CAP_POSTROUTING_$ID
                fi
                # clear tc
                tc filter del dev $tapname parent 1:
                tc qdisc del dev $tapname handle 1: root prio
                tc filter del dev $tapname parent ffff:
                tc qdisc del dev $tapname ingress
                # Clear console database
                echo "delete from console where nodeId = $ID ;" | mysql -u root --password=eve-ng eve_ng_db
        fi
done

sleep 30

done
