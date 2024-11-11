PREFIX		?=	/usr/local
INSTALLDIR	=	${DESTDIR}${PREFIX}

ALL_SCRIPTS	=	share/opsh/*.bash bin/opsh make-release make-single-file t/*.{t,opsh}

SHFMTFLAGS	=	-i 4
all:

lint:
	shfmt ${SHFMTFLAGS} -d ${ALL_SCRIPTS}
	shellcheck -P SCRIPTDIR -s bash -x ${ALL_SCRIPTS}

test:
	PATH=$$PWD/bin:$$PATH prove -v

check: lint test

format:
	shfmt -w ${SHFMTFLAGS} ${ALL_SCRIPTS}

install:
	for i in bin share ; do mkdir -p ${INSTALLDIR}/$$i ; done
	cp bin/opsh ${INSTALLDIR}/bin/.
	cp -r share/* ${INSTALLDIR}/share/.

release:
	./bin/opsh ./make-release

clean:

distclean: clean
	git clean -f -d -x
