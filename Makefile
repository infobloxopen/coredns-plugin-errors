SRCROOT := $(shell dirname $(abspath $(lastword $(MAKEFILE_LIST))))
AT = cd $(SRCROOT)
COVEROUT = $(SRCROOT)/cover.out

GOFMTCHECK = test -z `gofmt -l -s -w *.go | tee /dev/stderr`
GOBUILD = go build -v
GOTEST = go test -v -race -covermode=atomic -coverprofile=$(COVEROUT)

.PHONY: all
all: fmt build test

.PHONY: fmt
fmt:
	@$(AT)/errors && $(GOFMTCHECK)

.PHONY: build
build:
	@$(AT)/errors && $(GOBUILD)

.PHONY: cover-out
cover-out:
	echo > $(COVEROUT)

.PHONY: test
test: cover-out
	$(AT)/errors && $(GOTEST)

.PHONY: clean
clean:
	@$(RM) $(COVEROUT)

.PHONY: vendor
vendor:
	glide cc
	rm -rf vendor
	rm -f glide.lock
	glide install -v --skip-test
