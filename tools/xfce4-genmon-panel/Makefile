install: xfce4-genmon-panel
	cp $< ~/.local/bin/$<

xfce4-genmon-panel: xfce4-genmon-panel.go
	go build $<
	strip $@

clean:
	rm -f xfce4-genmon-panel
