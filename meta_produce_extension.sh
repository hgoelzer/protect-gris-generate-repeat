#!/bin/bash
# Run for a number ox forcings

set -e
#set -x

# Forcing choice
arcm=MARv3.12
gcmscen=MPI-ESM1-2-HR-ssp126 

#arcm=RACMO2.3p2
#gcmscen=CESM2-CMIP6-ssp126

#arcm=MARv3.12
#gcmscen=ACCESS1.3-rcp85

#arcm=MARv3.12
#gcmscen=UKESM1-0-LL-Robin-ssp585

#arcm=RACMO2.3p2
#gcmscen=CESM2-Leo-ssp585 


# run all variables for given model 
arealm=dSMB
avar=aSMB
. ./produce_extension_src.sh
avar=dSMBdz
. ./produce_extension_src.sh

arealm=dST
avar=aST
. ./produce_extension_src.sh
avar=dSTdz
. ./produce_extension_src.sh
