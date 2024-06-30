#NAME		:=	$(shell grep -E "^module " ./go.mod | sed -E -e "s/^module //g" -e "s/.*\///g")
DATE		:=	$(shell date)
GIT_STATUS		:=	$(shell git status --short)

all:	commit build commit
#all:	commit go-clean clean go-update test build commit

build:
	go build -ldflags="-s -w" -trimpath -o "./bin/${NAME}" ./src/...
#	go build -ldflags="-s -w" -trimpath -o "./bin/" ./src/...

clean:
	go clean -i -r -x -cache -testcache -modcache -fuzzcache
	find ./ -name ".DS_Store" -delete
	find ./ -name "._.DS_Store" -delete

commit:
ifneq (${GIT_STATUS},)
	git add . && git commit -m "${DATE}" && git push
endif

init:
	go mod init ${NAME}
	go get -u ./...
	go mod tidy

install:
	@echo ${NAME} ${PACKAGE} ${DATE} ${GIT_STATUS}

race:
	go run -race ./src/...

run:
	go run -ldflags="-s -w" -trimpath ./src/...

test:
	go test ./src/...

update:
	go get -u ./...
	go mod tidy

include Makefile.local
