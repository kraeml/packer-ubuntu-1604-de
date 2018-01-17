#!/bin/bash

cd ~/Dokumente/Schule/Bento-Boxen/packer-ubuntu-1604-de
vagrant destroy --force
vagrant up rdf
cd -
