{ Fifteen passing assertions: the toolbox for solving a kata in Pascal. }

unit kitchen_sink;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testregistry;

type
  TKitchenSinkTest = class(TTestCase)
  published
    { collections }
    procedure ADynamicArrayKeepsWhatYouPutInItInOrder;
    procedure ALookupForAKeyThatIsNotThereComesBackEmpty;
    procedure ASetDiscardsDuplicates;

    { strings }
    procedure AStringIsSplitByFindingTheSeparatorYourself;
    procedure CopyTakesAStartAndACountRatherThanTwoPositions;
    procedure TextIsBuiltUpByConcatenationRepetitionAndFormat;

    { types and branching }
    procedure AssigningARecordCopiesItsValueButAClassIsShared;
    procedure AnEnumeratedTypeKnowsItsOwnRange;
    procedure ABranchThatYieldsAValueHasToAssignIt;

    { iteration }
    procedure ALoopCanReadBothThePositionAndTheItem;
    procedure ASequenceCanBeWalkedTwoItemsAtATime;

    { functions }
    procedure AFunctionCanBeHandedToAnotherFunction;
    procedure AnArrayIsFoldedByALoopBecauseThereIsNoFold;

    { errors }
    procedure AnInvalidInputIsRefusedByRaising;

    { gotchas }
    procedure AStringCountsFromOneButADynamicArrayCountsFromZero;
  end;

implementation

uses
  Classes, SysUtils, StrUtils;

type
  TState = (Locked, Unlocked);

  TLetter = (LetterA, LetterB, LetterC);
  TLetters = set of TLetter;

  TPoint = record
    X: Integer;
    Y: Integer;
  end;

  TCounter = class
    Total: Integer;
  end;

  TMapper = function(Value: Integer): Integer;

  TIntegers = array of Integer;

function Doubled(Value: Integer): Integer;
begin
  Result := Value * 2;
end;

function Apply(Transform: TMapper; const Values: array of Integer): TIntegers;
var
  At: Integer;
begin
  Result := nil;
  SetLength(Result, Length(Values));
  for At := 0 to High(Values) do
    Result[At] := Transform(Values[At]);
end;

{ collections }

procedure TKitchenSinkTest.ADynamicArrayKeepsWhatYouPutInItInOrder;
var
  Items: TStringArray;
begin
  Items := ['a', 'b'];
  Insert('c', Items, Length(Items));

  AssertEquals(3, Length(Items));
  AssertEquals('b', Items[1]);
  AssertEquals('c', Items[High(Items)]);
end;

{ There is no dictionary in the language itself. TStringList carries name=value
  pairs, and a key it does not hold answers with an empty string rather than nil,
  so a missing key and a key set to nothing are the same answer. }
procedure TKitchenSinkTest.ALookupForAKeyThatIsNotThereComesBackEmpty;
var
  Counts: TStringList;
begin
  Counts := TStringList.Create;
  try
    Counts.Values['a'] := '2';

    AssertEquals('2', Counts.Values['a']);
    AssertEquals('', Counts.Values['z']);
    AssertEquals(-1, Counts.IndexOfName('z'));
  finally
    Counts.Free;
  end;
end;

{ Pascal has a real set type, built into the language rather than a library, and
  it is strict enough that writing a duplicate into a set constructor is a
  compile error. Adding one that is already a member is not: union absorbs it. }
procedure TKitchenSinkTest.ASetDiscardsDuplicates;
var
  Letters: TLetters;
begin
  Letters := [LetterA, LetterB];
  Letters := Letters + [LetterA];

  AssertTrue(LetterA in Letters);
  AssertFalse(LetterC in Letters);
  AssertTrue(Letters = [LetterA, LetterB]);
end;

{ strings }

procedure TKitchenSinkTest.AStringIsSplitByFindingTheSeparatorYourself;
const
  Text = 'one two three';
var
  At: Integer;
begin
  At := Pos(' ', Text);

  AssertEquals(4, At);
  AssertEquals('one', Copy(Text, 1, At - 1));
  AssertEquals('two three', Copy(Text, At + 1, Length(Text)));
end;

procedure TKitchenSinkTest.CopyTakesAStartAndACountRatherThanTwoPositions;
const
  Text = 'abcdef';
begin
  AssertEquals('a', Copy(Text, 1, 1));
  AssertEquals('abc', Copy(Text, 1, 3));
  AssertEquals('ef', Copy(Text, Length(Text) - 1, 2));
end;

