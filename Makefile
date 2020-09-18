build:
	ghc Main.hs

run:
	./Main

all:
	make build
	make run

deps: 
	cabal update
	cabal install email-validate
