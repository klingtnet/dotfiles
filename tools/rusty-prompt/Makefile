RUST_SRC=$(wildcard **/*.rs)

all: rusty-prompt

install: rusty-prompt
ifeq ($$EUID, 0)
	@install --mode=0755 --verbose rusty-prompt /usr/local/bin
else
	@install --mode=0755 --verbose rusty-prompt $$HOME/.local/bin
endif

rusty-prompt: target/release/rusty-prompt
	@cp $< $@

target/release/rusty-prompt: $(RUST_SRC)
	cargo build --release
# remove debug information	
	strip $@

clean:
	rm -rf ./rusty-prompt ./target/
