#!/bin/bash

for i in  $(ls -d /media/michl/PR_*); do
    rsync -av ../builds/virtualbox-ubuntu1604-$(cat ../VERSION).box  ${i}/builds/;
    rsync -av ../Vagrantfile ${i}/
    rsync -av ../downloads/* ${i}/downloads/
done
