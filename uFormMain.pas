unit uFormMain;

interface

uses
   Winapi.Windows,
   Winapi.Messages,
   System.SysUtils,
   System.Variants,
   System.Classes,
   Vcl.Graphics,
   Vcl.Controls,
   Vcl.Forms,
   Vcl.Dialogs,
   Vcl.StdCtrls,
   Vcl.ExtCtrls,
   Vcl.Imaging.pngimage,
   System.ImageList,
   Vcl.ImgList,
   Vcl.ComCtrls,
   Vcl.Buttons,
   Data.DB,
   FireDAC.Stan.Intf,
   FireDAC.Stan.Option,
   FireDAC.Stan.Param,
   FireDAC.Stan.Error,
   FireDAC.DatS,
   FireDAC.Phys.Intf,
   FireDAC.DApt.Intf,
   FireDAC.Comp.DataSet,
   FireDAC.Comp.Client,
   Vcl.Grids,
   Vcl.DBGrids,
   System.Generics.Collections,
   uModel,
   System.Math;

type
   TFormMain = class(TForm)
      Panel1: TPanel;
      Panel2: TPanel;
      Label1: TLabel;
      PageControl1: TPageControl;
      tabCadastro: TTabSheet;
      Panel5: TPanel;
      gpbPessoa: TGroupBox;
      Label21: TLabel;
      Label22: TLabel;
      Label23: TLabel;
      Label24: TLabel;
      Label25: TLabel;
      edtNomeCompleto: TEdit;
      edtTelefone: TEdit;
      edtEmail: TEdit;
      dateDataNascimento: TDateTimePicker;
      edtCPF: TEdit;
      gpbEndereco: TGroupBox;
      Label26: TLabel;
      Label27: TLabel;
      Label28: TLabel;
      Label29: TLabel;
      Label30: TLabel;
      edtPropriedade: TEdit;
      edtBairro: TEdit;
      edtLogradouro: TEdit;
      edtCidade: TEdit;
      cmbUF: TComboBox;
      TabSheet2: TTabSheet;
      DBGrid1: TDBGrid;
      MemPrinc: TFDMemTable;
      DSPrinc: TDataSource;
      MemPrincNome: TStringField;
      MemPrincCPF: TStringField;
      MemPrincEmail: TStringField;
      Panel3: TPanel;
      btnEditar: TSpeedButton;
      btnDeletar: TSpeedButton;
      btnInserir: TSpeedButton;
      btnSalvar: TSpeedButton;
      MemPrincID: TIntegerField;
      Panel4: TPanel;
      Label19: TLabel;
      lblStatus: TLabel;
      edtID: TEdit;
      Label2: TLabel;
    Label3: TLabel;
    edtNumero: TEdit;
    SaveDialog1: TSaveDialog;
    Button1: TButton;
    OpenDialog1: TOpenDialog;
    memArquivos: TMemo;
      procedure FormClose(Sender: TObject; var Action: TCloseAction);
      procedure FormShow(Sender: TObject);
      procedure FormCreate(Sender: TObject);
      procedure btnInserirClick(Sender: TObject);
      procedure btnSalvarClick(Sender: TObject);
      procedure btnDeletarClick(Sender: TObject);
      procedure PageControl1Change(Sender: TObject);
      procedure btnEditarClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
   private
      { Private declarations }
      FGuardarCadastro: TObjectList<TPessoa>;
      procedure CarregarGrid;
      function ObterPessoa(ID: Integer): TPessoa;
      procedure GerarStatus(Sender: TObject);
      procedure CondicaoTravas();
      procedure LimparCampos();
      procedure gerarArquivoTxt();
   public

      { Public declarations }

   end;

var
   FormMain: TFormMain;

implementation

uses uFuncoes;

{$R *.dfm}

procedure TFormMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if FGuardarCadastro.Count > 0 then
    gerarArquivoTxt;

   Action := caFree;
   FormMain := nil;
   FGuardarCadastro.Free;
end;

procedure TFormMain.FormCreate(Sender: TObject);
begin
   FGuardarCadastro := TObjectList<TPessoa>.Create(True);

   MemPrinc.Close;
   MemPrinc.Open;

   GerarStatus(nil);
end;

procedure TFormMain.FormShow(Sender: TObject);
begin
   PageControl1.ActivePageIndex := 0;
end;

procedure TFormMain.gerarArquivoTxt;
var
   Pessoa: TPessoa;
   Diretorio: String;
   Lista: TStringList;
