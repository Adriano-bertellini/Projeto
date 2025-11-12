program Projeto;

uses
  Vcl.Forms,
  uFormMain in 'uFormMain.pas' {Form1},
  uFuncoes in 'uFuncoes.pas',
  uModel in 'uModel.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.
