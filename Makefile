desktop:
	bin/box build ubuntu1604-desktop-de virtualbox

desktop-bsa-pr:
	DEBUG=true PR=KA bin/box build ubuntu1604-desktop-de-PR virtualbox

make-usb:
	DEBUG=true PR=KA bin/create-usb.sh

make-ka:
	#rm -rf ka-sa-pr-build/* || true
	mkdir -p ka-sa-pr-build/builds || true
	rsync -av --human-readable builds/*KA* ka-sa-pr-build/builds
	mv ka-sa-pr-build/builds/Vagrantfile.KA* ka-sa-pr-build/Vagrantfile
	mv ka-sa-pr-build/builds/Makefile.KA* ka-sa-pr-build/Makefile
	sed -i 's/    /\t/g' ka-sa-pr-build/Makefile

test-ansible:
	sudo ansible-galaxy install --role-file=requirements.yml
	ansible-playbook -i localhost, -e ansible_connection=local --skip-tags=packer --tags=testing ansible/main.yml
