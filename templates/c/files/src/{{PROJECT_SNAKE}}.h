// An include guard. C has no modules and no imports: #include pastes a file in
// textually, so without these three lines a header included twice would declare
// everything twice and fail to compile. #pragma once does the same job in one
// line and is not standard, which is why the long form is still the common one.
//
// The name is GREETER_H rather than the project's, because a macro name cannot
// be built from the project token by literal substitution without risking a
// collision with something else in the translation unit.
#ifndef GREETER_H
#define GREETER_H

// For size_t. A header includes what its own declarations need and nothing
// more -- anything else it pulls in lands on every file that includes it.
#include <stddef.h>

// The declaration, and this is what visibility means in C: a caller includes
// this header to learn the signature, and the linker finds the definition in
// the object file compiled from the .c beside it. `static` on a definition is
// the only way to hide one, and there is nothing else.
//
// Three parameters for what looks like one argument and a result, which is the
// shape to get used to. Nothing here allocates, so the caller supplies the
// buffer and says how big it is -- returning a pointer to a local would be a
// use-after-return, and returning allocated memory would make freeing it the
// reader's job to remember.
//
// `const char *name` promises the function will not write through that pointer.
void greet(const char *name, char *out, size_t size);

#endif
