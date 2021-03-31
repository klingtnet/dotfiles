package main

import (
	"bytes"
	"context"
	"errors"
	"fmt"
	"io"
	"os"
	"os/exec"
	"regexp"
	"strings"
	"time"

	"github.com/urfave/cli/v2"
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

const DefaultRevisionRange = "master.."

var Version = "dev"

func main() {
	// TODO: Add some documentation and a help message, preferrably by using urfave/cli.
	app := &cli.App{
		Name:        "git todo",
		Version:     Version,
		Description: "shows TODO/FIXME messages that were added in the current branch",
		ArgsUsage:   "<revision-range>",
		CustomAppHelpTemplate: `Usage: {{ .Name }} [<revision-range>]

Examples

	Using revision range (` + DefaultRevisionRange + `): {{ .Name }}
	Custom range: {{ .Name }} develop..v1.2.3

See 'man 7 gitrevisions' for details about the range format.
`,
		Action: func(c *cli.Context) error {
			ctx, cancel := context.WithTimeout(c.Context, 10*time.Second)
			defer cancel()

			// TODO: reliably detect default branch, note that this is pretty much impossible using plain git.
			revRange := DefaultRevisionRange
			if c.Args().First() != "" {
				revRange = c.Args().First()
			}
			err := run(ctx, revRange)
			if err != nil {
				return cli.Exit(err.Error(), 1)
			}
			return ctx.Err()
		},
	}
	app.Run(os.Args)
}