begin
  try
    Lista := TStringList.Create;
    for Pessoa in FGuardarCadastro do
    begin
      Lista.Add ( Pessoa.ID.ToString + ';' +
                            Pessoa.NomeCompleto + ';'+
                            Pessoa.CPF + ';' +
                            DateToStr(Pessoa.DataNascimento) + ';' +
                            Pessoa.Email + ';' +
                            Pessoa.Telefone + ';' +
                            Pessoa.Endereco.Numero.ToString + ';' +
                            Pessoa.Endereco.Cidade + ';' +
                            Pessoa.Endereco.UF + ';' +
                            Pessoa.Endereco.Bairro + ';' +
                            Pessoa.Endereco.Logradouro + ';' +
                            Pessoa.Endereco.Propriedade + ';'

            );
    end;

    Diretorio := 'C:\ArquivosLogTxt\';

    if not DirectoryExists(Diretorio) then
      CreateDir(Diretorio);

    SaveDialog1.FileName := Diretorio + 'memTxtArquivo' +  FormatDateTime('yyyy-mm-dd_hh-nn-ss', Now) + '.txt';

    Lista.SaveToFile(SaveDialog1.FileName);

    ShowMessage('Arquivo criado: ' + SaveDialog1.FileName);
  finally
    Lista.Free;
  end;
end;

procedure TFormMain.GerarStatus(Sender: TObject);
begin
  if Sender = FormMain.btnSalvar  then
  begin
    with FormMain.lblStatus do
    begin
      Font.Color := clBlue;
      Caption    := 'Em modo de salvamento!';
    end;
    FormMain.gpbPessoa.Enabled   := False;
    FormMain.gpbEndereco.Enabled := False;
    FormMain.btnSalvar.Enabled   := False;
    FormMain.btnDeletar.Enabled  := False;
    FormMain.btnEditar.Enabled   := False;
    FormMain.btnInserir.Enabled  := False;
  end
  else if Sender = FormMain.btnDeletar  then
  begin
    with FormMain.lblStatus do
    begin
      Font.Color := clRed;
      Caption    := 'Em modo de exclusão!';
    end;
    FormMain.gpbPessoa.Enabled   := False;
    FormMain.gpbEndereco.Enabled := False;
    FormMain.btnSalvar.Enabled   := False;
    FormMain.btnDeletar.Enabled  := False;
    FormMain.btnEditar.Enabled   := False;
    FormMain.btnInserir.Enabled  := False;
  end
  else if Sender = FormMain.btnInserir  then
  begin
    with FormMain.lblStatus do
    begin
      Font.Color                 := clGreen;
      Caption                    := 'Em modo de inserção!';
    end;
    FormMain.gpbPessoa.Enabled := True;
    FormMain.gpbEndereco.Enabled := True;
    FormMain.btnSalvar.Enabled   := True;
    FormMain.btnDeletar.Enabled  := False;
    FormMain.btnEditar.Enabled   := False;
    FormMain.btnInserir.Enabled  := False;
  end
  else if Sender = FormMain.btnEditar then
  begin
    with FormMain.lblStatus do
    begin
      Font.Color  := clGreen;
      Caption     := 'Em modo de edição!';
    end;
    FormMain.gpbPessoa.Enabled   := True;
    FormMain.gpbEndereco.Enabled := True;
    FormMain.btnSalvar.Enabled   := True;
    FormMain.btnDeletar.Enabled  := False;
    FormMain.btnEditar.Enabled   := False;
    FormMain.btnInserir.Enabled  := False;
  end
  else
  begin
    with FormMain.lblStatus do
    begin
      Font.Color  := clOlive;
      Caption     := 'Em nenhum modo!';
    end;
    FormMain.gpbPessoa.Enabled   := False;
    FormMain.gpbEndereco.Enabled := False;
    FormMain.btnSalvar.Enabled   := False;
    FormMain.btnDeletar.Enabled  := True;
    FormMain.btnEditar.Enabled   := True;
    FormMain.btnInserir.Enabled  := True;
  end;
end;

procedure TFormMain.LimparCampos;
begin
  edtID.Clear;
  edtNomeCompleto.Text := '';
  edtEmail.Text := '';
  edtCPF.Text := '';
  edtTelefone.Text := '';
  dateDataNascimento.Date := 0;
  cmbUF.Text := '';
  edtCidade.Text := '';
  edtBairro.Text := '';
  edtLogradouro.Text := '';
  edtPropriedade.Text := '';
  cmbUF.ItemIndex := 1;
  edtNumero.Text := '';
end;

