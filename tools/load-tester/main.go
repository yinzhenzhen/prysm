package main

import (
	"flag"

	"github.com/bojand/ghz/runner"
	log "github.com/sirupsen/logrus"
)

var (
	endpoint = flag.String("grpc-endpoint", "127.0.0.1:5000", "Endpoint of GRPC Server")
)

func main() {
	flag.Parse()

	report, err := runner.Run("test.test", *endpoint, runner.WithInsecure(true))
	if err != nil {
		log.Error(err)
	}
	log.Info(report)

}
