SCHEMER=schemer

.PHONY: build run clean all

all: build
build:
	mkdir -p build
	$(SCHEMER) build
run:
	$(SCHEMER) run
clean:
	rm -fr paint paint.exe build/* image.ppm
