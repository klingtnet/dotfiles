package main

import (
	"bytes"
	"context"
	"errors"
	"fmt"
	"io"
	"log"
	"os"
	"os/exec"
	"regexp"
	"strings"
	"time"
)

func run(ctx context.Context, revRange string) error {
	stdout := bytes.NewBuffer(nil)
	cmd := exec.CommandContext(ctx, "git", "diff", "--no-prefix", "-U0", revRange)
	cmd.Stdout = stdout
	cmd.Stderr = os.Stderr
	err := cmd.Run()
	if err != nil {
		return err
	}

	lineNoRE := regexp.MustCompile(`^@@\s.*\+(\d+)(,\d+)?\s@@`)
	textRE := regexp.MustCompile(`\+.*(TODO|FIXME)`)
	var file, lineNo string
	for {
		line, err := stdout.ReadString('\n')
		if err != nil {
			if errors.Is(err, io.EOF) {
				return nil
			}
		}
		if strings.HasPrefix(line, "+++") {
			file = strings.TrimSpace(strings.TrimPrefix(line, "+++"))
			continue
		}
		if lineNoRE.MatchString(line) {
			matches := lineNoRE.FindStringSubmatch(line)
			lineNo = matches[1]
		}
		if textRE.MatchString(line) {
			idx := textRE.FindStringSubmatchIndex(line)[2]
			fmt.Println(file, lineNo)
			fmt.Println(strings.TrimSpace(line[idx:]))
		}
	}
}

func main() {
	// TODO: Add some documentation and a help message, preferrably by using urfave/cli.

	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()

	// TODO: reliably detect default branch, note that this is pretty much impossible using plain git.
	revRange := "master.."
	if len(os.Args) > 1 {
		revRange = os.Args[1]
	}
	err := run(ctx, revRange)
	if err != nil {
		log.Fatal(err)
	}
	if ctx.Err() != nil {
		log.Fatal(err)
	}
}
