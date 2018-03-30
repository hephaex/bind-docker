all: build

build:
	@docker build --tag=hephaex/bind .
