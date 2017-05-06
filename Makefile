WORKSHOP_SRC=$(wildcard workshop/*.md)
WORKSHOP_HTML=$(WORKSHOP_SRC:.md=.html)

ALL_HTML=README.html $(WORKSHOP_HTML)

%.html: %.md
	grip $^ --user benkolera --pass '$(GRIP_TOKEN)' --export $@
	perl -pi -e 's/href="(.+).md"/href="$$1.html"/g' $@

docs: clean $(ALL_HTML)

clean:
	rm -f $(ALL_HTML)

