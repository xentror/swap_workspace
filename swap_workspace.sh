#! /bin/sh

active_workspace=`i3-msg -t get_workspaces`
current=`echo $active_workspace | jq -r 'map(select(.focused))[0].name'`
output=`echo $active_workspace | jq -r 'map(select(.focused))[0].output'`

numbers1=`echo $active_workspace | jq -c 'map(select(.output == "'$output'"))[].name'`
numbers2=`echo $active_workspace | jq -c 'map(select(.output != "'$output'"))[].name'`

for number in $numbers1
do
    i3-msg workspace $number
    i3-msg move workspace to output left
done

for number in $numbers2
do
    i3-msg workspace $number
    i3-msg move workspace to output left
done


i3-msg workspace $current

