# Functions for {{PROJECT_NAME}}. A test file reaches these with
# `•Import "../src/{{PROJECT_SNAKE}}.bqn"`, and ⇐ is what makes a name visible
# to the importer -- a file is a namespace, and ← alone keeps a name private.

Greet ⇐ {"Hello, " ∾ 𝕩 ∾ "!"}
