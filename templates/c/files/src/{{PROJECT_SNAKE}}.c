#include "{{PROJECT_SNAKE}}.h"

#include <stdio.h>

void greet(const char *name, char *out, size_t size) { snprintf(out, size, "Hello, %s!", name); }
