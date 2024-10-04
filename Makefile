PREFIX		?=	/usr/local
INSTALLDIR	=	${DESTDIR}${PREFIX}


all:

lint:
	shellcheck -x share/opsh/*.bash bin/opsh

install:
	for i in bin share ; do mkdir -p ${INSTALLDIR}/$$i ; done
	cp bin/opsh ${INSTALLDIR}/bin/.
	cp -r share/* ${INSTALLDIR}/share/.

clean:

distclean: clean
	git clean -f -d -x
