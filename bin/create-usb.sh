#!/bin/bash
set -o xtrace

shopt extglob           # shows extglob status
shopt -s extglob        # enables extglob
shopt -p                # shows extglob status

BOX_VERSION=virtualbox-ubuntu1604-$(cat VERSION).box
for i in  $(ls -d /media/michl/PR_*); do
    mkdir ${i}/builds || true
    cd ${i}/builds
    # See: https://stackoverflow.com/questions/17959317/bash-delete-all-files-and-directories-but-certain-ones
    rm !($BOX_VERSION) || true
    cd -
    rsync -av ./builds/${BOX_VERSION}  ${i}/builds/;
    rsync -av ./builds/windows_2016_hyperv_virualbox.box  ${i}/builds/;
    # rsync -av ./builds/windows_2016_hyperv_virualbox.box  ${i}/builds/;
    rsync -av ./Vagrantfile ${i}/
    rsync -av --human-readable --ignore-errors --delete ./downloads/ ${i}/downloads/
done
shopt -u extglob    # disables extglob
shopt extglob       # shows extglob status
sync
