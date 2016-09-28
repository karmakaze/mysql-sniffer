default: build

BIN=mysql-sniffer
BIN_LINUX_x64=mysql-sniffer-linux-x64
STAGE=production

GO_VERSION=$(shell go version | grep -o "go1.[67]")

ifeq "$(GO_VERSION)" ""
  $(error Requires Go 1.6 or 1.7, actual version $(shell go version))
endif

all: build build_x64

deps: vendor

vendor: glide.yaml
	glide install

generate_version:
	script/version

clean:
	rm $(BIN) $(BIN_LINUX_x64) || true

build: deps generate_version
	go build -o $(BIN)

build_linux_x64: deps generate_version
	GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -o $(BIN_LINUX_x64)

test: deps
	go test ./...
