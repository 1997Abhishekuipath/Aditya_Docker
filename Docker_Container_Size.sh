#!/bin/bash

echo
docker container ls --format "table {{.ID}} {{.Image}} {{.Size}}"  | awk '{print $1,$2,$3}' | tr -s ' ' | jq -c -Rn 'input  | split(" ") as $head |inputs | split(" ") |to_entries |map(.key = $head[.key]) |[ .[:2][], { key: "DATA", value: (.[2:] | from_entries) } ] |from_entries'> /tmp/zabbix/size5.json


function readFileAttributes
{
python3 - <<HERE
import datetime
import os.path
import time
import json
import os


#f = open('size.json',"r")
#data=json.load(f.read())
#print(data)
#for i in data:
#       print(i)


#f.close()


ans=[]
with open('/tmp/zabbix/size5.json', 'r') as f:
        states_list = [line.strip() for line in f.readlines()]

        #print(states_list)
        #state=[]
        for state in sorted(states_list):
                #print(type(state))
                #name=state["CONTAINER"]
                #print(name)


                sss = json.loads(state)
                #print(sss)
                id=sss["CONTAINER"]
                name=sss["ID"]
                sizes=sss["DATA"]["IMAGE"]
                s=sizes
                a=len(s)
                #print(s[a-2]+s[a-1])
                p=s[a-2]+s[a-1]
                #print(p)
                v=0
                if p=='MB':
                   v=0
                else:
                   v=1
                #print(v)

                #print(sizes)
                size= float(sizes.rstrip("MB"))
                #print(id,name,size)
                #aditya=[]
                #for aditya in sss:
                #       name=aditya["CONTAINER"]
                #       print(name)
                #ss=json.load(sss)
                #epsg_json = json.loads(sss.replace("\'", '"'))  //remove backlash
                #print(ss)

                ans.append({"{#CONTAINERID}":id,"{#NAME}":name,"{#SIZE}":size,"{#SIZEUNIT}":p})

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
# Aditya_docker
