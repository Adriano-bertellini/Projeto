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
      procedure FormClose(Sender: TObject; var Action: TCloseAction);
      procedure FormShow(Sender: TObject);
      procedure FormCreate(Sender: TObject);
      procedure btnInserirClick(Sender: TObject);
      procedure btnSalvarClick(Sender: TObject);
      procedure btnDeletarClick(Sender: TObject);
      procedure PageControl1Change(Sender: TObject);
      procedure btnEditarClick(Sender: TObject);
   private
      { Private declarations }
      FGuardarCadastro: TObjectList<TPessoa>;
   public
      procedure CarregarGrid;
      function ObterPessoa(ID: Integer): TPessoa;
      { Public declarations }

   end;

var
   FormMain: TFormMain;

implementation

uses uFuncoes;

{$R *.dfm}

procedure TFormMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
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
            cmbUF.Text := Pessoa.Endereco.UF;
            edtCidade.Text := Pessoa.Endereco.Cidade;
            edtBairro.Text := Pessoa.Endereco.Bairro;
            edtLogradouro.Text := Pessoa.Endereco.Logradouro;
            edtPropriedade.Text := Pessoa.Endereco.Propriedade;
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
   I: Integer;
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
   if IsCPF(edtCPF.Text) then
      edtCPF.Text := FormataCPF(edtCPF.Text)
   else
   begin
      GerarStatus(btnEditar);
      ShowMessage('CPF inválido!');
      exit;
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

      Pessoa.Endereco.Logradouro := edtLogradouro.Text;
      Pessoa.Endereco.Bairro := edtBairro.Text;
      Pessoa.Endereco.Cidade := edtCidade.Text;
      Pessoa.Endereco.Propriedade := edtPropriedade.Text;
      Pessoa.Endereco.UF := cmbUF.Text;

      FGuardarCadastro.Add(Pessoa);

      // MemPrincID.AsInteger := Pessoa.ID;
      // MemPrincNome.AsString := Pessoa.NomeCompleto;
      // MemPrincEmail.AsString := Pessoa.Email;
      // MemPrincCPF.AsString := Pessoa.CPF;
      // MemPrinc.Post;

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

      Pessoa.Endereco.Logradouro := edtLogradouro.Text;
      Pessoa.Endereco.Bairro := edtBairro.Text;
      Pessoa.Endereco.Cidade := edtCidade.Text;
      Pessoa.Endereco.Propriedade := edtPropriedade.Text;
      Pessoa.Endereco.UF := cmbUF.Text;

      // MemPrincNome.AsString := edtNomeCompleto.Text;
      // MemPrincEmail.AsString := edtEmail.Text;
      // MemPrincCPF.AsString := edtCPF.Text;
      // MemPrinc.Post;

      ShowMessage('Registro editado com sucesso!');
   end;

   GerarStatus(nil);
   CarregarGrid;
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
