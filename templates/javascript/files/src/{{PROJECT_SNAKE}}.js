// `export` is what makes this reachable from another file. A name without it is
// private to the module, and there is no other visibility to learn: a module is
// the unit, and what it exports is its interface.
//
// An arrow function whose body is an expression returns that expression, so
// there is no `return` here. The backticks make a template literal and ${...}
// interpolates any expression inside it -- with plain quotes this would return
// the literal characters, which no test of the length would notice.
export const greet = (name) => `Hello, ${name}!`;
