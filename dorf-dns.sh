#/usr/bin/env sh

EMAIL=EMAIL #Cloudflare E-Mail
API_KEY=API_KEY #Cloudflare API Key w/ Edit Zone DNS permission
ZONE_ID=ZONE_ID #Zone ID
A_RECORD_NAME="A_RECORD_NAME" #Record name ex: dorf-dns.dorf-dns.com
A_RECORD_ID=A_RECORD_ID_FROM_ #Record ID: Use dorf-dns-id.sh, and the instructions in the comments to obtain the unique identifier.

#You do not need to edit anything past this point. The top values are the only things that need to be changed for this script to push.
#You can test this by executing the script without any arguments, and checking what got pushed to the Cloudflare API.
DATE=$(date)

#Retrieve the last recorded private IP address from the txt file.
IP_RECORD="saved-ip.txt"
RECORDED_IP=`cat $IP_RECORD`
echo "Saved IP: ${RECORDED_IP}"

#Fetch the current private IP address and save it to a variable.
PRIVATE_IP=$(ifdata -pa wlp5s0) || exit 1
echo "Current IP: ${PRIVATE_IP}"

#If the private ip has not changed, nothing needs to be done, exit.
if [ "$PRIVATE_IP" = "$RECORDED_IP" ]; then
    echo "IP is the same. Skipping..."
    exit 0
fi

#Otherwise, Record the new private IP address locally
echo $PRIVATE_IP > $IP_RECORD

#Record the new private IP address on Cloudflare using API v4
RECORD=$(cat <<EOF
{ "type": "A",
  "name": "$A_RECORD_NAME",
  "content": "$PRIVATE_IP",
  "ttl": 180,
  "proxied": false,
  "comment": "DO NOT CHANGE!!! Updated by dorf-dns at: ${DATE}"}
EOF
)
echo "Recorded: ${RECORD}"
curl "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$A_RECORD_ID" \
     -X PUT \
     -H "Content-Type: application/json" \
     -H "X-Auth-Email: $EMAIL" \
     -H "Authorization: Bearer $API_KEY" \
     -d "$RECORD"