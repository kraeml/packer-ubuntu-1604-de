#!/bin/bash
BUILD="${PR:="RDF"}"

if [ "${DEBUG:=false}" = "true" ]; then
  set -o xtrace
fi
if [ "${SCHUELER:=Schueler}" = "true" ]; then
  SCHUELER="foo"
fi

version=${BUILD}-$(cat VERSION)
small_version=$(cat VERSION)
BOX_VERSION='*-ubuntu1604-'${version}'.box'
for i in  $(ls -d /media/michl/PR_*); do
    mkdir ${i}/builds || true
    cd ${i}/builds
    for f in $(ls v*-ubuntu1604-*); do
        if (echo $f | grep -v ${small_version}); then
            rm $f
            #echo löschen
        fi
    done
    cd -
    rsync -av --progress ./builds/${BOX_VERSION}  ${i}/builds/;
    rsync -av --progress ./builds/windows_2016_hyperv_virtualbox.box  ${i}/builds/;
    # rsync -av ./builds/windows_2016_hyperv_virualbox.box  ${i}/builds/;
    rsync -av --progress ./Vagrantfile ${i}/
    rsync -av --progress --human-readable --exclude='.git*' \
      --exclude='.ipynb_checkpoints' \
      --exclude='.cache' \
      --exclude='__pycache__' \
      --exclude='python.itcarlow.ie' \
      --exclude=${SCHUELER} \
      --ignore-errors \
      --delete \
      ./downloads/ ${i}/downloads/
    rsync -av --progress --human-readable \
      --exclude='.vagrant' ka-sa-pr-build ${i}
done
sync
