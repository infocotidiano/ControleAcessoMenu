unit uproncipal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls,
  ZConnection, ZDataset, ZSqlUpdate;

type

  { Tform1 }

  Tform1 = class(TForm)
    btnMudaNivel: TButton;
    btnNIVEL: TButton;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem10: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem12: TMenuItem;
    MenuItem13: TMenuItem;
    MenuItem14: TMenuItem;
    MenuItem15: TMenuItem;
    MenuItem16: TMenuItem;
    MenuItem17: TMenuItem;
    MenuItem18: TMenuItem;
    MenuItem19: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem20: TMenuItem;
    MenuItem21: TMenuItem;
    MenuItem22: TMenuItem;
    MenuItem23: TMenuItem;
    MenuItem24: TMenuItem;
    MenuItem25: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    conexao: TZConnection;
    zquery1: TZQuery;
    zquery1descricao: TStringField;
    zquery1indice: TLongintField;
    zquery1nivel: TLongintField;
    zquery1nome: TStringField;
    zupdate1: TZUpdateSQL;
    procedure btnMudaNivelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    procedure CriaDBmenu;
    procedure incluiDB(cNOME, cDESCRICAO: string; nNIVEL, nINDICE: integer);
    procedure protegemenu(nNIVEL: integer);
    function RetornaNIVEL(cNOME: string): integer;

  public

  end;

var
  form1: Tform1;

implementation


{$R *.lfm}

procedure Tform1.FormShow(Sender: TObject);
begin
  CriaDBmenu;
end;

procedure Tform1.btnMudaNivelClick(Sender: TObject);
var
  cNIVEL:string;
begin
  InputQuery('Controle de Menu','Informe o nível do Usuario',cNIVEL);
  protegemenu(StrToIntDef(cNIVEL,1));
end;

procedure Tform1.CriaDBmenu;
// varre os itens do menu e chama a funcao para inclusao no banco de dados/
var
  nITEM, nPRINCIPAL, nIndice : Integer;
begin
  nIndice := 0;
  for nPRINCIPAL := 0 to MainMenu1.Items.Count-1 do
    begin
      incluiDB(MainMenu1.Items[nPRINCIPAL].Name,
                 MainMenu1.Items[nPRINCIPAL].Caption,
                 1,
                 nIndice);
      nIndice:= nIndice+1;
      for nITEM := 0 to MainMenu1.Items[nPRINCIPAL].Count-1 do
        begin
        incluiDB(MainMenu1.Items[nPRINCIPAL].Items[nITEM].Name,
                   '   --'+MainMenu1.Items[nPRINCIPAL].Items[nITEM].Caption,
                   1,
                   nIndice);
        nIndice:= nIndice+1;
        end;
    end;
end;

procedure Tform1.incluiDB(cNOME, cDESCRICAO: string; nNIVEL, nINDICE: integer);
var
  qrTMP : TZQuery;
begin
  // Faz a inclusão/atualizacao dos itens do menu na base.
  // Se o nome existir, atualiza a descricao
  qrTMP := TZQuery.Create(self);
  qrTMP.Connection:=conexao;
  qrTMP.sql.Add('INSERT INTO crt_menu (nome, descricao, nivel, indice)');
  qrTMP.sql.Add('VALUES(:cNOME, :cDESCRICAO, :nNIVEL, :nINDICE ) ON');
  qrTMP.sql.Add('DUPLICATE KEY UPDATE descricao = :cDESCRICAO, indice = :nINDICE');
  qrTMP.ParamByName('cNOME').AsString      := cNOME ;
  qrTMP.ParamByName('cDESCRICAO').AsString := cDESCRICAO ;
  qrTMP.ParamByName('nNIVEL').AsInteger    := nNIVEL ;
  qrTMP.ParamByName('nINDICE').AsInteger   := nINDICE ;
  try
  qrTMP.ExecSQL;
  except
    on e: Exception do
       begin
          ShowMessage('Erro L90 '+#13+e.Message+#13+e.ClassName);
       end;
  end;
  FreeAndNil(qrTMP);
end;


procedure Tform1.protegemenu(nNIVEL: integer);
// Carrega o menu inteiro, durante o carregamento
// verifica o nivel do usuario, se o nivel do usuario
// for menor ou igual ao permitido na base de menu, ele exibe ou nao
var
  nITEM, nPRINCIPAL : integer;
begin
  for nPRINCIPAL := 0 to MainMenu1.Items.Count-1 do
    begin
      if nNIVEL >= RetornaNIVEL(MainMenu1.Items[nPRINCIPAL].Name) then
         MainMenu1.Items[nPRINCIPAL].Enabled :=true
      else
         MainMenu1.Items[nPRINCIPAL].Enabled :=false;
      for nITEM := 0 to MainMenu1.Items[nPRINCIPAL].Count-1 do
        begin
           if nNIVEL >= RetornaNIVEL(MainMenu1.Items[nPRINCIPAL].Items[nITEM].Name) then
              MainMenu1.Items[nPRINCIPAL].Items[nITEM].Enabled:=true
           else
              MainMenu1.Items[nPRINCIPAL].Items[nITEM].Enabled:=false;
        end;
    end;

end;

function Tform1.RetornaNIVEL(cNOME:string):integer;
// realiza a pesquisa de nivel, se encontrar o nome
// retorna o nivel cadastrado.
var
qrTMP : TZQuery;
nNIVEL : integer;
begin
  qrTMP := TZQuery.Create(self);
  qrTMP.Connection := conexao;
  qrTMP.sql.Add('select * from crt_menu where nome = :cNOME');
  qrTMP.ParamByName('cNOME').AsString:=cNOME;
  qrTMP.Open;
  if qrTMP.RecordCount > 0 then
     nNIVEL := qrTMP.FieldByName('NIVEL').Value
  else
     nNIVEL := 1;
  FreeAndNil(qrTMP);
  result := nNIVEL;
end;





end.