procedure TFormMain.PageControl1Change(Sender: TObject);
var
   Pessoa: TPessoa;
   I: Integer;
begin
   try
      GerarStatus(nil);
      if not MemPrinc.IsEmpty then
      begin
         Pessoa := ObterPessoa(MemPrincID.AsInteger);
         if Assigned(Pessoa) then
         begin
            edtID.Text := Pessoa.ID.ToString;
            edtNomeCompleto.Text := Pessoa.NomeCompleto;
            edtEmail.Text := Pessoa.Email;
            edtCPF.Text := Pessoa.CPF;
            edtTelefone.Text := Pessoa.Telefone;
            dateDataNascimento.Date := Pessoa.DataNascimento;
            for I := 0 to cmbUF.Items.Count - 1 do
              if cmbUF.Items[i] = Pessoa.Endereco.UF then
                cmbUF.ItemIndex := I;
            edtCidade.Text := Pessoa.Endereco.Cidade;
            edtBairro.Text := Pessoa.Endereco.Bairro;
            edtLogradouro.Text := Pessoa.Endereco.Logradouro;
            edtPropriedade.Text := Pessoa.Endereco.Propriedade;
            edtNumero.Text  := Pessoa.Endereco.Numero.ToString;
            exit;
         end;
      end;
      edtID.Clear;
      edtNomeCompleto.Text := '';
      edtEmail.Text := '';
      edtCPF.Text := '';
      edtTelefone.Text := '';
      dateDataNascimento.Date := 0;
      cmbUF.Text := '';
      edtCidade.Text := '';
      edtBairro.Text := '';
      edtLogradouro.Text := '';
      edtPropriedade.Text := '';
      edtNomeCompleto.Text := '';
      cmbUF.ItemIndex := -1;
   except
      on E: Exception do
         ShowMessage(E.Message);
   end;
end;

procedure TFormMain.btnDeletarClick(Sender: TObject);
var
   I: Integer;
begin
   GerarStatus(Sender);

   if MessageDlg('Tem certeza que deseja EXCLUIR esse registro?',
      mtConfirmation, [mbYes, mbNo], 0) = mrNo then
   begin
      GerarStatus(nil);
      exit;
   end;

   try
      for I := 0 to MemPrinc.RecordCount - 1 do
      begin
         if FGuardarCadastro[I].ID = MemPrincID.AsInteger then
         begin
            FGuardarCadastro.Delete(I);
            Break;
         end;
      end;
   finally
      GerarStatus(nil);
   end;

   CarregarGrid;
end;

procedure TFormMain.btnEditarClick(Sender: TObject);
begin
   MemPrinc.Edit;

   if MemPrinc.IsEmpty then
   begin
      GerarStatus(nil);
      raise Exception.Create('Não exsite nenhum registro para fazer a edição');
   end;

   PageControl1.ActivePageIndex := 1;
   PageControl1Change(nil);

   GerarStatus(Sender);
end;

procedure TFormMain.btnInserirClick(Sender: TObject);
begin
   MemPrinc.Insert;
   GerarStatus(Sender);
   LimparCampos;
   PageControl1.ActivePageIndex := 1;
end;

procedure TFormMain.btnSalvarClick(Sender: TObject);
var
   Pessoa: TPessoa;

