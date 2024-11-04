PREFIX		?=	/usr/local
INSTALLDIR	=	${DESTDIR}${PREFIX}

ALL_SCRIPTS	=	share/opsh/*.bash bin/opsh make-release t/*.{t,opsh}

all:

lint:
	shellcheck -P SCRIPTDIR -s bash -x ${ALL_SCRIPTS}

test:
	PATH=$$PWD/bin:$$PATH prove -v

check: lint test

install:
	for i in bin share ; do mkdir -p ${INSTALLDIR}/$$i ; done
	cp bin/opsh ${INSTALLDIR}/bin/.
	cp -r share/* ${INSTALLDIR}/share/.

release:
	./bin/opsh ./make-release

clean:

distclean: clean
	git clean -f -d -x
