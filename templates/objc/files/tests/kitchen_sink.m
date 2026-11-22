/* Fifteen passing assertions: the toolbox for solving a kata in Objective-C. */

#import "tap.h"

#import <Foundation/Foundation.h>

/* A category bolts a method onto a class somebody else wrote, with no subclass
 * and no access to its source. */
@interface NSString (Shouted)
- (NSString *)shouted;
@end

@implementation NSString (Shouted)
- (NSString *)shouted {
  return [[self uppercaseString] stringByAppendingString:@"!"];
}
@end

/* There are no sum types, so a fixed set of states is a C enum and the switch
 * over it is yours to keep exhaustive. */
typedef enum { LevelLow, LevelMiddle, LevelHigh } Level;

static NSString *nameOfLevel(Level value) {
  switch (value) {
  case LevelLow:
    return @"low";
  case LevelMiddle:
    return @"middle";
  case LevelHigh:
    return @"high";
  }
  return @"unknown";
}

@interface Point : NSObject {
  int x;
  int y;
}
- (id)initWithX:(int)anX y:(int)aY;
- (int)x;
- (void)setX:(int)value;
@end

@implementation Point
- (id)initWithX:(int)anX y:(int)aY {
  self = [super init];
  if (self != nil) {
    x = anX;
    y = aY;
  }
  return self;
}

- (int)x {
  return x;
}

- (void)setX:(int)value {
  x = value;
}
@end

@interface Refusal : NSException
@end

@implementation Refusal
@end

@interface Chooser : NSObject
+ (id)itemAt:(NSUInteger)index in:(NSArray *)items;
@end

@implementation Chooser
+ (id)itemAt:(NSUInteger)index in:(NSArray *)items {
  if (index >= [items count]) {
    @throw [Refusal
        exceptionWithName:@"Refusal"
                   reason:[NSString stringWithFormat:@"no item at %lu", (unsigned long)index]
                 userInfo:nil];
  }
  return [items objectAtIndex:index];
}
@end

/* A selector is a message name rather than a function pointer: the receiver is
 * looked up at the moment it is sent, which is what makes this work for any
 * object that answers it. */
static NSArray *sendToEach(SEL message, NSArray *items) {
  NSMutableArray *results = [NSMutableArray array];
  for (id item in items) {
    [results addObject:[item performSelector:message]];
  }
  return results;
}

static int sumOf(NSArray *numbers) {
  int total = 0;
  for (NSNumber *number in numbers) {
    total += [number intValue];
  }
  return total;
}

int main(void) {
  /* Nothing is reference-counted for you. Every alloc below is matched by a
   * release, and the pool drains what Foundation's convenience constructors
   * autoreleased on your behalf. */
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

  TAP_PLAN(15);

  /* collections */

  NSMutableArray *items = [[NSMutableArray alloc] init];
  [items addObject:@"a"];
  [items addObject:@"b"];
  [items addObject:@"c"];

  TAP_OK([items count] == 3 && [[items objectAtIndex:2] isEqualToString:@"c"],
         "a mutable array grows as you add to it and reports its own count");

  NSDictionary *record = [NSDictionary dictionaryWithObjectsAndKeys:@"first", @"one", nil];

  TAP_OK([record objectForKey:@"two"] == nil &&
             [[record objectForKey:@"one"] isEqualToString:@"first"],
         "a dictionary answers nil for a key it does not hold");

  NSSet *unique = [NSSet setWithObjects:@"a", @"b", @"a", nil];

  TAP_OK([unique count] == 2 && [unique containsObject:@"b"],
         "a set collapses duplicates and answers membership directly");

  /* strings */

  NSArray *parts = [@"one two three" componentsSeparatedByString:@" "];

  TAP_OK([parts count] == 3 &&
             [[parts componentsJoinedByString:@"-"] isEqualToString:@"one-two-three"],
         "splitting a string gives the pieces and joining them puts it back");

  NSString *text = @"abcdef";

  TAP_OK([[text substringWithRange:NSMakeRange(1, 3)] isEqualToString:@"bcd"] && [text length] == 6,
         "a substring is cut by range and leaves the original alone");

  NSString *formatted = [NSString stringWithFormat:@"%@ x%d", @"ab", 2];

  TAP_OK([formatted isEqualToString:@"ab x2"],
         "a format string builds a new string, and the object placeholder takes anything");

  /* types and branching */

  id anything = @"abc";

  TAP_OK([anything respondsToSelector:@selector(shouted)] &&
             ![anything respondsToSelector:@selector(addObject:)] &&
             [[anything shouted] isEqualToString:@"ABC!"],
         "a variable typed id accepts any message, and the object says which ones it answers");

  TAP_OK([nameOfLevel(LevelMiddle) isEqualToString:@"middle"] && LevelHigh == 2,
         "an enumeration is named integers counting from zero, and a switch over one yields a "
         "value");

  Point *origin = [[Point alloc] initWithX:1 y:2];
  Point *alias = origin;
  [alias setX:5];

  TAP_OK([origin x] == 5 && origin == alias,
         "an object is a record held by reference, so an alias sees every change");

  /* iteration */

  NSMutableString *seen = [NSMutableString string];
  NSUInteger position = 0;
  for (NSString *item in items) {
    [seen appendFormat:@"%lu:%@", (unsigned long)position, item];
    position++;
  }

  TAP_OK([seen isEqualToString:@"0:a1:b2:c"],
         "fast enumeration hands over the element and not the index, so you count it yourself");

  NSArray *numbers =
      [NSArray arrayWithObjects:[NSNumber numberWithInt:1], [NSNumber numberWithInt:3],
                                [NSNumber numberWithInt:4], [NSNumber numberWithInt:8], nil];
  int widest = 0;
  for (NSUInteger index = 0; index + 1 < [numbers count]; index++) {
    int gap =
        [[numbers objectAtIndex:index + 1] intValue] - [[numbers objectAtIndex:index] intValue];
    if (gap > widest) {
      widest = gap;
    }
  }

  TAP_OK(widest == 4, "lookahead means indexing both neighbours and stopping one short");

  /* functions */

  TAP_OK([[sendToEach(@selector(shouted), parts) componentsJoinedByString:@" "]
             isEqualToString:@"ONE! TWO! THREE!"],
         "a selector is a message name a function can be handed and send later");

  TAP_OK(sumOf(numbers) == 16, "folding a sequence means one accumulator and one loop");

  /* errors */

  NSString *refused = nil;
  id accepted = nil;
  @try {
    accepted = [Chooser itemAt:0 in:parts];
    [Chooser itemAt:9 in:parts];
  } @catch (Refusal *refusal) {
    refused = [refusal reason];
  }

  TAP_OK([refused isEqualToString:@"no item at 9"] && [accepted isEqualToString:@"one"],
         "@throw of an NSException subclass is caught by a @catch naming that class");

  /* gotchas */

  NSString *absent = nil;

  TAP_OK([absent length] == 0 && [absent uppercaseString] == nil &&
             [absent isEqualToString:@"abc"] == NO,
         "a message to nil answers zero rather than stopping the program");

  [origin release];
  [items release];
  [pool release];
  TAP_DONE();
}
