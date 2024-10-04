all:

lint:
	shellcheck -x lib/*.bash bin/opsh

clean:

distclean: clean
	git clean -f -d -x
