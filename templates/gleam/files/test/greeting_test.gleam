import {{PROJECT_SNAKE}}

pub fn a_greeting_addresses_the_name_it_is_given_test() {
  let name = "world"

  let greeting = {{PROJECT_SNAKE}}.greet(name)

  assert greeting == "Hello, world!"
}
