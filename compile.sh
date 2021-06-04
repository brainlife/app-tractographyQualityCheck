#!/bin/bash

set -e
set -x

#for hpc
#module unload matlab
#module load matlab/2019a

#make sure all required dep directories exist
if [ ! -d /N/u/brlife/git ]; then
    echo "/N/u/brlife/git doesn't exist"
    exit 1
fi

log=compiled/commit_ids.txt
true > $log
echo "/N/u/brlife/git/encode" >> $log
(cd /N/u/brlife/git/encode && git log -1) >> $log
echo "/N/u/brlife/git/jsonlab" >> $log
(cd /N/u/brlife/git/jsonlab && git log -1) >> $log
echo "/N/u/brlife/git/vistasoft" >> $log
(cd /N/u/brlife/git/vistasoft && git log -1) >> $log
echo "/N/u/brlife/git/wma_tools" >> $log
(cd /N/u/brlife/git/wma_tools && git log -1) >> $log

cat > build.m <<END
addpath(genpath('/N/u/brlife/git/encode'))
addpath(genpath('/N/u/brlife/git/jsonlab'))
addpath(genpath('/N/u/brlife/git/vistasoft'))
addpath(genpath('/N/u/brlife/git/wma_tools'))
mcc -m -R -nodisplay -d compiled main

exit
END

matlab -nodisplay -nosplash -r build && rm build.m

