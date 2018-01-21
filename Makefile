include golang.mk
.DEFAULT_GOAL := test # override default goal set in library makefile

SHELL := /bin/bash
ARCH ?= amd64
OS ?= linux
PKG = github.com/Clever/flarebot
PKGS := $(shell go list ./... | grep -v /vendor)
EXECUTABLE := flarebot
.PHONY: test $(PKGS) clean vendor

$(eval $(call golang-version-check,1.9))


all: test build

test: $(PKGS)

build:
	go build -o bin/jira-cli github.com/Clever/flarebot/jira/testcmd
	go build -o bin/slack-cli github.com/Clever/flarebot/slack/testcmd
	GOOS=$(OS) GOARCH=$(ARCH) CGO_ENABLED=0 go build -i -o bin/$(EXECUTABLE) $(PKG)


# for later, when I want to go strict
#$(PKGS): golang-test-all-strict-deps
#	$(call golang-test-all-strict,$@)

$(PKGS): golang-test-all-deps
	$(call golang-test-all,$@)



install_deps: golang-dep-vendor-deps
	$(call golang-dep-vendor)
