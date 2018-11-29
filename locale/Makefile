# Makefile providing various facilities to manage translations
# Adapted from https://github.com/godotengine/godot/blob/master/editor/translations/Makefile

TEMPLATE = escape-space.pot
POFILES = $(wildcard *.po)
LANGS = $(POFILES:%.po=%)

all: merge

merge:
	@for po in $(POFILES); do \
	  echo -e "\nMerging $$po..."; \
	  msgmerge -w 79 -C $$po $$po $(TEMPLATE) > "$$po".new; \
	  mv -f "$$po".new $$po; \
	done

check:
	@for po in $(POFILES); do msgfmt -c $$po -o /dev/null; done
