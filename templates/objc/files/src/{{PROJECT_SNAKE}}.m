#import "{{PROJECT_SNAKE}}.h"

// @implementation supplies the bodies for what @interface declared. The two have
// to agree on every selector, and the compiler will tell you when they do not.
@implementation Greeter

+ (NSString *)greet:(NSString *)name {
  // Square brackets are a message send, not a method call, and the difference
  // is real: the receiver is looked up when the message is sent rather than
  // when this file is compiled. That is what makes categories and
  // respondsToSelector: possible, and it is why sending a message to nil
  // quietly answers zero instead of crashing.
  //
  // This one reads "send stringWithFormat: to the NSString class", so it is a
  // class method like the one it is inside. @"..." is an NSString literal; the
  // @ is what makes it one rather than a C string, and %@ is the specifier for
  // an object -- %s would be for a char *.
  //
  // Nothing here is reference counted for you: this template has no ARC, so the
  // test manages an autorelease pool by hand. stringWithFormat: returns an
  // autoreleased object, which is why this does not leak and a +alloc would.
  return [NSString stringWithFormat:@"Hello, %@!", name];
}

@end
