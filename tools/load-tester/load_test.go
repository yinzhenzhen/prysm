package main

import (
	"testing"

	"github.com/bojand/ghz/runner"
	log "github.com/sirupsen/logrus"
)

func TestLoad(t *testing.T) {
	report, err := runner.Run("hello", *endpoint, runner.WithInsecure(true), runner.WithProtoFile("node.proto", []string{}))
	if err != nil {
		log.Error(err)
	}
	log.Info(report)
}
