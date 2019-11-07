#!/bin/bash

#assumptions include
#you have this script in the root of your project from where you're running
#you have a defaultdevhubusernameset

#simple while loop to prompt user for alias name everytime they run this
#-z is an empty string
while [ -z "$ORG_ALIAS" ] && [ -z "$DURATION" ]
    do
        echo "enter an alias"
        read ORG_ALIAS

        echo "enter duration of scratch from 1-30 days"
        read DURATION

        echo "okay thanks, requesting new org"

        #referencing local files and using the '-s' to make this scratch org your default username
        sfdx force:org:create -s -f config/project-scratch-def.json -a ${ORG_ALIAS} -d ${DURATION} --json
    done

#each command gets a pid, process id represented by $? if this fails then we'll let you know.
# exiting with any status >0 will also stop a circle ci build

if [ "$?" = "1" ]
then
    echo "something went wrong, try again i guess"
    exit 1
fi

echo "we got an org, lets push some code!"

sfdx force:source:push -u ${ORG_ALIAS} -g -f

if [ "$?" = "1" ]
then
    echo "your deployment failed"
    exit 1
fi

echo "code pushed successfully!!"

echo " now I could do some more stuff!!"
wait 3
echo " we could assign permission sets to your user"
echo
echo "I could create a new user"
echo " by running 'sfdx force:user:create username=testuser1@my.org email=me@my.org permsets=DreamHouse'"
echo
wait 3
echo "I could insert some data"
echo "by running 'sfdx force:data:tree:import -p Account-Contact-plan.json -u me@my.org' "
wait 3
echo "i will also open this up for you"
wait 2
sfdx force:org:open