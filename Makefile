build:
	ghc Main.hs

run:
	./Main.hs

all:
	make build
	make run