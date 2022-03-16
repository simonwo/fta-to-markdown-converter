MD_FILES := $(patsubst %.docx,%.md,$(wildcard docx/*.docx))

.PHONY: all
all: $(MD_FILES)

.PHONY: clean
clean:
	$(RM) $(MD_FILES)

%.md.raw: %.docx
	pandoc $< -t json | python3.9 filter.py stream | pandoc -f json -t markdown -o $@
	sed -i -z -E 's/## Article ([0-9]+\.[0-9]+)\n+### ([^\n]+)/## Article \1: \2\n/g' $@

%.md: disclaimer.txt %.md.raw
	cat $^ > $@

