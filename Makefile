build:
	ghc Main.hs

run:
	./Main

all:
	make build
	make run