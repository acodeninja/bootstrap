// The one translation unit that defines doctest's main. Every other file in
// here only registers test cases into it, so none of them may define it again.
#define DOCTEST_CONFIG_IMPLEMENT_WITH_MAIN
#include "doctest.h"
