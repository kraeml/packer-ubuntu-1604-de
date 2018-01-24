desktop:
	TMPDIR=/home/michl/tmp bin/box build ubuntu1604-desktop-de

desktop-virtualbox:
	TMPDIR=/home/michl/tmp bin/box build ubuntu1604-desktop-de virtualbox

desktop-vmware:
	TMPDIR=/home/michl/tmp bin/box build ubuntu1604-desktop-de vmware

desktop-bsa-pr:
	ansible-playbook pr_packer.yml

desktop-bsa-pr-sa1:
	DEBUG=true PR=SA_1 bin/box build ubuntu1604-desktop-de-PR virtualbox

make-usb-pr:
	DEBUG=true PR=KA bin/create-usb.sh

make-usb:
	DEBUG=true bin/create-usb.sh

make-ka:
	#rm -rf ka-sa-pr-build/* || true
	mkdir -p ka-sa-pr-build/builds || true
	rsync -av --human-readable builds/*KA* ka-sa-pr-build/builds
	mv ka-sa-pr-build/builds/Vagrantfile.KA* ka-sa-pr-build/Vagrantfile
	mv ka-sa-pr-build/builds/Makefile.KA* ka-sa-pr-build/Makefile
	sed -i 's/    /\t/g' ka-sa-pr-build/Makefile

make-ka-complete:
	rm -rf ka-sa-pr-build/* || true
	#make desktop-bsa-pr
	make make-ka

galaxy:
	sudo ansible-galaxy install --role-file=requirements.yml
test-ansible: galaxy
	ansible-playbook -i localhost, -e ansible_connection=local --skip-tags=packer --tags=testing ansible/main.yml
full-ansible: galaxy
	ansible-playbook -vvv -i localhost, -e ansible_connection=local --skip-tags=packer ansible/main.yml
no-nodejs-ansible: galaxy
	ansible-playbook -vvv -i localhost, -e ansible_connection=local --skip-tags=packer,nodejs ansible/main.yml
todo-ansible: galaxy
	ansible-playbook -vvv -i localhost, -e ansible_connection=local --skip-tags=packer --tags=todo ansible/main.yml