begin
   GerarStatus(Sender);

   if MessageDlg('Tem certeza que deseja SALVAR esse registro?', mtConfirmation,
      [mbYes, mbNo], 0) = mrNo then
   begin
      GerarStatus(btnEditar);
      exit;
   end;

   // Condições
   CondicaoTravas;

   // Trava CPF;
   if TFuncao.IsCPF(edtCPF.Text) then
      edtCPF.Text := TFuncao.FormataCPF(edtCPF.Text)
   else
   begin
      GerarStatus(btnEditar);
      ShowMessage('CPF inválido!');
      exit;
   end;

   // Validar CPF Único
   for Pessoa in FGuardarCadastro do
   begin
      if edtCPF.Text = Pessoa.CPF then
      begin
        ShowMessage('Já existe um CPF cadastro no sistema igual!');
        edtCPF.Text := '';
        exit;
      end;
   end;

   if StrToIntDef(edtID.Text, 0) = 0 then
   begin
      Pessoa := TPessoa.Create;

      Pessoa.ID := FGuardarCadastro.Count + 1;
      Pessoa.NomeCompleto := edtNomeCompleto.Text;
      Pessoa.CPF := edtCPF.Text;
      Pessoa.DataNascimento := dateDataNascimento.Date;
      Pessoa.Telefone := edtTelefone.Text;
      Pessoa.Email := edtEmail.Text;
      Pessoa.Endereco.Numero := StrToIntDef(edtNumero.Text, 0);

      Pessoa.Endereco.Logradouro := edtLogradouro.Text;
      Pessoa.Endereco.Bairro := edtBairro.Text;
      Pessoa.Endereco.Cidade := edtCidade.Text;
      Pessoa.Endereco.Propriedade := edtPropriedade.Text;
      Pessoa.Endereco.UF := cmbUF.Text;

      FGuardarCadastro.Add(Pessoa);

      PageControl1.ActivePageIndex := 0;
      ShowMessage('Registro salvo com sucesso!');
   end
   else
   begin
      Pessoa := ObterPessoa(StrToIntDef(edtID.Text, 0));
      if not Assigned(Pessoa) then
         raise Exception.Create('Pessoa não encontrada na hora de editar');

      Pessoa.NomeCompleto := edtNomeCompleto.Text;
      Pessoa.CPF := edtCPF.Text;
      Pessoa.Email := edtEmail.Text;
      Pessoa.Telefone := edtTelefone.Text;
      Pessoa.DataNascimento := dateDataNascimento.Date;

      Pessoa.Endereco.Numero := StrToIntDef(edtNumero.Text, 0);
      Pessoa.Endereco.Logradouro := edtLogradouro.Text;
      Pessoa.Endereco.Bairro := edtBairro.Text;
      Pessoa.Endereco.Cidade := edtCidade.Text;
      Pessoa.Endereco.Propriedade := edtPropriedade.Text;
      Pessoa.Endereco.UF := cmbUF.Text;

      ShowMessage('Registro editado com sucesso!');
   end;

   GerarStatus(nil);
   CarregarGrid;
end;

procedure TFormMain.Button1Click(Sender: TObject);
var
  Arquivo: TextFile;
  I,J, Index: Integer;
  TipoTexto, EscreverTexto, Linha: string;
  Pessoa: TPessoa;
begin
  // Ler arquivos.
  if OpenDialog1.Execute then
  begin
    try
      memArquivos.Clear;
      memArquivos.Lines.LoadFromFile(OpenDialog1.FileName);

      for I := 0 to memArquivos.Lines.Count -1  do
      begin
        Linha := memArquivos.Lines[i];
        Pessoa := TPessoa.Create;
        EscreverTexto := '';
        Index := 0;

        for J := 1 to Length(Linha) do
        begin
          // ID
          if ((Index = 0) and (Linha[J] <> ';')) then // Aqui vai ser o ID
            EscreverTexto := EscreverTexto + Linha[J]
          else if ((Index = 0) and (Linha[J] = ';')) then
          begin
            Index := Index + 1;
            Pessoa.ID := StrToInt(EscreverTexto);
            EscreverTexto := '';
          end

          // Nome
          else if ((Index = 1) and (Linha[J] <> ';')) then
            EscreverTexto := EscreverTexto + Linha[J]
          else if ((Index = 1) and (Linha[J] = ';')) then
          begin
            Index := Index + 1;
            Pessoa.NomeCompleto := EscreverTexto;
            EscreverTexto := '';
          end

          // CPF
          else if ((Index = 2) and (Linha[J] <> ';')) then
            EscreverTexto := EscreverTexto + Linha[J]
          else if ((Index = 2) and (Linha[J] = ';')) then
          begin
            Index := Index + 1;
            Pessoa.CPF := EscreverTexto;
            EscreverTexto := '';
          end

          // Data
          else if ((Index = 3) and (Linha[J] <> ';')) then
            EscreverTexto := EscreverTexto + Linha[J]
          else if ((Index = 3) and (Linha[J] = ';')) then
          begin
            Index := Index + 1;
            Pessoa.DataNascimento := StrToDate(EscreverTexto);
            EscreverTexto := '';
          end

          // Email
          else if ((Index = 4) and (Linha[J] <> ';')) then
            EscreverTexto := EscreverTexto + Linha[J]
          else if ((Index = 4) and (Linha[J] = ';')) then
          begin
            Index := Index + 1;
            Pessoa.Email := EscreverTexto;
            EscreverTexto := '';
          end

          // Telefone
          else if ((Index = 5) and (Linha[J] <> ';')) then
            EscreverTexto := EscreverTexto + Linha[J]
          else if ((Index = 5) and (Linha[J] = ';')) then
          begin
            Index := Index + 1;
            Pessoa.Telefone := EscreverTexto;
            EscreverTexto := '';
          end

          // Numero Rua
          else if ((Index = 6) and (Linha[J] <> ';')) then
            EscreverTexto := EscreverTexto + Linha[J]
          else if ((Index = 6) and (Linha[J] = ';')) then
          begin
            Index := Index + 1;
            Pessoa.Endereco.Numero := StrToInt(EscreverTexto);
            EscreverTexto := '';
          end

          // Cidade
          else if ((Index = 7) and (Linha[J] <> ';')) then
            EscreverTexto := EscreverTexto + Linha[J]
          else if ((Index = 7) and (Linha[J] = ';')) then
          begin
            Index := Index + 1;
            Pessoa.Endereco.Cidade := EscreverTexto;
            EscreverTexto := '';
          end

          // UF
          else if ((Index = 8) and (Linha[J] <> ';')) then
            EscreverTexto := EscreverTexto + Linha[J]
          else if ((Index = 8) and (Linha[J] = ';')) then
          begin
            Index := Index + 1;
            Pessoa.Endereco.UF := EscreverTexto;
            EscreverTexto := '';
          end

          // Bairro
          else if ((Index = 9) and (Linha[J] <> ';')) then
            EscreverTexto := EscreverTexto + Linha[J]
          else if ((Index = 9) and (Linha[J] = ';')) then
          begin
            Index := Index + 1;
            Pessoa.Endereco.Bairro := EscreverTexto;
            EscreverTexto := '';
          end

          // Logradouro
          else if ((Index = 10) and (Linha[J] <> ';')) then
            EscreverTexto := EscreverTexto + Linha[J]
          else if ((Index = 10) and (Linha[J] = ';')) then
          begin
            Index := Index + 1;
            Pessoa.Endereco.Logradouro := EscreverTexto;
            EscreverTexto := '';
          end

          // Propiedade
          else if ((Index = 11) and (Linha[J] <> ';')) then
            EscreverTexto := EscreverTexto + Linha[J]
          else if ((Index = 11) and (Linha[J] = ';')) then
          begin
            Index := Index + 1;
            Pessoa.Endereco.Propriedade := EscreverTexto;
            EscreverTexto := ';';
          end;
        end;

        FGuardarCadastro.Add(Pessoa);
      end;
    finally
      CarregarGrid;
    end;
  end
  else
    raise Exception.Create('Arquivo não selecionado');
