unit univel;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, rxdbgrid;

type

  { TfrmNivel }

  TfrmNivel = class(TForm)
    RxDBGrid2: TRxDBGrid;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
  private

  public

  end;

var
  frmNivel: TfrmNivel;

implementation
  uses uprincipal;

{$R *.lfm}

  { TfrmNivel }

  procedure TfrmNivel.FormShow(Sender: TObject);
  begin
    frmPrincipal.tbNivel.Open;
  end;

procedure TfrmNivel.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  frmPrincipal.tbNivel.close;

end;

end.

