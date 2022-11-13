package main

import (
	"fmt"
	"os"
	"plugin"

	"github.com/csdaomin/go_plugin_test/go_module"
)

func main() {

	// load module
	// 1. open the so file to load the symbols
	plug, err := plugin.Open("plugin.so")
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}

	// 2. look up a symbol (an exported function or variable)
	// in this case, variable Greeter
	symGreeter, err := plug.Lookup("Greeter")
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}

	// 3. Assert that loaded symbol is of a desired type
	// in this case interface type Greeter (defined above)
	var greeter go_module.Greeter
	greeter, ok := symGreeter.(go_module.Greeter)
	if !ok {
		fmt.Println("unexpected type from module symbol")
		os.Exit(1)
	}

	// 4. use the module
	greeter.Greet()

}
