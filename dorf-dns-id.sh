#/usr/bin/env sh
#Script to fetch your Cloudflare "dynamic" A-record ID
#This A-record ID is important, because it's a fixed identifier for the record. It's used to contact the API to update the record.
#You need the Zone ID, API Key, A-record ID, and E-Mail for your domain.

#EMAIL: Your Cloudflare Account E-Mail
#ZONE_ID: The Zone ID is on the right pane in the DNS settings.
#API_KEY: Create an API key (also on the right pane) with "Edit Zone DNS" on the domain of choice.
#A_NAME: Create the A-record in Cloudflare, put the subdomain in the field

EMAIL=EMAIL
ZONE_ID=ZONE_ID
A_NAME=A_NAME
API_KEY=API_KEY

#You do not need to edit anything past this point. 
#The top values are the only things that need to be changed for this script to work.
#You can test this by executing the script without any arguments, and checking what got pushed to the Cloudflare API.

curl -X GET "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records?type=A&name=$A_NAME" \
     -H "Host: api.cloudflare.com" \
     -H "User-Agent: ddclient/3.9.0" \
     -H "Connection: close" \
     -H "X-Auth-Email: $EMAIL" \
     -H "Authorization: Bearer $API_KEY" \
     -H "Content-Type: application/json"

#Find the ID in the returned output. It's at the beginning: "id":"BIGLONGIDSTRINGYTHING"