procedure TKitchenSinkTest.TextIsBuiltUpByConcatenationRepetitionAndFormat;
begin
  AssertEquals('one-two', 'one' + '-' + 'two');
  AssertEquals('ababab', DupeString('ab', 3));
  AssertEquals('world x2', Format('%s x%d', ['world', 2]));
  AssertEquals('padded', Trim('  padded  '));
end;

{ types and branching }

{ A record is a value and a class is a reference, which is the single most
  useful distinction in the language: the same assignment copies one and aliases
  the other. }
procedure TKitchenSinkTest.AssigningARecordCopiesItsValueButAClassIsShared;
var
  Origin, Moved: TPoint;
  First, Second: TCounter;
begin
  Origin.X := 1;
  Origin.Y := 2;
  Moved := Origin;
  Moved.X := 5;

  AssertEquals(5, Moved.X);
  AssertEquals(1, Origin.X);

  First := TCounter.Create;
  try
    First.Total := 1;
    Second := First;
    Second.Total := 5;

    AssertEquals(5, First.Total);
  finally
    First.Free;
  end;
end;

procedure TKitchenSinkTest.AnEnumeratedTypeKnowsItsOwnRange;
begin
  AssertEquals(0, Ord(Locked));
  AssertEquals(1, Ord(Unlocked));
  AssertTrue(High(TState) = Unlocked);
end;

{ case is a statement and not an expression, so every branch assigns to the same
  variable rather than the construct producing a value. }
procedure TKitchenSinkTest.ABranchThatYieldsAValueHasToAssignIt;
var
  Outcome: string;
  State: TState;
begin
  State := Unlocked;
  case State of
    Locked: Outcome := 'locked';
    Unlocked: Outcome := 'unlocked';
  end;

  AssertEquals('unlocked', Outcome);

  State := Locked;
  case State of
    Unlocked: Outcome := 'unlocked';
  else
    Outcome := 'anything else';
  end;

  AssertEquals('anything else', Outcome);
end;

{ iteration }

procedure TKitchenSinkTest.ALoopCanReadBothThePositionAndTheItem;
const
  Values: array[0..3] of Integer = (1, 2, 3, 4);
var
  At, Weighted: Integer;
begin
  Weighted := 0;
  for At := Low(Values) to High(Values) do
    Weighted := Weighted + (At + 1) * Values[At];

  AssertEquals(30, Weighted);
  AssertEquals(0, Low(Values));
end;

procedure TKitchenSinkTest.ASequenceCanBeWalkedTwoItemsAtATime;
const
  Values: array[0..3] of Integer = (1, 2, 4, 8);
var
  At, Widest: Integer;
begin
  Widest := 0;
  for At := Low(Values) to High(Values) - 1 do
    if Values[At + 1] - Values[At] > Widest then
      Widest := Values[At + 1] - Values[At];

  AssertEquals(4, Widest);
end;

{ functions }

procedure TKitchenSinkTest.AFunctionCanBeHandedToAnotherFunction;
var
  Mapped: TIntegers;
begin
  Mapped := Apply(@Doubled, [1, 2, 3]);

  AssertEquals(2, Mapped[0]);
  AssertEquals(6, Mapped[2]);
  AssertEquals(3, Length(Mapped));
end;

{ The standard library has no fold, so the loop is the fold. }
procedure TKitchenSinkTest.AnArrayIsFoldedByALoopBecauseThereIsNoFold;
const
  Values: array[0..3] of Integer = (1, 2, 3, 4);
var
  At, Total: Integer;
begin
  Total := 0;
  for At := Low(Values) to High(Values) do
    Total := Total + Values[At];

  AssertEquals(10, Total);
end;

{ errors }

{ Failure is an exception, and the one a conversion raises is the one a kata
  meets first. `on E: ... do` catches by class, and Fail is how a test says the
  call should not have returned. }
procedure TKitchenSinkTest.AnInvalidInputIsRefusedByRaising;
begin
  AssertEquals(42, StrToInt('42'));

  try
    StrToInt('not a number');
    Fail('StrToInt accepted something that is not a number');
  except
    on E: EConvertError do
      AssertTrue(Pos('not a number', E.Message) > 0);
  end;
end;

{ gotchas }

{ The hour this saves: a string is indexed from one and a dynamic array from
  zero, in the same language and often in the same procedure. }
procedure TKitchenSinkTest.AStringCountsFromOneButADynamicArrayCountsFromZero;
var
  Text: string;
  Items: TStringArray;
begin
  Text := 'abc';
  Items := ['a', 'b', 'c'];

  AssertEquals('a', Text[1]);
  AssertEquals('a', Items[0]);
  AssertEquals(1, Low(Text));
  AssertEquals(0, Low(Items));
end;

initialization
  RegisterTest(TKitchenSinkTest);

end.
