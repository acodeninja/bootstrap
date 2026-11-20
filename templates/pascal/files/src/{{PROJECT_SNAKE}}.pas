unit {{PROJECT_SNAKE}};

{$mode objfpc}{$H+}

interface

function Greet(const Name: string): string;

implementation

function Greet(const Name: string): string;
begin
  Result := 'Hello, ' + Name + '!';
end;

end.
