desktop:
	bin/box build ubuntu1604-desktop-de virtualbox

desktop-bsa-pr:
	DEBUG=true PR=KA bin/box build ubuntu1604-desktop-de-PR virtualbox
