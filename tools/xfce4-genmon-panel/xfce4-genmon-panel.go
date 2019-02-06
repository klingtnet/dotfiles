package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"net/http"
	"os"
	"os/user"
	"sync"
	"syscall"
	"text/template"
	"time"

	"github.com/distatus/battery"
	"github.com/vishvananda/netlink"
)

type ipInfo struct {
	IP string `json:"ip"`
}

// Info contains all data that is shown in the panel and its tooltip.
type Info struct {
	mtx       sync.Mutex
	Date      string
	Username  string
	Hostname  string
	Uptime    string
	PublicIP  string
	Batteries []string
	NICs      map[string]string
}

const panelTemplate string = `<txt><span fgcolor='YellowGreen' font-style='italic'>{{ .Username }}</span>@<span fgcolor='Yellow'>{{ .Hostname }}</span> ⏰ {{ .Uptime }} {{ range .Batteries }}{{ . }}{{ end }} 🖧 {{ range $name, $ip := .NICs }}<span fgcolor='Turquoise'>{{ $name }}</span>[{{ $ip }}] {{ end }}🌐 {{ .PublicIP }} 📆 <span fgcolor='LightGreen'>{{ .Date }}</span></txt>`
const tooltipTemplate string = `<tool><span fgcolor='YellowGreen' font-style='italic'>{{ .Username }}</span>@<span fgcolor='Yellow'>{{ .Hostname }}</span> ⏰ {{ .Uptime }} {{ range .Batteries }}{{ . }}{{ end }} 🖧 {{ range $name, $ip := .NICs }}<span fgcolor='Turquoise'>{{ $name }}</span>[{{ $ip }}] {{ end }}🌐 {{ .PublicIP }} 📆 <span fgcolor='LightGreen'>{{ .Date }}</span></tool>`

func (i *Info) panel() string {
	buf := bytes.Buffer{}
	t := template.Must(template.New("panel").Parse(panelTemplate))
	if err := t.Execute(&buf, i); err != nil {
		return ""
	}
	return buf.String()
}

func (i *Info) tooltip() string {
	buf := bytes.Buffer{}
	t := template.Must(template.New("tooltip").Parse(tooltipTemplate))
	if err := t.Execute(&buf, i); err != nil {
		return ""
	}
	return buf.String()
}

func publicIP(wg *sync.WaitGroup, info *Info) {
	defer wg.Done()

	cl := http.Client{
		Timeout: 1 * time.Second,
	}
	resp, err := cl.Get("https://ipinfo.io")
	if err != nil {
		info.mtx.Lock()
		info.PublicIP = "offline"
		info.mtx.Unlock()
		return
	}
	msg := ipInfo{}
	err = json.NewDecoder(resp.Body).Decode(&msg)
	if err != nil {
		return
	}
	info.mtx.Lock()
	info.PublicIP = msg.IP
	info.mtx.Unlock()
}

func whoami(wg *sync.WaitGroup, info *Info) {
	u, err := user.Current()

	info.mtx.Lock()
	if err != nil {
		info.Username = "unknown"
	} else {
		info.Username = u.Username
	}
	info.mtx.Unlock()
	wg.Done()
}

func hostname(wg *sync.WaitGroup, info *Info) {
	host, err := os.Hostname()

	info.mtx.Lock()
	if err != nil {
		info.Hostname = "unknown"
	} else {
		info.Hostname = host
	}
	info.mtx.Unlock()
	wg.Done()
}

func uptime(wg *sync.WaitGroup, info *Info) {
	inf := syscall.Sysinfo_t{}
	err := syscall.Sysinfo(&inf)

	info.mtx.Lock()
	if err != nil {
		info.Uptime = "indefinite"
	} else {
		info.Uptime = (time.Duration(inf.Uptime) * time.Second).String()
	}
	info.mtx.Unlock()
	wg.Done()
}

func batPercent(bat *battery.Battery) float64 {
	return (bat.Current / bat.Full) * 100.0
}

func batteryState(wg *sync.WaitGroup, info *Info) {
	defer wg.Done()
	bats, err := battery.GetAll()
	if err != nil {
		return
	}
	if len(bats) == 0 {
		info.mtx.Lock()
		info.Batteries = []string{"⚡ AC"}
		info.mtx.Unlock()
		return
	}
	s := []string{}
	for _, bat := range bats {
		switch bat.State {
		case battery.Unknown:
			s = append(s, fmt.Sprintf("⚡ <span fgcolor='Green'>%3.2f%%</span>", batPercent(bat)))
		case battery.Charging:
			s = append(s, fmt.Sprintf("⬆️ <span fgcolor='Green'>%3.2f%%</span>", batPercent(bat)))
		case battery.Discharging:
			s = append(s, fmt.Sprintf("⬇️ <span fgcolor='Orange'>%3.2f%%</span>", batPercent(bat)))
		case battery.Full:
			s = append(s, "<span fgcolor='Green'>100%</span>")
		case battery.Empty:
			s = append(s, "<span fgcolor='Red'>0%</span>")
		}
	}
	info.mtx.Lock()
	info.Batteries = s
	info.mtx.Unlock()
}

func ifaces(wg *sync.WaitGroup, info *Info) {
	defer wg.Done()

	addrs, err := netlink.AddrList(nil, 0)
	if err != nil {
		return
	}
	m := map[string]string{}
	for _, addr := range addrs {
		if addr.Label == "" || addr.Scope != int(netlink.SCOPE_LINK) && addr.Scope != int(netlink.SCOPE_UNIVERSE) {
			continue
		}
		m[addr.Label] = addr.IP.String()
	}

	info.mtx.Lock()
	if len(m) == 0 {
		info.NICs = map[string]string{"net": "disconnected"}
	} else {
		info.NICs = m
	}
	info.mtx.Unlock()
}

func main() {
	wg := sync.WaitGroup{}
	wg.Add(6)
	info := &Info{
		Date: time.Now().Format(time.RFC3339),
	}
	go whoami(&wg, info)
	go hostname(&wg, info)
	go uptime(&wg, info)
	go batteryState(&wg, info)
	go ifaces(&wg, info)
	go publicIP(&wg, info)
	wg.Wait()
	fmt.Println(info.panel())
	fmt.Println(info.tooltip())
}
