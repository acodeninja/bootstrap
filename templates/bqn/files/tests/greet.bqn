⟨Plan, Ok, TapDone⟩ ← •Import "./tester.bqn"
⟨Greet⟩ ← •Import "../src/{{PROJECT_SNAKE}}.bqn"

Plan 1

"a greeting addresses the name it is given" Ok "Hello, world!" ≡ Greet "world"

TapDone @
