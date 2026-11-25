// Nothing exports this and nothing has to: every top-level name in a Dart file
// is visible to whoever imports the file, and a leading underscore is what
// makes one private to its library. There is no `public` keyword to look for.
//
// `=>` is shorthand for a body that is a single expression, so there is no
// `return` here. The types are checked when you compile and survive into the
// run, so a wrong argument is a build failure -- `make lint` runs
// `dart analyze --fatal-infos`, which fails on even an informational hint.
//
// '$name' interpolates inside a string literal and '${...}' is the form for a
// whole expression. Single quotes are the convention here and interpolate just
// as double quotes do, unlike Ruby or shell where only one of the two will.
String greet(String name) => 'Hello, $name!';
