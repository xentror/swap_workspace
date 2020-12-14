#! /bin/sh

# get basedir of the shell script because for unknown reason 
# it only work inside his directory
BASEDIR=`dirname "$0"`
# echo $BASEDIR
save_pwd=$PWD

# change to the base directory if not already in it
if [ $BASEDIR != "." ]; then
    #echo change directory
    cd $BASEDIR
fi

# JSON of all the actives worspaces
active_workspace=`i3-msg -t get_workspaces`

# current workspace name we are working on
current=`echo $active_workspace | jq -r 'map(select(.focused))[0].name'`

# output format of the screen you are working on
output=`echo $active_workspace | jq -r 'map(select(.focused))[0].output'`

# lists of workspaces group by screen location
numbers1=`echo $active_workspace | jq -c 'map(select(.output == "'$output'"))[].name'`
numbers2=`echo $active_workspace | jq -c 'map(select(.output != "'$output'"))[].name'`

# got the each worspace and swap it into the other screen
for number in $numbers1, $numbers2
do
    i3-msg workspace $number 1>&2 > /dev/null
    i3-msg move workspace to output left 1>&2 > /dev/null
done

if [ $BASEDIR != "." ]; then
    #echo return to current directory
    cd $save_pwd
fi

i3-msg workspace $current 1>&2 >/dev/null

