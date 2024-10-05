PREFIX		?=	/usr/local
INSTALLDIR	=	${DESTDIR}${PREFIX}


all:

lint:
	shellcheck -s bash -x share/opsh/*.bash bin/opsh make-release

install:
	for i in bin share ; do mkdir -p ${INSTALLDIR}/$$i ; done
	cp bin/opsh ${INSTALLDIR}/bin/.
	cp -r share/* ${INSTALLDIR}/share/.

release:
	./bin/opsh ./make-release

clean:

distclean: clean
	git clean -f -d -x
