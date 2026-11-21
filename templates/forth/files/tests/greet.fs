require ./tester.fs
require ../src/{{PROJECT_SNAKE}}.fs

1 plan

T{ s" world" greet s" Hello, world!" compare -> 0 }T a greeting addresses the name it is given

tap-done
