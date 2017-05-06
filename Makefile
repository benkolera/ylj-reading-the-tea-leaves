WORKSHOP_SRC=$(wildcard workshop/*.md)
WORKSHOP_HTML=$(WORKSHOP_SRC:.md=.html)
GRIP_TOKEN=188ab7eba91dc8b4053686a1e0f7f16dcc85c109

ALL_HTML=README.html $(WORKSHOP_HTML)

%.html: %.md
	grip $^ --user benkolera --pass '$(GRIP_TOKEN)' --export $@
	perl -pi -e 's/href="(.+).md"/href="$$1.html"/g' $@

docs: clean $(ALL_HTML)

clean:
	rm -f $(ALL_HTML)

