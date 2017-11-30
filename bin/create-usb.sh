#!/bin/bash
BUILD="${PR:="RDF"}"

if [ "${DEBUG:=false}" = "true" ]; then
  set -o xtrace
fi

#shopt extglob           # shows extglob status
#shopt -s extglob        # enables extglob
#shopt -p                # shows extglob status
version=${BUILD}-$(cat VERSION)
small_version=$(cat VERSION)
BOX_VERSION=virtualbox-ubuntu1604-${version}.box
for i in  $(ls -d /media/michl/PR_*); do
    mkdir ${i}/builds || true
    cd ${i}/builds
    # See: https://stackoverflow.com/questions/17959317/bash-delete-all-files-and-directories-but-certain-ones
    # rm !($BOX_VERSION) || true
    for f in $(ls virtualbox-ubuntu1604-*); do
        if (echo $f | grep -v ${small_version}); then
            rm $f
            #echo löschen
        fi
    done

    cd -
    rsync -av ./builds/${BOX_VERSION}  ${i}/builds/;
    rsync -av ./builds/windows_2016_hyperv_virtualbox.box  ${i}/builds/;
    # rsync -av ./builds/windows_2016_hyperv_virualbox.box  ${i}/builds/;
    rsync -av ./Vagrantfile ${i}/
    rsync -av --human-readable --ignore-errors --delete ./downloads/ ${i}/downloads/
    rsync -av --human-readable --exclude='.vagrant' ka-sa-pr-build ${i}
done
shopt -u extglob    # disables extglob
shopt extglob       # shows extglob status
sync
