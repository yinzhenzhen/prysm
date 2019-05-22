package main

// #cgo LDFLAGS: -ldl
import "C"

func crosscall()

func main() {
	println("Hello, Go!")
	crosscall()
}
