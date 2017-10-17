#!/bin/bash
set -o xtrace
set -o
shopt extglob                   # shows extglob status
shopt -s extglob                # enables extglob
shopt extglob                   # shows extglob status
BOX_VERSION=virtualbox-ubuntu1604-$(cat VERSION).box
for i in  $(ls -d /media/michl/PR_*); do
    mkdir ${i}/builds || true
    cd ${i}/builds
    # See: https://stackoverflow.com/questions/17959317/bash-delete-all-files-and-directories-but-certain-ones
    rm !($BOX_VERSION) || true
    cd -
    rsync -av ./builds/${BOX_VERSION}  ${i}/builds/;
    rsync -av ./Vagrantfile ${i}/
    rsync -av ./downloads/* ${i}/downloads/
done
shopt -u extglob                # disables extglob
shopt extglob                   # shows extglob status
sync
