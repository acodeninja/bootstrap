#import "{{PROJECT_SNAKE}}.h"

@implementation Greeter

+ (NSString *)greet:(NSString *)name {
  return [NSString stringWithFormat:@"Hello, %@!", name];
}

@end
