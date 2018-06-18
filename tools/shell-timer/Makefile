RUST_SRC=$(wildcard **/*.rs)

all: shell-timer

install: shell-timer
ifeq ($$EUID, 0)
	@install --mode=0755 --verbose shell-timer /usr/local/bin
else
	@install --mode=0755 --verbose shell-timer $$HOME/.local/bin
endif

shell-timer: target/release/shell-timer
	@cp $< $@

target/release/shell-timer: $(RUST_SRC)
	RUSTFLAGS='-C lto=thin' cargo build --release
# remove debug information	
	strip $@
