unit ulogin;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ZDataset;

type

  { TfrmTelalogin }

  TfrmTelalogin = class(TForm)
    btnLogin: TButton;
    edtUSUARIO: TEdit;
    edtSENHA: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    procedure btnLoginClick(Sender: TObject);
  private

  public

  end;

var
  frmTelalogin: TfrmTelalogin;

implementation

uses uprincipal;

{$R *.lfm}

{ TfrmTelalogin }

procedure TfrmTelalogin.btnLoginClick(Sender: TObject);
var
  qrUSER : TZQuery;
begin
  qrUSER:= TZQuery.create(self);
  qrUSER.Connection:= frmPrincipal.conexao;
  try
  qrUSER.sql.add('SELECT * FROM ctrl_usuario');
  qrUSER.sql.add('WHERE ctrl_usuario.nome = :cNOME');
  qrUSER.ParamByName('cNOME').AsString:=trim(edtUSUARIO.Text);
  qrUSER.Open;
  Except
    on e: Exception do
       ShowMessage('Erro ao abrir tabela de usuario'+#13+
       e.Message+#13+e.ClassName);
  end;
  if qrUSER.Active then
     begin
       if qrUSER.RecordCount > 0 then
          begin
            if qrUSER.FieldByName('senha').Value = trim(edtSENHA.Text) then
               begin
                 frmPrincipal.protegemenu(qrUSER.FieldByName('nivel').Value);
                 ModalResult:=mrYes;
               end
            else
               begin
                 ShowMessage('Senha INvalida');
                 ModalResult:=mrNo;
               end;
          end
       else
          begin
            ShowMessage('Usuario ou senha invalido');
            ModalResult:=mrNo;
          end;
     end
  else
     ModalResult:=mrNo;

end;

end.

