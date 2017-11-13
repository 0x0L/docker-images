REPO_TAG=0x0l

BUILD_FLAGS:=--rm --force-rm
# BUILD_FLAGS:=--rm --force-rm --no-cache

IMAGES = $(patsubst images/%/,%,$(wildcard images/*/))

.PHONY: $(IMAGES)

all:
	@echo 'Available images: $(IMAGES)'

$(IMAGES):
	docker build $(BUILD_FLAGS) -t $(REPO_TAG)/$@ images/$@
