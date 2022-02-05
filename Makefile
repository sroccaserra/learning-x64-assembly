%: bin/%
	bin/$@

.PRECIOUS: bin/%
bin/%: build/%.o bin
	ld -o $@ $<

.PRECIOUS: build/%.o
build/%.o: src/%.s build
	as -o $@ $<

bin:
	mkdir -p bin

build:
	mkdir -p build
