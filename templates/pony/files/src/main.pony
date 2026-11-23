actor Main
  new create(env: Env) =>
    env.out.print(Greeter.greet("world"))
