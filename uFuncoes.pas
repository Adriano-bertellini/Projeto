unit uFuncoes;

interface

uses   Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Imaging.pngimage, System.ImageList, Vcl.ImgList, Vcl.ComCtrls, Vcl.Buttons,
  Data.DB, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.Grids, Vcl.DBGrids, System.Generics.Collections, uModel;

type
  TFuncao = class
    class function IsCPF(const S: string): Boolean;
    class function FormataCPF(const S: string): string;
    class function SomenteDigitos(const S: string): string;
  end;


implementation

uses uFormMain;

{ TFuncao }

class function TFuncao.FormataCPF(const S: string): string;
var
  CPF: string;
begin
  CPF := SomenteDigitos(S);
  if Length(CPF) = 11 then
    Result := Copy(CPF,1,3) + '.' + Copy(CPF,4,3) + '.' +
              Copy(CPF,7,3) + '-' + Copy(CPF,10,2)
  else
    Result := S;
end;

class function TFuncao.IsCPF(const S: string): Boolean;
var
  CPF: string;
  i, soma, r, d10, d11: Integer;
begin
  CPF := SomenteDigitos(S);

  if Length(CPF) <> 11 then Exit(False);
  if CPF = StringOfChar(CPF[1], 11) then Exit(False);

  soma := 0;
  for i := 1 to 9 do
    soma := soma + (Ord(CPF[i]) - Ord('0')) * (10 - (i - 1));

  r := 11 - (soma mod 11);
  if r >= 10 then d10 := 0 else d10 := r;

  soma := 0;
  for i := 1 to 9 do
    soma := soma + (Ord(CPF[i]) - Ord('0')) * (11 - (i - 1));
  soma := soma + d10 * 2;

  r := 11 - (soma mod 11);
  if r >= 10 then d11 := 0 else d11 := r;

  Result :=
    (d10 = (Ord(CPF[10]) - Ord('0'))) and
    (d11 = (Ord(CPF[11]) - Ord('0')));
end;

class function TFuncao.SomenteDigitos(const S: string): string;
var
  c: Char;
begin
  Result := '';
  for c in S do
    if (c >= '0') and (c <= '9') then
      Result := Result + c;
end;

end.
