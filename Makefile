PREFIX		?=	/usr/local
INSTALLDIR	=	${DESTDIR}${PREFIX}


all:

lint:
	shellcheck -x lib/*.bash bin/opsh

install:
	for i in bin lib ; do mkdir -p ${INSTALLDIR}/$$i ; done
	cp bin/opsh ${INSTALLDIR}/bin/.
	cp lib/* ${INSTALLDIR}/lib/.

clean:

distclean: clean
	git clean -f -d -x
