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

activeMonitors=`xrandr | grep "connected" | cut -d' ' -f1 | head -n 2`
monitor1=`echo $activeMonitors | cut -d' ' -f 1`
monitor2=`echo $activeMonitors | cut -d' ' -f 2`

xrandr --output $monitor1 --brightness 0 2>/dev/null
xrandr --output $monitor2 --brightness 0 2>/dev/null


# got the each worspace and swap it into the other screen
for number in $numbers1, $numbers2
do
    i3-msg workspace $number 1>&2 > /dev/null
    # change to left if your layout is left and right instead of up and down
    i3-msg move workspace to output up 1>&2 > /dev/null
done

if [ $BASEDIR != "." ]; then
    #echo return to current directory
    cd $save_pwd
fi

i3-msg workspace $current 1>&2 >/dev/null

# wait 0.2 sec before setting the brightness of the screen to 1
# increase the time if any visual glitches appears
# decrease the time if you want to make the swap faster
sleep 0.2

xrandr --output $monitor1 --brightness 1 2>/dev/null
xrandr --output $monitor2 --brightness 1 2>/dev/null


