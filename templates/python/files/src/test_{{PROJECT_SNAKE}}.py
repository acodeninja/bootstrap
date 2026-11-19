from {{PROJECT_SNAKE}} import greet


def test_a_greeting_addresses_the_name_it_is_given():
    name = "world"

    greeting = greet(name)

    assert greeting == "Hello, world!"
