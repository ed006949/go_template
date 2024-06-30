DATE		:=	$(shell date)

all:	commit build commit
#all:	commit clean init update test build commit

build:
	go build -ldflags="-s -w" -trimpath -o "./bin/${NAME}" ./...

clean:
	-gh auth logout
	-go clean -i -r -x -cache -testcache -modcache -fuzzcache
	-rm -v go.mod
	-rm -v go.sum
	-find ./ -name ".DS_Store" -delete
	-find ./ -name "._.DS_Store" -delete

commit:
ifneq ($(shell git status --short),)
	git add . && git commit -m "${DATE}" && git push
endif

init:
	gh auth login --with-token < ~/.git_token
	go mod init ${TARGET}
	go get -u ./...
	go mod tidy

install:
	@echo ${NAME} ${PACKAGE} ${TARGET} ${DATE} $(shell git status --short)

race:
	go run -race ./...

release:
	git add .
	git commit -m "${DATE}"
	git tag v${VERSION}
	git push origin v${VERSION}
	gh release create v${VERSION} --generate-notes --latest=true

run:
	go run -ldflags="-s -w" -trimpath ./...

status:
	git status

test:
	go test ./...

update:
	go get -u ./...
	go mod tidy

include Makefile.local
