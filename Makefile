DOCKER := docker
IMAGE_NAME := ignition:latest
SERVE_PORT := 8080

.PHONY: clean all fcc push serve

.SUFFIXES:
.SUFFIXES: .ign .fcc

SRCS := $(wildcard *.fcc)
OUTS := $(SRCS:.fcc=.ign)
UUID := $(shell uuidgen)

all: $(OUTS)

# https://quay.io/repository/coreos/fcct
.fcc.ign:
	$(DOCKER) container run -i --rm quay.io/coreos/fcct:release --pretty --strict <$^ >$@

image: all
	$(DOCKER) image build -t $(IMAGE_NAME) .

push: image
	$(DOCKER) image push $(IMAGE_NAME)

serve: image
	$(DOCKER) container run --rm -p $(SERVE_PORT):80 $(IMAGE_NAME)

clean:
	rm -rf $(OUTS) *.ign
	$(DOCKER) image rm -f $(IMAGE_NAME)
