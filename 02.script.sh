#! /bin/bash

# Start the %post section

%post


# I will verify is there enough space in vg to extend partition space.

vgs

# suppose we got requirement like extend 10 GB space to partition 
# so how much free space should be in vg? 10 GB

# True= If there is enough space in vg 
# Then stright away extend the partition space using lvextend command.

lvextend -L +10G /dev/dbvg/dblv01 
xfs_growfs /dev/dbvg/dblv01

%end