end;


procedure TFormMain.CarregarGrid;
var
   Pessoa: TPessoa;
begin
   try
      try
         MemPrinc.DisableControls;
         if (not Assigned(FGuardarCadastro)) or (FGuardarCadastro.Count = 0)
         then
            exit;

         if MemPrinc.Active then
            MemPrinc.Close;

         MemPrinc.Open;
         MemPrinc.Edit;

         for Pessoa in FGuardarCadastro do
         begin
            MemPrinc.Append;
            MemPrincNome.AsString := Pessoa.NomeCompleto;
            MemPrincCPF.AsString := Pessoa.CPF;
            MemPrincEmail.AsString := Pessoa.Email;
            MemPrincID.AsInteger := Pessoa.ID;
            MemPrinc.Post;
         end;

         // MemPrinc.Cancel;

      except
         Raise;
      end;
   finally
      MemPrinc.EnableControls;
   end;
end;

procedure TFormMain.CondicaoTravas;
begin
  // Validações do campo de Pessoa
  if Trim(edtNomeCompleto.Text) = '' then
    raise Exception.Create('Preencha o campo de nome!')
  else if Trim(edtTelefone.Text) = '' then
    raise Exception.Create('Preencha o campo de Telefone!')
  else if Trim(edtEmail.Text) = '' then
    raise Exception.Create('Preencha o campo de Email!')
  else if Trim(edtCPF.Text) = '' then
    raise Exception.Create('Preencha o campo de CPF!')
  else if dateDataNascimento.Date = 0 then
    raise Exception.Create('Preencha o número de Telefone')
  else if Trim(cmbUF.Text) = '' then
    raise Exception.Create('Preencha a UF')
  else if Trim(edtCidade.Text) = '' then
    raise Exception.Create('Preencha a Cidade');
end;

function TFormMain.ObterPessoa(ID: Integer): TPessoa;
var
   Pessoa: TPessoa;
begin
   try
      Result := nil;
      for Pessoa in FGuardarCadastro do
      begin
         if Pessoa.ID = ID then
            Result := Pessoa;
      end;
   except
      on E: Exception do
         ShowMessage(E.Message);
   end;
end;

end.
