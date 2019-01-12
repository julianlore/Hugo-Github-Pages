.PHONY: all
all: public/index.xml

CONTENT_SUBDIRS = $(shell find content -mindepth 1 -type d)

# Folders to monitor, re-run Hugo if anything in these folders has changed
SITE_FOLDERS = content themes static layouts data archetypes

public/index.xml: $(foreach dir,$(SITE_FOLDERS),$(shell find $(dir)))
	hugo

define content_template
# Creates new .md post using Hugo if it does not exist, else does nothing
$1/%.md:
	hugo new $$@
endef

# Using an if statement is not needed because of how recipes work
# Leaving this here as an example of using shell if statements in a GNU/Makefile
#$1/%.md:
#	if [ ! -f $$@ ];\
#	then \
#		hugo new $$@; \
# 	fi

# Debugging, this line prints generated recipes
# $(foreach content_dir,$(CONTENT_SUBDIRS),$(info $(call content_template,$(content_dir))))

$(foreach content_dir,$(CONTENT_SUBDIRS),$(eval $(call content_template,$(content_dir))))
