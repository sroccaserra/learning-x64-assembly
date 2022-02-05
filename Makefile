%: bin/%
	bin/$@

.PRECIOUS: bin/%
bin/%: build/%.o bin
	ld -o $@ $<

.PRECIOUS: build/%.o
build/%.o: src/%.s build
	as -o $@ $<

bin/runexponent: bin build/runexponent.o build/exponentfunc.o
	ld -o bin/runexponent build/runexponent.o build/exponentfunc.o

bin/runexponentc: bin src/runexponent.c src/exponentfunc.s
	gcc -o bin/runexponentc src/runexponent.c src/exponentfunc.s

bin:
	mkdir -p bin

build:
	mkdir -p build

.PHONY: clean
clean:
	rm -rf build bin
