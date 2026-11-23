import {{PROJECT_SNAKE}}
import test

#eval do
  let name := "world"

  let greeting := {{PROJECT_SNAKE}}.greet name

  check "a greeting addresses the name it is given" <| greeting == "Hello, world!"
