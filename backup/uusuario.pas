unit uusuario;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, Forms, Controls, Graphics, Dialogs, DBCtrls, StdCtrls,
  ZDataset;

type

  { TfrmUsuario }

  TfrmUsuario = class(TForm)
    DBComboBox1: TDBComboBox;
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    DBEdit3: TDBEdit;
    DBNavigator1: TDBNavigator;
    dsUsuario: TDataSource;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    tbUsuario: TZTable;
  private

  public

  end;

var
  frmUsuario: TfrmUsuario;

implementation
  uses uprincipal;

{$R *.lfm}

end.

