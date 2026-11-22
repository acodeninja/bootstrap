#import "tap.h"

#import "{{PROJECT_SNAKE}}.h"

int main(void) {
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

  TAP_PLAN(1);

  NSString *greeting = [Greeter greet:@"world"];

  TAP_OK([greeting isEqualToString:@"Hello, world!"], "a greeting addresses the name it is given");

  [pool release];
  TAP_DONE();
}
