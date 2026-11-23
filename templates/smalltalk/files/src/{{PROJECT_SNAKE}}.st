Object subclass: Greeter [
    <comment: 'The one class this project starts with.'>

    Greeter class >> greet: aName [
        ^ 'Hello, ', aName, '!'
    ]
]
