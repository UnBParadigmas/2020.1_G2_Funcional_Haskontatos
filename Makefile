build:
	cabal configure
	cabal build

run:
	cabal run

all:
	make build
	make run
