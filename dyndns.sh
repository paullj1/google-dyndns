#!/bin/sh

USERNAME=$(cat /run/secrets/dyn_dns_user)
PASSWORD=$(cat /run/secrets/dyn_dns_pass)

while true; do

    PUBLIC_IP=$(curl -s -k https://domains.google.com/checkip)
    DDNS_IP=$(nslookup ${HOSTNAME} 2> /dev/null | awk '/^Address 1:/ { print $3 }')

    if [ "$PUBLIC_IP" != "$DDNS_IP" ]; then

        URL="https://domains.google.com/nic/update?hostname=$HOSTNAME&myip=${PUBLIC_IP}"
        RESP=$(curl -s -k --user "${USERNAME}:${PASSWORD}" "$URL")

        case $RESP in
            "good ${PUBLIC_IP}" | "nochg ${PUBLIC_IP}")
                DDNS_IP=$(nslookup ${HOSTNAME} 2> /dev/null | awk '/^Address 1:/ { print $3 }')
                echo "`date`: $HOSTNAME successfully updated to ${PUBLIC_IP}."
                ;;
            "nohost")
                echo "`date`: The host $HOSTNAME does not exist, or does not have Dynamic DNS enabled."
                sleep 3600
                ;;
            "badauth")
                echo "`date`: The username / password combination is not valid for the host $HOSTNAME."
                sleep 3600
                ;;
            "notfqdn")
                echo "`date`: The supplied hostname $HOSTNAME is not a valid fully-qualified domain name."
                exit
                ;;
            "badagent")
                echo "`date`: Your Dynamic DNS client is making bad requests. Ensure the user agent is set in the request."
                exit
                ;;
            "abuse")
                echo "`date`: Dynamic DNS access for the hostname $HOSTNAME has been blocked."
                exit
                ;;
            "911")
                echo "`date`: An error happened on Googles end. Wait 5 minutes and retry."
                sleep 300
                ;;
            *)
                echo "`date`: $RESP"
                sleep 3600
        esac

    fi

    sleep 60

done
