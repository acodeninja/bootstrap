// `export` is what makes this reachable from another file. A name without it is
// private to the module, and there is no other visibility to learn.
//
// The annotations say this takes a string and returns a string, and `tsc`
// checks both -- `make lint` runs it with --noEmit, so a wrong call fails the
// build without anything being compiled. At run time they are gone: Node strips
// the types and runs the JavaScript underneath, so nothing here validates the
// argument when the program actually runs.
//
// The backticks make a template literal and ${...} interpolates any expression
// inside it.
export const greet = (name: string): string => {
  return `Hello, ${name}!`;
};
