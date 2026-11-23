TestCase subclass: GreeterTest [

    testAGreetingAddressesTheNameItIsGiven [
        | name greeting |
        name := 'world'.

        greeting := Greeter greet: name.

        self assert: greeting = 'Hello, world!'
    ]
]
