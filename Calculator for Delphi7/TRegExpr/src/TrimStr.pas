unit TrimStr;

interface

function TrimRight(const Str: string; Ch: Char): string;
function TrimLeft(const Str: string; Ch: Char): string;

implementation

function TrimRight(const Str: string; Ch: Char): string;
var
  E: integer;
begin
  E:=Length(Str);
  while (E >= 1) and (Str[E]=Ch) do Dec(E);
  SetString(Result, PChar(@Str[1]), E);
end;


function TrimLeft(const Str: string; Ch: Char): string;
var
  E: integer;
begin
  E:=1;
  while (E < Length(Str)) and (Str[E]=Ch) do Inc(E);
  SetString(Result, PChar(@Str[E]), Length(Str)-E+1);
end;


end.
