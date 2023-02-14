#!/bin/bash
# produce extention based on existing yearly forcing files
# find time index; copy file; correct time stamp

# Path to foring files 
arcm=MARv3.12
gcmscen=ACCESS1.3-rcp85
arealm=dSMB
avar=aSMB
fpath=/projects/NS8085K/PROTECT/Forcing/${arcm}/${arealm}/${gcmscen}/${avar}
# output path
extpath=/projects/NS8085K/PROTECT/Forcing/${arcm}/${arealm}/${gcmscen}_2500ext/${avar}

# File with shuffel indicies
shuffel_file=time_indices_2301-2500_ext10_v1.nc

# Create dir for extension
mkdir -p ${extpath}

# Loop through extension years
for i in {1..200} ; do

    # get year and shuffel id from file
    year_id=`ncks -F -d time,${i} -v year ${shuffel_file} | grep "year = " | sed -e "s/.*= //;s/ .*//"`

    shuffel_id=`ncks -F -d time,${i} -v shuffled_time_indices ${shuffel_file} | grep "shuffled_time_indices = " | sed -e "s/.*= //;s/ .*//"`

    echo "copy year" ${shuffel_id} "to" ${year_id} 

    fsource=${fpath}/${avar}_${arcm}-yearly-${gcmscen}-${shuffel_id}.nc
    fdest=${extpath}/${avar}_${arcm}-yearly-${gcmscen}-${year_id}.nc

    # prepare forcing file
    /bin/cp ${fsource} ${fdest}

    # Get time stamps for gregorian days since 1900-01-01
    year_id_plus1=$(( ${year_id}+1 ))
    # Get time stamps for gregorian days since 1900-01-01
    time_stamp=$(( ($(date +%s -ud "${year_id}-07-01 00:00:00") - $(date +%s -ud '1900-01-01 00:00:00'))/3600/24))
    tb1=$(( ($(date +%s -ud "${year_id}-01-01 00:00:00") - $(date +%s -ud '1900-01-01 00:00:00'))/3600/24))
    tb2=$(( ($(date +%s -ud "${year_id_plus1}-01-01 00:00:00") - $(date +%s -ud '1900-01-01 00:00:00'))/3600/24))

    echo "time stamp" $time_stamp $tb1 $tb2 

    # Adjust time stamps
    ncap2 -F -O -s "time=${time_stamp}; time_bounds[nv]={$tb1,$tb2}" ${fdest} ${fdest}

done
