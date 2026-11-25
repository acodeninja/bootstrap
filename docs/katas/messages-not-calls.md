# Shouted

Add a `shouted` behaviour to the string class — which you do not own and whose source you
do not have. Then send `shouted` to a collection of mixed objects and have each one answer
for itself, skipping any that does not understand the message.

## What it teaches

That a call site names a message rather than a function, and the receiver is found when the
message is sent. Smalltalk has it all the way down: a branch is a message to a Boolean, and
a block is an object that answers `value`. Objective-C bolts the same model onto C, so a
selector is a name and `respondsToSelector:` is a question you may ask at run time.

Extending a class you do not own is the half that surprises people — a category in
Objective-C, a class extension in Smalltalk, no subclass and no access to the original.
The last clause of the problem is where you meet what happens when nobody understands.

## Where it sits

Step 3 on `smalltalk` and `objc`. It assumes FizzBuzz.

## Not available in

`ruby` can do all of it and calls it monkey-patching. The statically dispatched rows
cannot: adding a method to a type you do not own is a compile error in `java`, `cpp` and
`go`, and `kotlin`, `swift` and `csharp` allow a near-miss — an extension resolved at
compile time, which is a different thing wearing the same clothes.

## Source

Written for this repo. Documented in
[Objective-C: Categories](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/CustomizingExistingClasses/CustomizingExistingClasses.html)
and in any Smalltalk tutorial under extending a class.
