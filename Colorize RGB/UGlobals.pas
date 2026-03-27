unit UGlobals;

interface

function StartUpDir : string;
function StrString ( d : double; MaxLength,DecDigits : integer ) : string;
function StrStringZero ( d : double; MaxLength,DecDigits : integer ) : string;

implementation

uses
    SysUtils;

function StartUpDir : string;
begin
    Result := IncludeTrailingBackslash(ExtractFilePath(ParamStr(0)));
end;

function StrString ( d : double; MaxLength,DecDigits : integer ) : string;
var
    s : string;

begin
    Str (d:MaxLength:DecDigits, s);
    Result := s;
end;

function StrStringZero ( d : double; MaxLength,DecDigits : integer ) : string;
var
    s : string;

begin
    Str (d:MaxLength:DecDigits, s);
    while Pos (#32,s) <> 0 do
        s[Pos(#32,s)] := '0';
    Result := s;
end;

end.
