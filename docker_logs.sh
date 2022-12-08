#!/bin/bash

echo
docker ps  --format "table {{.ID}} {{.Image}} {{.Size}}"  | awk '{print $1,$2}' | tr -s ' ' | jq -c -Rn 'input  | split(" ") as $head |inputs | split(" ") |to_entries |map(.key = $head[.key]) |[ .[:2][], { key: "DATA", value: (.[2:] | from_entries) } ] |from_entries'> /tmp/zabbix/logs.json

#echo
#chown zabbix:zabbix /tmp/zabbix

function readFileAttributes
{
python3 - <<HERE
import datetime
import os.path
import time
import json
import os
import argparse

#parser = argparse.ArgumentParser(description='Docker Logs')
#parser.add_argument('-i','--containerid',Type=int,help='Container Id')
#args = parser.parse_args()

#ID=args.containerid

#os.system(chown zabbix:zabbix /tmp/zabbix/logs.json)
ans=[]
with open('/tmp/zabbix/logs.json', 'r') as f:
	cont_file = [line.strip() for line in f.readlines()]
	#print(cont_file)

	for cont in sorted(cont_file):
		#print(cont)
		contlogs=json.loads(cont)
		id=contlogs["CONTAINER"]
		#print(id)


		docker_logs="docker logs "+ id +" | grep Error "" >> /tmp/zabbix/"+id+"-error.txt"
		os.system(docker_logs)


		file1 = open("/tmp/zabbix/"+id+"-error.txt",'r+')
		print(file1.read())
		

HERE
}
fileAttr=$(readFileAttributes)
echo "$fileAttr"
