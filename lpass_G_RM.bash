#!/usr/bin/env bash
# notes go here
# something about an author
# unsure why we license scripts and APIs but insert one later
#

for i in $LPASS_G_RM
do
	echo $i;
	echo deleting $(lpass show --id $i --name);
	#lpass rm $i;
        echo complete;
done
echo "syncing Lastpass..."
lpass sync
echo complete
