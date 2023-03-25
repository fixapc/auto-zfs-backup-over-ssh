#!/bin/bash
#ZFS Pool Backup Script By Fixapc.net
#Date 2023-03-24
#The hostname of your remote server, can be an ip or a domain name
host=fixapc.net
#The pool name on your remote server
remotepool=rpool
#This can be named anything you want
datasetname=fixapcmainrig
#SSH ALGORITRM
sshalgorithm=aes256-gcm@openssh.com
#Set IFS
IFS=$'\n'
read -rd '' -a rpoolarray <<<"$(zfs list | awk '{print $1}' | tail -n +2)"
read -rd '' -a remotename <<<"$(zfs list | awk '{print $1}' | tail -n +2 | sed 's&/&&g' | sed 's&^&'$datasetname'&g')"
for ((i=0; i<${#rpoolarray[@]}; i++)); do
zfs destroy "${rpoolarray[i]}"@sendbackup 2> /dev/null
zfs snap "${rpoolarray[i]}"@sendbackup
zfs send -v "${rpoolarray[i]}"@sendbackup | ssh -C -c $sshalgorithm root@$host zfs recv -v -F $remotepool/"${remotename[n]}"
done