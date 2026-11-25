// #import rather than #include, which is the one convenience Objective-C adds
// to C here: it includes a file at most once, so there is no include guard to
// write and none below.
#import <Foundation/Foundation.h>

// An @interface declares the class -- its name, what it inherits from, and what
// messages it answers. The implementation is in the .m beside this file, and the
// split is the same deal as C: a caller imports this to learn the interface.
//
// Everything inherits from NSObject, which is where alloc, init, retain and
// release come from. There is no root-less class in practice.
@interface Greeter : NSObject

// The leading + makes this a class method -- sent to Greeter itself, so callers
// write [Greeter greet:@"world"] with nothing to allocate. A leading - would
// make it an instance method, and that one character is the whole distinction.
//
// `greet:` is the selector, and the colon is part of the name: a method taking
// two arguments is called something like greet:withPrefix:, so the argument
// labels and the name are the same thing. The types are in parentheses, and the
// asterisk is there because every object is a pointer.
+ (NSString *)greet:(NSString *)name;

@end
