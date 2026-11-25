// Its own header first, which is a convention with a purpose: if the header is
// not self-contained -- if it needs something it does not include -- then
// including it before anything else is what makes that a compile error here
// rather than in somebody else's file.
//
// Quotes search beside this file; angle brackets search the system paths. That
// is the whole difference.
#include "{{PROJECT_SNAKE}}.h"

#include <stdio.h>

// The definition. It repeats the signature from the header, and the two have to
// agree -- nothing generates one from the other, so a change means editing both.
//
// snprintf rather than sprintf, always: it is handed the size of the buffer and
// will not write past it. sprintf is not, and cannot know, which is why it is
// the most reliable way to introduce a buffer overflow in this language.
//
// There is no return value, so a caller cannot tell a truncated greeting from a
// complete one. snprintf does return the length it wanted, and reporting that
// is what the errors section of the kitchen sink is about.
void greet(const char *name, char *out, size_t size) { snprintf(out, size, "Hello, %s!", name); }
