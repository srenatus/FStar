FSLIBFILES=st.fst string.fst js.fst list.fsi
FSLIB=$(addprefix ../../lib/, $(FSLIBFILES))
FSTAR=../../bin/FStar.exe --admit_fsi List $(OTHERFLAGS)

TESTS=constants.js strings.js fun.js tuples.js record.js

all: clean init $(TESTS) close

init:
	echo "<!doctype html><html><body><script src=\"lib/stdlib.js\"></script>" > tests.htm

close:
	echo "</body></html>" >> tests.htm

%.js: %.fst
	$(FSTAR) --silent --codegen JavaScript $(FSLIB) $^ > $@
	echo "<script src=\"$@\"></script>" >> tests.htm

clean:
	rm -fr tests.htm *.js *~
