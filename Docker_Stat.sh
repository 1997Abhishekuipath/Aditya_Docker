#!/bin/bash

echo
#docker stats  --format "table {{.ID}} {{.Image}} {{.Size}}"  | awk '{print $1,$2}' | tr -s ' ' | jq -c -Rn 'input  | split(" ") as $head |inputs | split(" ") |to_entries |map(.key = $head[.key]) |[ .[:2][], { key: "DATA", value: (.[2:] | from_entries) } ] |from_entries'> /tmp/zabbix/stats.json
docker stats  --no-stream --format "{{ json . }}" > /tmp/zabbix/stats.txt


function readFileAttributes
{
python3 - <<HERE
import datetime
import os.path
import time
import json
import os

ans=[]
with open('/tmp/zabbix/stats.txt', 'r') as f:
	stats_list = [line.strip() for line in f.readlines()]
	#print(stats_list)

	for stat in sorted(stats_list):
		statsusage=json.loads(stat)
		#print(statsusage)
		id=statsusage["ID"]
		name=statsusage["Name"]
		cpu=statsusage["CPUPerc"]
		cpuper = float(cpu.replace("%",""))
		mem=statsusage["MemPerc"]
		memper = float(mem.replace("%",""))
		#print(id,type(cpuper),memper)

		ans.append({"{#CONTAINERID}":id,"{#CONTAINERNAME}":name,"{#CPUPERCENTAGE}":cpuper,"{#MEMORYPERCENTAGE}":memper})
	
	ansYES={"data":ans}
	#print(ansYES)
	yy=json.dumps(ansYES)
	print(yy)


HERE
}
fileAttr=$(readFileAttributes)
echo "$fileAttr"
# Aditya_docker
# Aditya_docker
