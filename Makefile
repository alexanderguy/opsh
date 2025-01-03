PREFIX		?=	/usr/local

ALL_SCRIPTS	=	share/opsh/*.opsh bin/opsh make-release make-single-file t/*.{t,opsh} .githooks/pre-{commit,push}

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

release:
	./bin/opsh ./make-release

clean:

distclean: clean
	git clean -f -d -x
