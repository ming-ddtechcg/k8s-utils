package main

import (
	"bufio"
	"fmt"
	"os"
	"regexp"
	"strconv"
	"strings"

	"k8s.io/apimachinery/pkg/api/resource"
)

var version = "1.1"
var PRG = os.Args[0]
var integerCheck = regexp.MustCompile(`^[0-9]+$`)
var floatCheck = regexp.MustCompile(`^([0-9]+).[0-9]+$`)

/**
 * help menu
 */
func help() {

	fmt.Println("")
	fmt.Println("Usage:")
	fmt.Println("version:", version)
	fmt.Println("    ", PRG, "[options] ")
	fmt.Println("")
	fmt.Println("options:")
	fmt.Println("--help                  this help menu")
	fmt.Println("--resource-type=cpu     converts the resource with the CPU format to millicpu")
	fmt.Println("--resource-type=memory  converts the resource with the memory format to byte")
	fmt.Println("--resource-type=storage converts the resource with the storage format to byte")
	fmt.Println("")
	fmt.Println("Examples:")
	fmt.Println("  # prints the help menu:")
	fmt.Println(" ", PRG, "--help")
	fmt.Println("")
	fmt.Println("  # converts the CPU resource with 100m:")
	fmt.Println("  echo \"100m\" |", PRG, "--resource-type=cpu")
	fmt.Println("")
	fmt.Println("  # converts the CPU resouce with 0.1 (core):")
	fmt.Println("  echo \"0.1\" |", PRG, "--resource-type=cpu")
	fmt.Println("")
	fmt.Println("  # converts the CPU resource with 2 (cores)")
	fmt.Println("  echo \"2\" |", PRG, "--resource-type=cpu")
	fmt.Println("")
	fmt.Println("  # converts the memory resource with 0.2Gi")
	fmt.Println("  echo \"0.2Gi\" |", PRG, "--resource-type=memory")
	fmt.Println("")
	fmt.Println("  # converts the memory resource with 2Gi")
	fmt.Println("  echo \"2Gi\" |", PRG, "--resource-type=memory")
	fmt.Println("")
}

func main() {
	printHelpAndExit := false

	if len(os.Args) == 1 {
		printHelpAndExit = true
	}

	for _, opt := range os.Args {
		if opt == "--help" {
			printHelpAndExit = true
			break
		}
	}

	if printHelpAndExit {
		help()
		os.Exit(0)
	}

	reader := bufio.NewReader(os.Stdin)
	input, err := reader.ReadString('\n')

	if err != nil {
		os.Exit(1)
	}

	input = strings.TrimSuffix(input, "\n")

	defer func() {
		if err := recover(); err != nil {
			os.Exit(2)
		}
	}()

	if len(os.Args) < 2 {
		// no argument
		quantity := resource.MustParse(input)

		fmt.Println(quantity.Value())
	} else {
		switch os.Args[1] {
		case "--resource-type=cpu":
			if integerCheck.MatchString(input) {
				// if the input is integer or float number, just
				// simple convert to millcpu and out it
				_input, _err := strconv.ParseInt(input, 10, 64)

				if _err != nil {
					os.Exit(3)
				}

				fmt.Println((_input * 1000))
			} else if floatCheck.MatchString(input) {
				// for the floating number
				_input, _err := strconv.ParseFloat(input, 64)

				if _err != nil {
					os.Exit(3)
				}

				fmt.Println((_input * 1000))
			} else {
				length_input := len(input)

				last_char := input[length_input-1:]

				if last_char == "m" {
					fmt.Println(input[:length_input-1])
				}
			}
		case "--resource-type=memory":
			quantity := resource.MustParse(input)

			fmt.Println(quantity.Value())
		case "--resource-type=storage":
			quantity := resource.MustParse(input)

			fmt.Println(quantity.Value())
		default:
			fmt.Fprintln(os.Stderr, "ERROR: invalid the parameter")
			os.Exit(4)
		}
	}

	os.Exit(0)
}
