local greeter = require("{{PROJECT_SNAKE}}")

it("a greeting addresses the name it is given", function()
  local name = "world"

  local greeting = greeter.greet(name)

  assert.equal("Hello, world!", greeting)
end)
