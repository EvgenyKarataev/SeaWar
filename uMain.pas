unit uMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ToolWin, ActnMan, ActnCtrls, ActnMenus, ActnList,
  XPStyleActnCtrls, XPMan, ExtCtrls, ComCtrls, jpeg, StdCtrls, Menus,
  Buttons, ImgList, ScktComp, IdBaseComponent, IdComponent, IdUDPBase,
  IdUDPServer;

const
  ShipCol = -16777187;
  ShipDiedCol = -16777199;
  Player = 1;
  Comp = 2;

  TCP_PORT        = 19124;
  UDP_SERVER_PORT = 27048;
  UDP_CLIENT_PORT = 27044;
  GAMEGUID: TGUID = '{E448FC8E-9EE6-4BB7-B38D-BA2116914D2E}';

type
  TUDPString = string[255];

  TUDPMessage = record
    ID: TGUID;
    MsgType: (udpFindServer, udpCreateServer, udpCloseServer);
    ServerName: TUDPString;
    Gaming: Boolean;
  end;

  PGameServer = ^TGameServer;
  TGameServer = record
    Name,
    Host,
    IP: string;
    Gaming: Boolean;
  end;

  TGameMessage = record
    MsgType: (msgEnemyInfo, msgMove, msgWin, msgFull, msgMessage);
    EnemyName: TUDPString;
    MessageText: TUDPString;
    ACol, ARow: Integer;
    PlayAgain: Boolean;
  end;

  TDirection = record
    dDirect: Integer;
    d0, d1, d2, d3: Boolean;
  end;

  TCompShot = record
    csInjured: Boolean;
    csX0, csY0: Integer;
    csPulubsKill: Integer;
    csDirection: TDirection;
  end;

  TMyResult = record
    fResult: Boolean;
    fPlace: string;
  end;

  TMiss = class;

  TMisses = class(TObject)
  private
    FMisses: TList;

    function GetCount: Integer;
    function GetMiss(Index: Integer): TMiss;
  public
    function AddMiss: TMiss;
    function IndexOf(Miss: TMiss): Integer;
    procedure Clear;
    procedure Delete(Index: Integer);

    property Misses[Index: Integer]: TMiss read GetMiss; default;
    property Count: Integer read GetCount;

    constructor Create;
  end;

  TMiss = class(TObject)
  private
    FLab: TLabel;

    FX, FY, FHeight, FWidth: Integer;

    function GetParent: TWinControl;
    procedure SetHeight(const Value: Integer);
    procedure SetParent(const Value: TWinControl);
    procedure SetWidth(const Value: Integer);
    procedure SetX(const Value: Integer);
    procedure SetY(const Value: Integer);
  public
    property Lab: TLabel read FLab;
    property Parent: TWinControl read GetParent write SetParent;
    property X: Integer read FX write SetX;
    property Y: Integer read FY write SetY;
    property Height: Integer read FHeight write SetHeight;
    property Width: Integer read FWidth write SetWidth;

    constructor Create(Misses: TMisses);
    destructor Destroy;
  end;

  TShip = class;

  TShips = class(TObject)
  private
    FShips: TList;

    FKinds: array[1..4] of Integer;   // ����� �������
    FCountDead: Integer;

    function GetShip(Index: Integer): TShip;
    function GetCount: Integer;
    function GerKind(Index: Integer): Integer;
    procedure SetKind(Index: Integer; const Value: Integer);
  public
    function AddShip: TShip;
    function IndexOf(Ship: TShip): Integer;
    procedure Clear;
    procedure Delete(Index: Integer);

    property Ships[Index: Integer]: TShip read GetShip; default;
    property Kinds[Index: Integer]: Integer read GerKind write SetKind;
    property Count: Integer read GetCount;
    property CountDead: Integer read FCountDead write FCountDead;

    constructor Create;
  end;

  TShip = class(TObject)
  private
    FSel: TShape;
    FOwner: TShips;

    FKind: Integer;  // ����� �������

    FLive: Real;

    FX, FY, FHeight, FWidth: Integer;

    function GetParent: TWinControl;
    procedure SetParent(const Value: TWinControl);
    procedure SetX(const Value: Integer);
    procedure SetY(const Value: Integer);
    procedure SetHeight(const Value: Integer);
    procedure SetWidth(const Value: Integer);
  public
    property Sel: TShape read FSel;
    property Owner: TShips read FOwner;
    property Kind: Integer read FKind write FKind;
    property Live: Real read FLive write FLive;
    property Parent: TWinControl read GetParent write SetParent;
    property X: Integer read FX write SetX;
    property Y: Integer read FY write SetY;
    property Height: Integer read FHeight write SetHeight;
    property Width: Integer read FWidth write SetWidth;

    constructor Create(Ships: TShips);
    destructor Destroy;
  end;

  TfmMain = class(TForm)
    ActionManager1: TActionManager;
    acNewGame: TAction;
    acExit: TAction;
    acAbout: TAction;
    ActionMainMenuBar1: TActionMainMenuBar;
    XPManifest1: TXPManifest;
    pSelf: TPanel;
    pComp: TPanel;
    sbStat: TStatusBar;
    Label1: TLabel;
    lbNameSelf: TLabel;
    Label2: TLabel;
    lbNameComp: TLabel;
    hcHead: THeaderControl;
    Image1: TImage;
    Image2: TImage;
    pFiledSelf: TPanel;
    iFIeldSelf: TImage;
    pFiledComp: TPanel;
    iFieldComp: TImage;
    Image3: TImage;
    Image5: TImage;
    pmForShip: TPopupMenu;
    nDel: TMenuItem;
    acSet: TAction;
    pStart: TPanel;
    bbStart: TBitBtn;
    ImageList1: TImageList;
    Memo1: TMemo;
    acStartGame: TAction;
    acLoad: TAction;
    Action1: TAction;
    Action2: TAction;
    Action3: TAction;
    Action4: TAction;
    Action5: TAction;
    UDPServer: TIdUDPServer;
    ServerSocket: TServerSocket;
    ClientSocket: TClientSocket;
    sbMain: TStatusBar;
    procedure acNewGameExecute(Sender: TObject);
    procedure acExitExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure iFIeldSelfMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure nDelClick(Sender: TObject);
    procedure acSetExecute(Sender: TObject);
    procedure acStartGameExecute(Sender: TObject);
    procedure acStartGameUpdate(Sender: TObject);
    procedure acLoadExecute(Sender: TObject);
    procedure iFieldCompMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Action1Execute(Sender: TObject);
    procedure Action2Execute(Sender: TObject);
    procedure acAboutExecute(Sender: TObject);
    procedure Action3Execute(Sender: TObject);
    procedure ServerSocketClientConnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ServerSocketClientDisconnect(Sender: TObject;
      Socket: TCustomWinSocket);
  private
    { Private declarations }
    IsServer, Gaming, Win, MyStep: Boolean;
    Flash: Boolean;

    X1, X2, Y1, Y2, Height, Width: Integer;        //����� ��� ������� ����� ���������.
    OldShip: TShip;

    CompShot: TCompShot;

    procedure SelMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure RecToDown(Index: Integer);
    procedure FindBorderXY(X, Y:Integer);
    procedure Wall(X1, Y1, Palubs, Direction, Index: Integer; Parent:TWinControl);
    procedure Shot;
    procedure Loser;

    function FindBorder(X, Y: Integer): Boolean;

    function TestDiag(X, Y, Index: Integer): Boolean; //��� �� �� ��������� ���� ��� ������
    function TestNear(X, Y, Index: Integer): TMyResult; //��� �� ����� ��� ������
    function TestToFree(X, Y, Index: Integer): Boolean;  //�������� �� ��� �����
    function TestToCan(X1, Y1, Height, Width, Palubs, Direction: Integer): TMyResult;
    function TestCanUp(X1, Y1, Height, Width, Palubs: Integer): Boolean;
    function TestCanDown(X1, Y1, Height, Width, Palubs: Integer): Boolean;
    function TestCanRight(X1, Y1, Height, Width, Palubs: Integer): Boolean;
    function TestCanLeft(X1, Y1, Height, Width, Palubs: Integer): Boolean;
    function TestHaveMiss(X, Y, Index: Integer): Boolean;
  public
    { Public declarations }
    Fields: array[1..2] of TShips;
    Shots: array[1..2] of TMisses;

    Me, Enemy: TGameServer;
  end;

var
  fmMain: TfmMain;

implementation

uses uNewGame, uSet, uAbout, uConnect;

{$R *.dfm}

procedure TfmMain.acNewGameExecute(Sender: TObject);
begin
  fmNewGame.ShowModal;

  case fmNewGame.ModalResult of
    mrOk: begin
            pSelf.Visible := True;
            pStart.Visible := True;
            pSelf.Enabled := True;

            lbNameSelf.Caption := fmNewGame.edNameSelf.Text;
            lbNameComp.Caption := fmNewGame.edNameComp.Text;
            hcHead.Sections.Items[0].Text := '������: ' + lbNameSelf.Caption + ' '
              + IntToStr(fmNewGame.seAgeSelf.Value) + ' ��� � '
              + lbNameComp.Caption + ' ' + IntToStr(fmNewGame.seAgeComp.Value) + ' ��� (';
            if fmNewGame.rbEasy.Checked then
              hcHead.Sections.Items[0].Text := hcHead.Sections.Items[0].Text + '�������)'
            else
              hcHead.Sections.Items[0].Text := hcHead.Sections.Items[0].Text + '������������)';

            Fields[1].Clear;
            Fields[2].Clear;
            Shots[1].Clear;
            Shots[2].Clear;

            RecToDown(Player);
            RecToDown(Comp);

            Height := 18;
            Width := 20;

            pSelf.Enabled := True;
            pFiledComp.Enabled := True;
          end;//ok
  end;
end;

procedure TfmMain.acExitExecute(Sender: TObject);
begin
  Close;
end;

{ TShips }

function TShips.AddShip: TShip;
begin
  Result := TShip.Create(Self);         //�������� �����������
  FShips.Add(Result);
end;

procedure TShips.Clear;
var
  i: Integer;
begin
  for i := Count - 1 downto 0 do
    Delete(i);

  for i := 1 to 4 do
    Kinds[i] := 0;

  CountDead := 0;  
end;

constructor TShips.Create;
begin
  inherited;

  FShips := TList.Create;
end;

procedure TShips.Delete(Index: Integer);
begin
  if Index > -1 then
  begin
    Ships[Index].Sel.Free;  //������� �������
    FShips.Delete(Index);
  end;
end;

function TShips.GerKind(Index: Integer): Integer;
begin
  Result := FKinds[Index];
end;

function TShips.GetCount: Integer;
begin
  Result := FShips.Count;
end;

function TShips.GetShip(Index: Integer): TShip;
begin
  Result := FShips[Index];
end;

function TShips.IndexOf(Ship: TShip): Integer;
begin
  Result := FShips.IndexOf(Ship)
end;

procedure TShips.SetKind(Index: Integer; const Value: Integer);
begin
  FKinds[Index] := Value;
end;

{ TShip }

constructor TShip.Create(Ships: TShips);
begin
  inherited Create;

  FOwner := Ships;
  FSel := TShape.Create(nil);      //������� �������
  FSel.Tag := Integer(Self);
end;

destructor TShip.Destroy;
begin
  FSel.Free;                       //���������� �������������

  inherited;
end;

function TShip.GetParent: TWinControl;
begin
  Result := FSel.Parent;
end;

procedure TShip.SetHeight(const Value: Integer);
begin
  if Value = FHeight then Exit;

  FHeight := Value;   //���������� � ��� ���� ������ �������
  FSel.Height := FHeight;
end;

procedure TShip.SetParent(const Value: TWinControl);
begin
  FSel.Parent := Value;
end;

procedure TShip.SetWidth(const Value: Integer);
begin
  if Value = FWidth then Exit;

  FWidth := Value;                //���������� � ��� ���� ������ �������
  FSel.Width := FWidth;
end;

procedure TShip.SetX(const Value: Integer);
begin
  if Value = FX then Exit;

  FX := Value;                //���������� ����� �������
  FSel.Left := Value;
end;

procedure TShip.SetY(const Value: Integer);
begin
  if Value = FY then Exit;

  FY := Value;                //���������� ������� �������
  FSel.Top := Value;
end;

procedure TfmMain.FormCreate(Sender: TObject);
var
  i: Integer;
begin
  for i := 1 to 2 do
    begin
      Fields[i] := TShips.Create;
      Shots[i] := TMisses.Create;
    end;
end;

procedure TfmMain.SelMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
//����� �������� �� �������������, �� ��� ���� ��������. ��� ������ �������� ��� ����� �
//����� � ����� ������� ��������� ��������� Select
var
  Rec: TShape;
  Point: TPoint;
begin
  Rec := TShape(Sender);
  OldShip := TShip(Rec.Tag);

  case Button of
  mbRight:
      if fmSet.cbRightToDel.Checked then
        begin
          Fields[Player].Kinds[OldShip.Kind] := Fields[Player].Kinds[OldShip.Kind] - 1;
          Fields[Player].Delete(Fields[Player].IndexOf(OldShip));
          RecToDown(Player);
        end  // if fmSet.cbRightToDel.Checked
      else
        begin
          Point.X := X; Point.Y := Y;
          Point := Rec.ClientToScreen(Point);
          pmForShip.Popup(Point.X, Point.Y)
        end; //else
  end;
end;

function TfmMain.TestDiag(X, Y, Index: Integer): Boolean;
{��������� ��� �� ��������� ������� �������}
var
  X1, Y1, i: Integer;
begin
  Result := True;

{========= �������� ������ ������� ������=====================================}
  X1 := X + Width;
  Y1 := Y - Height;

  if (X1 < 203) and (Y1 > 0) then
    for i := 0 to Fields[Index].Count - 1 do
      if (X1 > Fields[Index][i].X)and(X1 < (Fields[Index][i].X + Fields[Index][i].Width))
       and(Y1 > Fields[Index][i].Y)and(Y1 < (Fields[Index][i].Y + Fields[Index][i].Height)) then
         begin
           Result := False;

           break;
         end;

{========= �������� ������ ������ ������=====================================}
  X1 := X + Width;
  Y1 := Y + Height;

  if (X1 < 203) and (Y1 < 182) then
    for i := 0 to Fields[Index].Count - 1 do
      if (X1 > Fields[Index][i].X)and(X1 < (Fields[Index][i].X + Fields[Index][i].Width))
       and(Y1 > Fields[Index][i].Y)and(Y1 < (Fields[Index][i].Y + Fields[Index][i].Height)) then
         begin
           Result := False;

           break;
         end;

{========= �������� ����� ������ ������=====================================}
  X1 := X - Width;
  Y1 := Y + Height;

  if (X1 > 0) and (Y1 < 182) then
    for i := 0 to Fields[Index].Count - 1 do
      if (X1 > Fields[Index][i].X)and(X1 < (Fields[Index][i].X + Fields[Index][i].Width))
       and(Y1 > Fields[Index][i].Y)and(Y1 < (Fields[Index][i].Y + Fields[Index][i].Height)) then
         begin
           Result := False;

           break;
         end;

{========= �������� ����� ������� ������=====================================}
  X1 := X - Width;
  Y1 := Y - Height;

  if (X1 > 0 ) and (Y1 > 0) then
    for i := 0 to Fields[Index].Count - 1 do
      if (X1 > Fields[Index][i].X)and(X1 < (Fields[Index][i].X + Fields[Index][i].Width))
       and(Y1 > Fields[Index][i].Y)and(Y1 < (Fields[Index][i].Y + Fields[Index][i].Height)) then
         begin
           Result := False;

           break;
         end;
end;

function TfmMain.TestNear(X, Y, Index: Integer): TMyResult;
{��������� ���� �� ����� �������}
var
  X1, Y1, i: Integer;
begin
  Result.fResult := False;
  Result.fPlace := '';

{========= �������� ������� ������=====================================}
  X1 := X;
  Y1 := Y - Height;

  if (Y1 > 0) then
    for i := 0 to Fields[Index].Count - 1 do
      if (X1 > Fields[Index][i].X)and(X1 < (Fields[Index][i].X + Fields[Index][i].Width))
       and(Y1 > Fields[Index][i].Y)and(Y1 < (Fields[Index][i].Y + Fields[Index][i].Height)) then
         begin
           Result.fResult := True;
           Result.fPlace := 'Top';
           OldShip := Fields[Index][i];

           break;
         end;

{========= �������� ������ ������=====================================}
  X1 := X + Width;
  Y1 := Y;

  if (X1 < 203) then
    for i := 0 to Fields[Index].Count - 1 do
      if (X1 > Fields[Index][i].X)and(X1 < (Fields[Index][i].X + Fields[Index][i].Width))
       and(Y1 > Fields[Index][i].Y)and(Y1 < (Fields[Index][i].Y + Fields[Index][i].Height)) then
         begin
           if Result.fPlace = '' then
             begin
               Result.fResult := True;
               Result.fPlace := 'Right';
               OldShip := Fields[Index][i];
             end // if Result.fResult = ''
           else
             begin
               Result.fResult := False;
               Result.fPlace := 'Double';
             end;  // else
           break;
         end;

{========= �������� ������ ������=====================================}
  X1 := X;
  Y1 := Y + Height;

  if (Y1 < 182) then
    for i := 0 to Fields[Index].Count - 1 do
      if (X1 > Fields[Index][i].X)and(X1 < (Fields[Index][i].X + Fields[Index][i].Width))
       and(Y1 > Fields[Index][i].Y)and(Y1 < (Fields[Index][i].Y + Fields[Index][i].Height)) then
         begin
           if Result.fPlace = '' then
             begin
               Result.fResult := True;
               Result.fPlace := 'Bottom';
               OldShip := Fields[Index][i];
             end  // if Result.fResult = ''
           else
             begin
               Result.fResult := False;
               Result.fPlace := 'Double';
             end; // else
           break;
         end;

{========= �������� ����� ������=====================================}
  X1 := X - Width;
  Y1 := Y;

  if (X1 > 0) then
    for i := 0 to Fields[Index].Count - 1 do
      if (X1 > Fields[Index][i].X)and(X1 < (Fields[Index][i].X + Fields[Index][i].Width))
       and(Y1 > Fields[Index][i].Y)and(Y1 < (Fields[Index][i].Y + Fields[Index][i].Height)) then
         begin
           if Result.fPlace = '' then
             begin
               Result.fResult := True;
               Result.fPlace := 'Left';
               OldShip := Fields[Index][i];
             end  //  if Result.fResult = ''
           else
             begin
               Result.fResult := False;
               Result.fPlace := 'Double';
             end; // else
           break;
         end;
end;

procedure TfmMain.iFIeldSelfMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  i, j, MayBe: Integer;
  Ship: TShip;
label
  toEnd;
begin
  case Button of
  mbLeft:
      if iFIeldSelf.Canvas.Pixels[X, Y] <> clBlack then  //���� ��������� �� �� �������
      begin

        if (Height > 0) or (Width > 0) then
          if not TestDiag(X, Y, Player) then
            begin
              Application.MessageBox('����� ������� ������!', '��������', mrNone);

              goto toEnd;
            end;  // if not TestDiag(X, Y)

        for i := Y downto 0 do        //��� �� ������� ������� �������
          if iFIeldSelf.Canvas.Pixels[X, i] = clBlack then
            begin
              Y1 := i;  //������� �������
              break;
            end;

        for i := X downto 0 do         //��� �� ����� ������� �������
          if iFIeldSelf.Canvas.Pixels[i, Y] = clBlack then
            begin
              X1 := i;   //����� �������
              break;
            end;
                  //��� �� ������ ������� �������
        for i := X to iFIeldSelf.ClientWidth do
          if iFIeldSelf.Canvas.Pixels[i, Y] = clBlack then
            begin
              X2 := i + 1;    //������ �������
              break;
            end;
                    //��� �� ������ ������� �������
        for i := Y to iFIeldSelf.ClientHeight do
          if iFIeldSelf.Canvas.Pixels[X, i] = clBlack then
            begin
              Y2 := i + 1;   //������ �������
              break;
            end;

        with TestNear(X, Y, Player) do
         if fResult then
          begin
            MayBe := OldShip.Kind + 1;

            if (Maybe >= 4)and(Fields[Player].Kinds[MayBe] > 0) then goto toEnd
            else if (MayBe = 3)and(Fields[Player].Kinds[MayBe] > 1) then goto toEnd
            else if (MayBe = 2)and(Fields[Player].Kinds[MayBe] > 2) then goto toEnd;

            Fields[Player].Kinds[OldShip.Kind] := Fields[Player].Kinds[OldShip.Kind] - 1;
            OldShip.Kind := OldShip.Kind + 1;
            Fields[Player].Kinds[OldShip.Kind] := Fields[Player].Kinds[OldShip.Kind] + 1;

            if fPlace = 'Top' then
              OldShip.Height := OldShip.Height + Height
            else if fPlace = 'Right' then
                    begin
                        OldShip.X := OldShip.X - Width;
                        OldShip.Width := OldShip.Width + Width;
                    end  //  if fPlace = 'Right'
                 else if fPlace = 'Bottom' then
                        begin
                          OldShip.Y := OldShip.Y - Height;
                          OldShip.Height := OldShip.Height + Height;
                        end   // if fPlace = 'Bottom'
                     else
                       OldShip.Width := OldShip.Width + Width;
          end //  if fResult then
         else
          begin
            if fPlace = 'Double' then  //���� ����� ��������� ����� ����� ���������
              begin
                Application.MessageBox('����� ������� ������!', '��������', mrNone);
                goto toEnd;
              end;

            if Fields[Player].Count = 10 then goto toEnd;
            if (Fields[Player].Kinds[4] = 1)and(Fields[Player].Kinds[3] = 2)
              and(Fields[Player].Kinds[2] = 3)and(Fields[Player].Kinds[1] > 3) then goto toEnd;
            if Fields[Player].Kinds[1] > 4 then goto toEnd;


            Ship := Fields[Player].AddShip; //�������� ����� ������
            Ship.Sel.Shape := stRectangle;              //������ ��� �����
            Ship.Sel.Brush.Color := ShipCol;
            Ship.Kind := 1;
            Ship.Live := 100;
            Ship.Sel.OnMouseUp := SelMouseUp;

            Ship.X := X1;
            Ship.Y := Y1;

            Ship.Height := Y2 - Y1;                                 //����������� ������ ��������������
            Ship.Width := X2 - X1;                                  //����������� ������ ��������������

            Height := Ship.Height;
            Width := Ship.Width;

            Ship.Parent := pFiledSelf;

            Fields[Player].Kinds[Ship.Kind] := Fields[Player].Kinds[Ship.Kind] + 1;
          end; //else k  if TestNear(X, Y)

        RecToDown(Player);  //���������� ���-�� ��������

        toEnd:      //���� ���� �   goto toEnd;

      end; //  if iOutBlank.Canvas.Pixels[X, Y] <> clBlack

  end; //case
end;

procedure TfmMain.nDelClick(Sender: TObject);
begin
  Fields[Player].Kinds[OldShip.Kind] := Fields[Player].Kinds[OldShip.Kind] - 1;
  Fields[Player].Delete(Fields[Player].IndexOf(OldShip));
  RecToDown(Player);
end;

procedure TfmMain.acSetExecute(Sender: TObject);
begin
  fmSet.ShowModal;
end;

procedure TfmMain.RecToDown(Index: Integer);
begin
  sbStat.Panels.Items[Index - 1].Text := '��������: ' + IntToStr(Fields[Index].Count - Fields[Index].CountDead) + ';  ';
  sbStat.Panels.Items[Index - 1].Text := sbStat.Panels.Items[Index - 1].Text + ' 4-x �.: ' + IntToStr(Fields[Index].Kinds[4]) + '; ';
  sbStat.Panels.Items[Index - 1].Text := sbStat.Panels.Items[Index - 1].Text + ' 3-x �.: ' + IntToStr(Fields[Index].Kinds[3]) + '; ';
  sbStat.Panels.Items[Index - 1].Text := sbStat.Panels.Items[Index - 1].Text + ' 2-x �.: ' + IntToStr(Fields[Index].Kinds[2]) + '; ';
  sbStat.Panels.Items[Index - 1].Text := sbStat.Panels.Items[Index - 1].Text + ' 1-x �.: ' + IntToStr(Fields[Index].Kinds[1]) + '; '
end;

procedure TfmMain.acStartGameExecute(Sender: TObject);
begin
  pStart.Visible := False;
  pComp.Visible := True;
  pSelf.Enabled := False;

  acLoad.OnExecute(nil);
end;

procedure TfmMain.acStartGameUpdate(Sender: TObject);
begin
  if (Fields[Player].Count = 10)and(Fields[Player].Kinds[1] = 4)and(Fields[Player].Kinds[2] = 3)
      and(Fields[Player].Kinds[3] = 2)and(Fields[Player].Kinds[4] = 1) then
        acStartGame.Enabled := True
  else
    acStartGame.Enabled := False;
end;

function TfmMain.TestCanUp(X1, Y1, Height, Width,
  Palubs: Integer): Boolean;
{��������� ����� �� �� ���� ��������� �������}
var
  i, Y, X: Integer;
begin
  Result := True;

  for i := 1 to Palubs do
    begin
      Y := Y1 - Height * (i - 1); //����������� ������ �� ������ �����

      X := X1;

      if (not TestDiag(X, Y, Comp))or(TestNear(X, Y, Comp).fResult) then
        begin
          Result := False;

          break;
        end
    end; //for i := 1 to Palubs
end;

function TfmMain.TestCanDown(X1, Y1, Height, Width,
  Palubs: Integer): Boolean;
{��������� ����� �� �� ��� ��������� �������}
var
  i, Y, X: Integer;
begin
  Result := True;

  for i := 1 to Palubs do
    begin
      Y := Y1 + Height * (i - 1); //����������� ������ �� ������ �����

      X := X1;

      if (not TestDiag(X, Y, Comp))or(TestNear(X, Y, Comp).fResult) then
        begin
          Result := False;

          break;
        end
    end; //for i := 1 to Palubs
end;

function TfmMain.TestCanRight(X1, Y1, Height, Width,
  Palubs: Integer): Boolean;
{��������� ����� �� �� ����� ��������� �������}
var
  i, Y, X: Integer;
begin
  Result := True;

  for i := 1 to Palubs do
    begin
      X := X1 + Width * (i - 1); //����������� ������ �� ������ �����

      Y := Y1;

      if (not TestDiag(X, Y, Comp))or(TestNear(X, Y, Comp).fResult) then
        begin
          Result := False;

          break;
        end
    end; //for i := 1 to Palubs
end;

function TfmMain.TestCanLeft(X1, Y1, Height, Width,
  Palubs: Integer): Boolean;
{��������� ����� �� �� ���� ��������� �������}
var
  i, Y, X: Integer;
begin
  Result := True;

  for i := 1 to Palubs do
    begin
      X := X1 - Width * (i - 1); //����������� ������ �� ������ �����

      Y := Y1;

      if (not TestDiag(X, Y, Comp))or(TestNear(X, Y, Comp).fResult) then
        begin
          Result := False;

          break;
        end
    end; //for i := 1 to Palubs
end;

function TfmMain.TestToCan(X1, Y1, Height, Width, Palubs,
  Direction: Integer): TMyResult;
{====��������� ������� �� ������� � ������ �� ������ ��=====}
begin
    case Direction of
{�� 12 ���}  0:
               begin
                 if (Y1 - Height * (Palubs - 1) > 0) then
                   if TestCanUp(X1, Y1, Height, Width, Palubs) then
                     begin
                       Result.fResult := True;
                       Result.fPlace := 'Up';
                     end // if TestCanUp(X1, Y1, Height, Width, Palubs)
                   else  // if TestCanUp(X1, Y1, Height, Width, Palubs)
                     if (Y1 + Height * Palubs < 182) then
                       if  TestCanDown(X1, Y1, Height, Width, Palubs) then
                         begin
                           Result.fResult := True;
                           Result.fPlace := 'Down';
                         end
                       else   //if  TestCanDown(X1, Y1, Height, Width, Palubs)
                         Result.fResult := False
                     else  //if (X1 + Height * Palubs < 182)
                       Result.fResult := False
                 else
                    if (Y1 + Height * Palubs < 182) then
                       if  TestCanDown(X1, Y1, Height, Width, Palubs) then
                         begin
                           Result.fResult := True;
                           Result.fPlace := 'Down';
                         end
                       else   //if  TestCanDown(X1, Y1, Height, Width, Palubs)
                         Result.fResult := False
                     else  //if (X1 + Height * Palubs < 182)
                       Result.fResult := False
               end;  // 0  ����������� �����
{�� 3 ���a}  1:
               begin
                 if X1 + Width * Palubs < 201 then
                   if TestCanRight(X1, Y1, Height, Width, Palubs) then
                     begin
                       Result.fResult := True;
                       Result.fPlace := 'Right';
                     end
                   else  //if TestCanRight(X1, Y1, Height, Width, Palubs)
                     if X1 - Width * (Palubs - 1) > 0 then
                       if TestCanLeft(X1, Y1, Height, Width, Palubs) then
                         begin
                           Result.fResult := True;
                           Result.fPlace := 'Left';
                         end  //  if TestCanLeft(X1, Y1, Height, Width, Palubs)
                       else  // if TestCanLeft(X1, Y1, Height, Width, Palubs)
                         Result.fResult := False
                     else   // if X1 - Width * (Palubls - 1) > 0
                       Result.fResult := False
                 else
                   if X1 - Width * (Palubs - 1) > 0 then
                       if TestCanLeft(X1, Y1, Height, Width, Palubs) then
                         begin
                           Result.fResult := True;
                           Result.fPlace := 'Left';
                         end  //  if TestCanLeft(X1, Y1, Height, Width, Palubs)
                       else  // if TestCanLeft(X1, Y1, Height, Width, Palubs)
                         Result.fResult := False
                     else   // if X1 - Width * (Palubls - 1) > 0
                       Result.fResult := False
               end;  // 1  ����������� ������
{�� 6 ���}   2:
               begin
                 if Y1 + Height * Palubs < 182 then
                   if TestCanDown(X1, Y1, Height, Width, Palubs) then
                     begin
                       Result.fResult := True;
                       Result.fPlace := 'Down';
                     end  // if TestCanDown(X1, Y1, Height, Width, Palubs)
                   else  // if TestCanDown(X1, Y1, Height, Width, Palubs)
                     if Y1 - Height * (Palubs - 1) > 0 then
                       if TestCanUp(X1, Y1, Height, Width, Palubs) then
                         begin
                           Result.fResult := True;
                           Result.fPlace := 'Up';
                         end   //if TestCanUp(X1, Y1, Height, Width, Palubs)
                       else   //if TestCanUp(X1, Y1, Height, Width, Palubs)
                         Result.fResult := False
                     else  //  if X1 - Height* (Palubs - 1) > 0
                       Result.fResult := False
                 else
                   if Y1 - Height * (Palubs - 1) > 0 then
                       if TestCanUp(X1, Y1, Height, Width, Palubs) then
                         begin
                           Result.fResult := True;
                           Result.fPlace := 'Up';
                         end   //if TestCanUp(X1, Y1, Height, Width, Palubs)
                       else   //if TestCanUp(X1, Y1, Height, Width, Palubs)
                         Result.fResult := False
                     else  //  if X1 - Height* (Palubs - 1) > 0
                       Result.fResult := False
               end;  // 2 ������������ ����
{�� 9 ���}   3:
               begin
                 if X1 - Width * (Palubs - 1) > 0 then
                   if TestCanLeft(X1, Y1, Height, Width, Palubs) then
                     begin
                       Result.fResult := True;
                       Result.fPlace := 'Left';
                     end  // if TestCanLeft(X1, Y1, Height, Width, Palubs)
                   else   // if TestCanLeft(X1, Y1, Height, Width, Palubs)
                     if X1 + Width * Palubs < 201 then
                       if TestCanRight(X1, Y1, Height, Width, Palubs) then
                         begin
                           Result.fResult := True;
                           Result.fPlace := 'Right';
                         end  //if TestCanRight(X1, Y1, Height, Width, Palubs)
                       else  // if TestCanRight(X1, Y1, Height, Width, Palubs)
                         Result.fResult := False
                     else   // if X1 + Width * Palubs < 201
                       Result.fResult := False
                 else
                   if X1 + Width * Palubs < 201 then
                       if TestCanRight(X1, Y1, Height, Width, Palubs) then
                         begin
                           Result.fResult := True;
                           Result.fPlace := 'Right';
                         end  //if TestCanRight(X1, Y1, Height, Width, Palubs)
                       else  // if TestCanRight(X1, Y1, Height, Width, Palubs)
                         Result.fResult := False
                     else   // if X1 + Width * Palubs < 201
                       Result.fResult := False
               end;  // 3
    end;
end;

procedure TfmMain.acLoadExecute(Sender: TObject);
{���� ����������� ���� �������}
var
  Ship: TShip;
  i, X, Y: Integer;
label
  toCheck4, toCheck3, toCheck2, toCheck1;
begin
  Randomize;
{===========����� 4-� �������==================================================}
  Fields[Comp].Kinds[4] := 1;

  toCheck4:
             X := random(201);
             Y := random(182);
             if FindBorder(X, Y) then
               with TestToCan(X, Y, Height, Width, 4, random(3)) do
               if fResult then
                 begin
                   Ship := Fields[Comp].AddShip; //�������� ����� ������
                   Ship.Sel.Shape := stRectangle;              //������ ��� �����
                   Ship.Sel.Brush.Color := ShipCol;
                   Ship.Kind := 4;
                   Ship.Live := 100;

                   if fPlace = 'Up' then
                     begin
                       Ship.X := X1;
                       Ship.Y := Y1 - 3 * Height;

                       Ship.Height := 4 * (Y2 - Y1);                                 //����������� ������ ��������������
                       Ship.Width := X2 - X1;                                  //����������� ������ ��������������
                     end
                   else if fPlace = 'Down' then
                          begin
                            Ship.X := X1;
                            Ship.Y := Y1;

                            Ship.Height := 4 * (Y2 - Y1);                                 //����������� ������ ��������������
                            Ship.Width := X2 - X1;                                  //����������� ������ ��������������
                          end
                        else if fPlace = 'Right' then
                               begin
                                 Ship.X := X1;
                                 Ship.Y := Y1;

                                 Ship.Height := (Y2 - Y1);                                 //����������� ������ ��������������
                                 Ship.Width := 4 * (X2 - X1);                                  //����������� ������ ��������������
                               end
                             else
                               begin
                                 Ship.X := X1 - 3 * Width;
                                 Ship.Y := Y1;

                                 Ship.Height := (Y2 - Y1);                                 //����������� ������ ��������������
                                 Ship.Width := 4 * (X2 - X1);                                  //����������� ������ ��������������
                               end;

                 //  Ship.Parent := pFiledComp;

                 end  // if TestToCan(X1, Y1, Height, Width, 4, random(3))
               else  //  if TestToCan(X1, Y1, Height, Width, 4, random(3))
                 goto toCheck4
           else //if FindBorder(random(201), random(182))
             goto toCheck4;

{===========����� 3-� �������==================================================}
 for i := 1 to 2 do
 begin
  Fields[Comp].Kinds[3] := 2;

  toCheck3:
             X := random(201);
             Y := random(182);
             if FindBorder(X, Y) then
               with TestToCan(X, Y, Height, Width, 3, random(3)) do
               if fResult then
                 begin
                   Ship := Fields[Comp].AddShip; //�������� ����� ������
                   Ship.Sel.Shape := stRectangle;              //������ ��� �����
                   Ship.Sel.Brush.Color := ShipCol;
                   Ship.Kind := 3;
                   Ship.Live := 100;

                   if fPlace = 'Up' then
                     begin
                       Ship.X := X1;
                       Ship.Y := Y1 - 2 * Height;

                       Ship.Height := 3 * (Y2 - Y1);                                 //����������� ������ ��������������
                       Ship.Width := X2 - X1;                                  //����������� ������ ��������������
                     end
                   else if fPlace = 'Down' then
                          begin
                            Ship.X := X1;
                            Ship.Y := Y1;

                            Ship.Height := 3 * (Y2 - Y1);                                 //����������� ������ ��������������
                            Ship.Width := X2 - X1;                                  //����������� ������ ��������������
                          end
                        else if fPlace = 'Right' then
                               begin
                                 Ship.X := X1;
                                 Ship.Y := Y1;

                                 Ship.Height := (Y2 - Y1);                                 //����������� ������ ��������������
                                 Ship.Width := 3 * (X2 - X1);                                  //����������� ������ ��������������
                               end
                             else
                               begin
                                 Ship.X := X1 - 2 * Width;
                                 Ship.Y := Y1;

                                 Ship.Height := (Y2 - Y1);                                 //����������� ������ ��������������
                                 Ship.Width := 3 * (X2 - X1);                                  //����������� ������ ��������������
                               end;

              //     Ship.Parent := pFiledComp;

                 end  // if TestToCan(X1, Y1, Height, Width, 4, random(3))
               else  //  if TestToCan(X1, Y1, Height, Width, 4, random(3))
                 goto toCheck3
           else //if FindBorder(random(201), random(182))
             goto toCheck3;
 end;


{===========����� 2-� �������==================================================}
 for i := 1 to 3 do
 begin
  Fields[Comp].Kinds[2] := 3;

  toCheck2:
             X := random(201);
             Y := random(182);
             if FindBorder(X, Y) then
               with TestToCan(X, Y, Height, Width, 2, random(3)) do
               if fResult then
                 begin
                   Ship := Fields[Comp].AddShip; //�������� ����� ������
                   Ship.Sel.Shape := stRectangle;              //������ ��� �����
                   Ship.Sel.Brush.Color := ShipCol;
                   Ship.Kind := 2;
                   Ship.Live := 100;

                   if fPlace = 'Up' then
                     begin
                       Ship.X := X1;
                       Ship.Y := Y1 - Height;

                       Ship.Height := 2 * (Y2 - Y1);                                 //����������� ������ ��������������
                       Ship.Width := X2 - X1;                                  //����������� ������ ��������������
                     end
                   else if fPlace = 'Down' then
                          begin
                            Ship.X := X1;
                            Ship.Y := Y1;

                            Ship.Height := 2 * (Y2 - Y1);                                 //����������� ������ ��������������
                            Ship.Width := X2 - X1;                                  //����������� ������ ��������������
                          end
                        else if fPlace = 'Right' then
                               begin
                                 Ship.X := X1;
                                 Ship.Y := Y1;

                                 Ship.Height := (Y2 - Y1);                                 //����������� ������ ��������������
                                 Ship.Width := 2 * (X2 - X1);                                  //����������� ������ ��������������
                               end
                             else
                               begin
                                 Ship.X := X1 - Width;
                                 Ship.Y := Y1;

                                 Ship.Height := (Y2 - Y1);                                 //����������� ������ ��������������
                                 Ship.Width := 2 * (X2 - X1);                                  //����������� ������ ��������������
                               end;

            //       Ship.Parent := pFiledComp;

                 end  // if TestToCan(X1, Y1, Height, Width, 4, random(3))
               else  //  if TestToCan(X1, Y1, Height, Width, 4, random(3))
                 goto toCheck2
           else //if FindBorder(random(201), random(182))
             goto toCheck2;
 end;


{===========����� 1-� �������==================================================}
 for i := 1 to 4 do
 begin
  Fields[Comp].Kinds[1] := 4;

  toCheck1:
             X := random(201);
             Y := random(182);
             if FindBorder(X, Y) then
               with TestToCan(X, Y, Height, Width, 1, random(3)) do
               if fResult then
                 begin
                   Ship := Fields[Comp].AddShip; //�������� ����� ������
                   Ship.Sel.Shape := stRectangle;              //������ ��� �����
                   Ship.Sel.Brush.Color := ShipCol;
                   Ship.Kind := 1;
                   Ship.Live := 100;

                   if fPlace = 'Up' then
                     begin
                       Ship.X := X1;
                       Ship.Y := Y1;

                       Ship.Height := (Y2 - Y1);                                 //����������� ������ ��������������
                       Ship.Width := X2 - X1;                                  //����������� ������ ��������������
                     end
                   else if fPlace = 'Down' then
                          begin
                            Ship.X := X1;
                            Ship.Y := Y1;

                            Ship.Height := (Y2 - Y1);                                 //����������� ������ ��������������
                            Ship.Width := X2 - X1;                                  //����������� ������ ��������������
                          end
                        else if fPlace = 'Right' then
                               begin
                                 Ship.X := X1;
                                 Ship.Y := Y1;

                                 Ship.Height := (Y2 - Y1);                                 //����������� ������ ��������������
                                 Ship.Width := (X2 - X1);                                  //����������� ������ ��������������
                               end
                             else
                               begin
                                 Ship.X := X1;
                                 Ship.Y := Y1;

                                 Ship.Height := (Y2 - Y1);                                 //����������� ������ ��������������
                                 Ship.Width := (X2 - X1);                                  //����������� ������ ��������������
                               end;

             //      Ship.Parent := pFiledComp;

                 end  // if TestToCan(X1, Y1, Height, Width, 4, random(3))
               else  //  if TestToCan(X1, Y1, Height, Width, 4, random(3))
                 goto toCheck1
           else //if FindBorder(random(201), random(182))
             goto toCheck1;
 end;

  RecToDown(Comp);
end;

function TfmMain.TestToFree(X, Y, Index: Integer): Boolean;
{������� ��� �� �� ���� ����� ��� ������� �������=======================}
var
  i: Integer;
begin
  Result := True;

  for i := 0 to Fields[Index].Count - 1 do
    if (X > Fields[Index][i].X)and(X < (Fields[Index][i].X + Fields[Index][i].Width))
       and(Y > Fields[Index][i].Y)and(Y < (Fields[Index][i].Y + Fields[Index][i].Height)) then
         Result := False;
end;

function TfmMain.FindBorder(X, Y: Integer): Boolean;
{���� ���� �������� ���� ����� ���������}
var
  i, j, MayBe: Integer;
  Ship: TShip;
label
  toEnd;
begin
  Result := True;

  if iFIeldComp.Canvas.Pixels[X, Y] <> clBlack then  //���� �������� �� �� �������
    begin
      if (not TestDiag(X, Y, Comp)) or (not TestToFree(X, Y, Comp)) then
            goto toEnd;

      for i := Y downto 0 do        //��� �� ������� ������� �������
          if iFIeldComp.Canvas.Pixels[X, i] = clBlack then
            begin
              Y1 := i;  //������� �������
              break;
            end;

        for i := X downto 0 do         //��� �� ����� ������� �������
          if iFIeldComp.Canvas.Pixels[i, Y] = clBlack then
            begin
              X1 := i;   //����� �������
              break;
            end;
                  //��� �� ������ ������� �������
        for i := X to iFIeldSelf.ClientWidth do
          if iFIeldComp.Canvas.Pixels[i, Y] = clBlack then
            begin
              X2 := i + 1;    //������ �������
              break;
            end;
                    //��� �� ������ ������� �������
        for i := Y to iFIeldSelf.ClientHeight do
          if iFIeldComp.Canvas.Pixels[X, i] = clBlack then
            begin
              Y2 := i + 1;   //������ �������
              break;
            end;
    end //  if iFIeldSelf.Canvas.Pixels[X, Y] <> clBlack
  else
    toEnd:      //���� ���� �   goto toEnd;
      begin
        Result := False;
      end;
end;

procedure TfmMain.FindBorderXY(X, Y: Integer);
var
  i: Integer;
begin
  for i := Y downto 0 do        //��� �� ������� ������� �������
    if iFIeldComp.Canvas.Pixels[X, i] = clBlack then
      begin
        Y1 := i;  //������� �������
        break;
      end;

  for i := X downto 0 do         //��� �� ����� ������� �������
    if iFIeldComp.Canvas.Pixels[i, Y] = clBlack then
      begin
        X1 := i;   //����� �������
        break;
      end;
                    //��� �� ������ ������� �������
  for i := X to iFIeldComp.ClientWidth do
    if iFIeldComp.Canvas.Pixels[i, Y] = clBlack then
      begin
        X2 := i + 1;    //������ �������
        break;
      end;
                      //��� �� ������ ������� �������
  for i := Y to iFIeldComp.ClientHeight do
    if iFIeldComp.Canvas.Pixels[X, i] = clBlack then
      begin
        Y2 := i + 1;   //������ �������
        break;
      end;
end;

function TfmMain.TestHaveMiss(X, Y, Index: Integer): Boolean;
{��������� ��� �� ��� ����� �������}
var
  i: Integer;
begin
  Result := False; //�� ����� �����

  for i := 0 to Shots[Index].Count - 1 do
    if (X >= Shots[Index][i].X)and(X < (Shots[Index][i].X + Shots[Index][i].Width))
       and(Y >= Shots[Index][i].Y)and(Y < (Shots[Index][i].Y + Shots[Index][i].Height)) then
         Result := True;   // �����
end;

procedure TfmMain.Wall(X1, Y1, Palubs, Direction, Index: Integer; Parent:TWinControl);
{������ ������ ������ ������� ������� ����}
var
  i, X, Y: Integer;
  Miss: TMiss;
begin
  case Direction of
{������������ }  0:
                   begin
                {=========== ����� ===========================}
                     X := X1;
                     Y := Y1;

                     Y := Y - Height;

                     if Y > 0 then
                       begin
                         X := X - Width;
                         if (X > 0)and(not TestHaveMiss(X, Y, Index)) then
                           begin
                             Miss := Shots[Index].AddMiss;
                             Miss.Lab.Alignment := taCenter;
                             Miss.Lab.AutoSize := False;
                             Miss.Lab.Font.Size := 20;
                             Miss.Lab.Caption := '''';

                             Miss.X := X;
                             Miss.Y := Y;
                             Miss.Height := Height;
                             Miss.Width := Width;
                             Miss.Parent := Parent;
                           end;  // if X > 0

                         X := X1;
                         X := X + Width;

                         if (X < 201)and(not TestHaveMiss(X, Y, Index)) then
                           begin
                             Miss := Shots[Index].AddMiss;
                             Miss.Lab.Alignment := taCenter;
                             Miss.Lab.AutoSize := False;
                             Miss.Lab.Font.Size := 20;
                             Miss.Lab.Caption := '''';

                             Miss.X := X;
                             Miss.Y := Y;
                             Miss.Height := Height;
                             Miss.Width := Width;
                             Miss.Parent := Parent;
                           end; // if X < 201 then

                         X := X1;
                           if not TestHaveMiss(X, Y, Index) then
                             begin
                               Miss := Shots[Index].AddMiss;
                               Miss.Lab.Alignment := taCenter;
                               Miss.Lab.AutoSize := False;
                               Miss.Lab.Font.Size := 20;
                               Miss.Lab.Caption := '''';

                               Miss.X := X;
                               Miss.Y := Y;
                               Miss.Height := Height;
                               Miss.Width := Width;
                               Miss.Parent := Parent;
                             end; // if not TestHaveMiss(X, Y, Index)
                       end; //  if Y > 0 then

                {=========== ����� ===========================}
                     X := X1;
                     Y := Y1;

                     for i := 1 to Palubs do
                       begin
                         Y := Y1 + Height * (i - 1);

                         X := X1;
                         X := X + Width;

                         if (X < 201)and(not TestHaveMiss(X, Y, Index)) then
                           begin
                             Miss := Shots[Index].AddMiss;
                             Miss.Lab.Alignment := taCenter;
                             Miss.Lab.AutoSize := False;
                             Miss.Lab.Font.Size := 20;
                             Miss.Lab.Caption := '''';

                             Miss.X := X;
                             Miss.Y := Y;
                             Miss.Height := Height;
                             Miss.Width := Width;
                             Miss.Parent := Parent;
                           end; // if X < 201 then

                         X := X1;
                         X := X - Width;

                         if (X > 0)and(not TestHaveMiss(X, Y, Index)) then
                           begin
                             Miss := Shots[Index].AddMiss;
                             Miss.Lab.Alignment := taCenter;
                             Miss.Lab.AutoSize := False;
                             Miss.Lab.Font.Size := 20;
                             Miss.Lab.Caption := '''';

                             Miss.X := X;
                             Miss.Y := Y;
                             Miss.Height := Height;
                             Miss.Width := Width;
                             Miss.Parent := Parent;
                           end; // if X < 201 then
                       end;  //  for i := 1 to Palubs

                  {=========== ��� ===========================}
                         Y := Y1 + Height * Palubs;
                         X := X1;

                        if Y < 182 then
                        begin
                         X := X - Width;
                         if (X > 0)and(not TestHaveMiss(X, Y, Index)) then
                           begin
                             Miss := Shots[Index].AddMiss;
                             Miss.Lab.Alignment := taCenter;
                             Miss.Lab.AutoSize := False;
                             Miss.Lab.Font.Size := 20;
                             Miss.Lab.Caption := '''';

                             Miss.X := X;
                             Miss.Y := Y;
                             Miss.Height := Height;
                             Miss.Width := Width;
                             Miss.Parent := Parent;
                           end;  // if X > 0

                         X := X1;
                         X := X + Width;

                         if (X < 201)and(not TestHaveMiss(X, Y, Index)) then
                           begin
                             Miss := Shots[Index].AddMiss;
                             Miss.Lab.Alignment := taCenter;
                             Miss.Lab.AutoSize := False;
                             Miss.Lab.Font.Size := 20;
                             Miss.Lab.Caption := '''';

                             Miss.X := X;
                             Miss.Y := Y;
                             Miss.Height := Height;
                             Miss.Width := Width;
                             Miss.Parent := Parent;
                           end; // if X < 201 then

                             X := X1;

                             Miss := Shots[Index].AddMiss;
                             Miss.Lab.Alignment := taCenter;
                             Miss.Lab.AutoSize := False;
                             Miss.Lab.Font.Size := 20;
                             Miss.Lab.Caption := '''';

                             Miss.X := X;
                             Miss.Y := Y;
                             Miss.Height := Height;
                             Miss.Width := Width;
                             Miss.Parent := Parent;
                       end; //  if Y < 182 then

                   end;  // 0  ������������
{��������������} 1:
                   begin
           {=========== ���� ===========================}
                     X := X1;
                     Y := Y1;

                     X := X - Width;

                     if X > 0 then
                       begin
                         Y := Y - Height;
                         if (Y > 0)and(not TestHaveMiss(X, Y, Index)) then
                           begin
                             Miss := Shots[Index].AddMiss;
                             Miss.Lab.Alignment := taCenter;
                             Miss.Lab.AutoSize := False;
                             Miss.Lab.Font.Size := 20;
                             Miss.Lab.Caption := '''';

                             Miss.X := X;
                             Miss.Y := Y;
                             Miss.Height := Height;
                             Miss.Width := Width;
                             Miss.Parent := Parent;
                           end;  // if X > 0

                         Y := Y1;
                         Y := Y + Height;

                         if (Y < 182)and(not TestHaveMiss(X, Y, Index)) then
                           begin
                             Miss := Shots[Index].AddMiss;
                             Miss.Lab.Alignment := taCenter;
                             Miss.Lab.AutoSize := False;
                             Miss.Lab.Font.Size := 20;
                             Miss.Lab.Caption := '''';

                             Miss.X := X;
                             Miss.Y := Y;
                             Miss.Height := Height;
                             Miss.Width := Width;
                             Miss.Parent := Parent;
                           end; // if Y < 182 then

                         Y := Y1;
                         if not TestHaveMiss(X, Y, Index) then
                           begin
                             Miss := Shots[Index].AddMiss;
                             Miss.Lab.Alignment := taCenter;
                             Miss.Lab.AutoSize := False;
                             Miss.Lab.Font.Size := 20;
                             Miss.Lab.Caption := '''';

                             Miss.X := X;
                             Miss.Y := Y;
                             Miss.Height := Height;
                             Miss.Width := Width;
                             Miss.Parent := Parent;
                           end; //if not TestHaveMiss(X, Y, Index)
                       end; //  if Y > 0 then

                {=========== ����� ===========================}
                     X := X1;
                     Y := Y1;

                     for i := 1 to Palubs do
                       begin
                         X := X1 + Width * (i - 1);

                         Y := Y1;
                         Y := Y + Height;

                         if (Y < 182)and(not TestHaveMiss(X, Y, Index)) then
                           begin
                             Miss := Shots[Index].AddMiss;
                             Miss.Lab.Alignment := taCenter;
                             Miss.Lab.AutoSize := False;
                             Miss.Lab.Font.Size := 20;
                             Miss.Lab.Caption := '''';

                             Miss.X := X;
                             Miss.Y := Y;
                             Miss.Height := Height;
                             Miss.Width := Width;
                             Miss.Parent := Parent;
                           end; // if Y < 182 then

                         Y := Y1;
                         Y := Y - Height;

                         if (Y > 0)and(not TestHaveMiss(X, Y, Index)) then
                           begin
                             Miss := Shots[Index].AddMiss;
                             Miss.Lab.Alignment := taCenter;
                             Miss.Lab.AutoSize := False;
                             Miss.Lab.Font.Size := 20;
                             Miss.Lab.Caption := '''';

                             Miss.X := X;
                             Miss.Y := Y;
                             Miss.Height := Height;
                             Miss.Width := Width;
                             Miss.Parent := Parent;
                           end; // if Y > 0  then
                       end;  //  for i := 1 to Palubs

                  {=========== ����� ===========================}
                         X := X1 + Width * Palubs;
                         Y := Y1;

                        if X < 201 then
                        begin
                         Y := Y - Height;
                         if (Y > 0)and(not TestHaveMiss(X, Y, Index)) then
                           begin
                             Miss := Shots[Index].AddMiss;
                             Miss.Lab.Alignment := taCenter;
                             Miss.Lab.AutoSize := False;
                             Miss.Lab.Font.Size := 20;
                             Miss.Lab.Caption := '''';

                             Miss.X := X;
                             Miss.Y := Y;
                             Miss.Height := Height;
                             Miss.Width := Width;
                             Miss.Parent := Parent;
                           end;  // if X > 0

                         Y := Y1;
                         Y := Y + Height;

                         if (Y < 182)and(not TestHaveMiss(X, Y, Index)) then
                           begin
                             Miss := Shots[Index].AddMiss;
                             Miss.Lab.Alignment := taCenter;
                             Miss.Lab.AutoSize := False;
                             Miss.Lab.Font.Size := 20;
                             Miss.Lab.Caption := '''';

                             Miss.X := X;
                             Miss.Y := Y;
                             Miss.Height := Height;
                             Miss.Width := Width;
                             Miss.Parent := Parent;
                           end; // if Y < 182 then

                             Y := Y1;
                             if not TestHaveMiss(X, Y, Index) then
                               begin
                                 Miss := Shots[Index].AddMiss;
                                 Miss.Lab.Alignment := taCenter;
                                 Miss.Lab.AutoSize := False;
                                 Miss.Lab.Font.Size := 20;
                                 Miss.Lab.Caption := '''';

                                 Miss.X := X;
                                 Miss.Y := Y;
                                 Miss.Height := Height;
                                 Miss.Width := Width;
                                 Miss.Parent := Parent;
                               end; //if not TestHaveMiss(X, Y, Index)
                       end; //  if X < 201 then

                   end;  // 1  ��������������
  end; //case
end;

procedure TfmMain.iFieldCompMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  i: Integer;
  Miss: TMiss;
  Missed: Boolean;
begin
if iFIeldComp.Canvas.Pixels[X, Y] <> clBlack then  //���� �������� �� �� �������
begin
  for i := 0 to Fields[Comp].Count - 1 do
    if (X > Fields[Comp][i].X)and(X < (Fields[Comp][i].X + Fields[Comp][i].Width))
       and(Y > Fields[Comp][i].Y)and(Y < (Fields[Comp][i].Y + Fields[Comp][i].Height)) then
         begin
           Missed := False;

           Miss := Shots[Comp].AddMiss;
           Miss.Lab.Alignment := taCenter;
           Miss.Lab.AutoSize := False;
           Miss.Lab.Font.Size := 12;
           Miss.Lab.Font.Style := [fsBold];
           Miss.Lab.Font.Color := clBlue;
           Miss.Lab.Caption := 'X';

           FindBorderXY(X, Y);

           Miss.X := X1;
           Miss.Y := Y1;
           Miss.Height := Height;
           Miss.Width := Width;
           Miss.Parent := pFiledComp;

           Fields[Comp][i].Live := Fields[Comp][i].Live - 100 / Fields[Comp][i].Kind;

             if Fields[Comp][i].Live < 1 then
               begin
                 Fields[Comp][i].Sel.Brush.Color := ShipDiedCol;
                 Fields[Comp][i].Parent := pFiledComp;

                 Fields[Comp].CountDead := Fields[Comp].CountDead + 1;

                 Fields[Comp].Kinds[Fields[Comp][i].Kind] := Fields[Comp].Kinds[Fields[Comp][i].Kind] - 1;
                 RecToDown(Comp);

                 if Fields[Comp][i].Height / Fields[Comp][i].Width >= 1.5 then  //������������
                   Wall(Fields[Comp][i].X, Fields[Comp][i].Y, Fields[Comp][i].Kind, 0, Comp, pFiledComp)
                 else             //��������������
                   Wall(Fields[Comp][i].X, Fields[Comp][i].Y, Fields[Comp][i].Kind, 1, Comp, pFiledComp);

                 if Fields[Comp].CountDead = 10 then
                   begin
                     Application.MessageBox('        �� ��������!        ', 'SeaWar', mrNone);
                     pFiledComp.Enabled := False;
                   end;
               end; //  if Fields[Comp][i].Live = 0

           break;
         end
       else
         Missed := True;

   if Missed then
     begin
       FindBorderXY(X, Y);

       Miss := Shots[Comp].AddMiss;
       Miss.Lab.Alignment := taCenter;
       Miss.Lab.AutoSize := False;
       Miss.Lab.Font.Size := 20;
       Miss.Lab.Caption := '''';

       Miss.X := X1;
       Miss.Y := Y1;
       Miss.Height := Height;
       Miss.Width := Width;
       Miss.Parent := pFiledComp;

       Shot;
     end;
end; //  if iFIeldSelf.Canvas.Pixels[X, Y] <> clBlack
end;

procedure TfmMain.Shot;
{���� ��������}
var
  X, Y, i: Integer;
  Missed: Boolean;
  Miss: TMiss;
label
  DoAgainShot, ToKill;
begin
  pFiledComp.Enabled := False;

  Randomize;

 ToKill:
  if CompShot.csInjured then
    begin
      case CompShot.csDirection.dDirect of
        0:
          begin
            {=================================== ����� ============================================}
            X := CompShot.csX0;
            Y := CompShot.csY0 - Height * CompShot.csPulubsKill;

            if Y > 0 then
              begin
                for i := 0 to Fields[Player].Count - 1 do
                if (X > Fields[Player][i].X)and(X < (Fields[Player][i].X + Fields[Player][i].Width))
                   and(Y > Fields[Player][i].Y)and(Y < (Fields[Player][i].Y + Fields[Player][i].Height)) then
                     begin
                       Missed := False;

                       Miss := Shots[Player].AddMiss;
                       Miss.Lab.Alignment := taCenter;
                       Miss.Lab.AutoSize := False;
                       Miss.Lab.Font.Size := 12;
                       Miss.Lab.Font.Style := [fsBold];
                       Miss.Lab.Font.Color := clBlue;
                       Miss.Lab.Caption := 'X';

                       FindBorderXY(X, Y);

                       Miss.X := X1;
                       Miss.Y := Y1;
                       Miss.Height := Height;
                       Miss.Width := Width;
                       Miss.Parent := pFiledSelf;

                       Fields[Player][i].Live := Fields[Player][i].Live - 100 / Fields[Player][i].Kind;

                       if Fields[Player][i].Live > 1 then
                         CompShot.csPulubsKill := CompShot.csPulubsKill + 1;

                       if Fields[Player][i].Live < 1 then
                           begin
                             Fields[Player][i].Sel.Pen.Mode := pmCopy;
                             Fields[Player][i].Sel.Brush.Color := ShipDiedCol;

                             Fields[Player].CountDead := Fields[Player].CountDead + 1;

                             Fields[Player].Kinds[Fields[Player][i].Kind] := Fields[Player].Kinds[Fields[Player][i].Kind] - 1;
                             RecToDown(Player);

                             CompShot.csInjured := False;

                             if Fields[Player][i].Height / Fields[Player][i].Width >= 1.5 then  //������������
                               Wall(Fields[Player][i].X, Fields[Player][i].Y, Fields[Player][i].Kind, 0, Player, pFiledSelf)
                             else             //��������������
                               Wall(Fields[Player][i].X, Fields[Player][i].Y, Fields[Player][i].Kind, 1, Player, pFiledSelf);
                             if Fields[Player].CountDead = 10 then
                               begin
                                Loser;

                                Exit;
                              end;
                           end; //  if Fields[Comp][i].Live = 0

                        break;   
                     end   //if (X > Fields[Player][i].X)and(X < (Fields[Player][i].X + Fields[Player][i].Width))
                else
                  Missed := True;

                  if not Missed then
                    goto ToKill
                  else
                    begin
                      if TestHaveMiss(X, Y, Player) then
                        begin
                          CompShot.csDirection.d0 := True;

                          if not CompShot.csDirection.d2 then
                            CompShot.csDirection.dDirect := 2
                          else if not CompShot.csDirection.d1 then
                                 CompShot.csDirection.dDirect := 1
                               else
                                 CompShot.csDirection.dDirect := 3;

                          CompShot.csPulubsKill := 1;

                          goto ToKill;
                        end
                      else  //if TestHaveMiss(X, Y, Player)
                        begin
                          CompShot.csDirection.d0 := True;
                          if not CompShot.csDirection.d2 then
                                CompShot.csDirection.dDirect := 2
                              else if not CompShot.csDirection.d1 then
                                     CompShot.csDirection.dDirect := 1
                                   else
                                     CompShot.csDirection.dDirect := 3;

                          CompShot.csPulubsKill := 1;

                          FindBorderXY(X, Y);

                          Miss := Shots[Player].AddMiss;
                          Miss.Lab.Alignment := taCenter;
                          Miss.Lab.AutoSize := False;
                          Miss.Lab.Font.Size := 20;
                          Miss.Lab.Caption := '''';

                          Miss.X := X1;
                          Miss.Y := Y1;
                          Miss.Height := Height;
                          Miss.Width := Width;
                          Miss.Parent := pFiledSelf;
                     //     SHowMessage('asdf');
                        end; //else   if TestHaveMiss(X, Y, Player)
                    end;//else
              end // Y > 0
            else  // Y > 0
              begin
                CompShot.csDirection.d0 := True;
                if not CompShot.csDirection.d2 then
                   CompShot.csDirection.dDirect := 2
                   else if not CompShot.csDirection.d1 then
                          CompShot.csDirection.dDirect := 1
                        else
                          CompShot.csDirection.dDirect := 3;

                 CompShot.csPulubsKill := 1;

                 goto ToKill;
              end; //else
          end;  // 0 �����
        1:
          begin
          {========================= ������ =================================================}
            X := CompShot.csX0 + Width * CompShot.csPulubsKill;
            Y := CompShot.csY0;

            if X < 201 then
              begin
                for i := 0 to Fields[Player].Count - 1 do
                if (X > Fields[Player][i].X)and(X < (Fields[Player][i].X + Fields[Player][i].Width))
                   and(Y > Fields[Player][i].Y)and(Y < (Fields[Player][i].Y + Fields[Player][i].Height)) then
                     begin
                       Missed := False;

                       Miss := Shots[Player].AddMiss;
                       Miss.Lab.Alignment := taCenter;
                       Miss.Lab.AutoSize := False;
                       Miss.Lab.Font.Size := 12;
                       Miss.Lab.Font.Style := [fsBold];
                       Miss.Lab.Font.Color := clBlue;
                       Miss.Lab.Caption := 'X';

                       FindBorderXY(X, Y);

                       Miss.X := X1;
                       Miss.Y := Y1;
                       Miss.Height := Height;
                       Miss.Width := Width;
                       Miss.Parent := pFiledSelf;

                       Fields[Player][i].Live := Fields[Player][i].Live - 100 / Fields[Player][i].Kind;

                       if Fields[Player][i].Live > 1 then
                         CompShot.csPulubsKill := CompShot.csPulubsKill + 1;

                       if Fields[Player][i].Live < 1 then
                           begin
                             Fields[Player][i].Sel.Pen.Mode := pmCopy;
                             Fields[Player][i].Sel.Brush.Color := ShipDiedCol;

                             Fields[Player].CountDead := Fields[Player].CountDead + 1;

                             Fields[Player].Kinds[Fields[Player][i].Kind] := Fields[Player].Kinds[Fields[Player][i].Kind] - 1;
                             RecToDown(Player);

                             CompShot.csInjured := False;

                             if Fields[Player][i].Height / Fields[Player][i].Width >= 1.5 then  //������������
                               Wall(Fields[Player][i].X, Fields[Player][i].Y, Fields[Player][i].Kind, 0, Player, pFiledSelf)
                             else             //��������������
                               Wall(Fields[Player][i].X, Fields[Player][i].Y, Fields[Player][i].Kind, 1, Player, pFiledSelf);

                             if Fields[Player].CountDead = 10 then
                               begin
                                Loser;

                                Exit;
                              end;
                           end; //  if Fields[Comp][i].Live = 0

                        break;   
                     end   //if (X > Fields[Player][i].X)and(X < (Fields[Player][i].X + Fields[Player][i].Width))
                else
                  Missed := True;

                  if not Missed then
                    goto ToKill
                  else
                    begin
                      if TestHaveMiss(X, Y, Player) then
                        begin
                          CompShot.csDirection.d1 := True;

                          if not CompShot.csDirection.d2 then
                            CompShot.csDirection.dDirect := 2
                          else if not CompShot.csDirection.d0 then
                                 CompShot.csDirection.dDirect := 0
                               else
                                 CompShot.csDirection.dDirect := 3;

                          CompShot.csPulubsKill := 1;

                          goto ToKill;
                        end
                      else  //if TestHaveMiss(X, Y, Player)
                        begin
                          CompShot.csDirection.d1 := True;
                          if not CompShot.csDirection.d2 then
                                CompShot.csDirection.dDirect := 2
                              else if not CompShot.csDirection.d0 then
                                     CompShot.csDirection.dDirect := 0
                                   else
                                     CompShot.csDirection.dDirect := 3;

                          CompShot.csPulubsKill := 1;

                          FindBorderXY(X, Y);

                          Miss := Shots[Player].AddMiss;
                          Miss.Lab.Alignment := taCenter;
                          Miss.Lab.AutoSize := False;
                          Miss.Lab.Font.Size := 20;
                          Miss.Lab.Caption := '''';

                          Miss.X := X1;
                          Miss.Y := Y1;
                          Miss.Height := Height;
                          Miss.Width := Width;
                          Miss.Parent := pFiledSelf;
                     //     SHowMessage('asdf');
                        end; //else   if TestHaveMiss(X, Y, Player)
                    end;//else
              end // X < 201
            else  // X < 201
              begin
                CompShot.csDirection.d1 := True;
                if not CompShot.csDirection.d2 then
                   CompShot.csDirection.dDirect := 2
                   else if not CompShot.csDirection.d0 then
                          CompShot.csDirection.dDirect := 0
                        else
                          CompShot.csDirection.dDirect := 3;

                 CompShot.csPulubsKill := 1;

                 goto ToKill;
              end; //else
          end;
        2:
          begin
  {========================= ���� =================================================}
            X := CompShot.csX0;
            Y := CompShot.csY0 + Height * CompShot.csPulubsKill;

            if Y < 182 then
              begin
                for i := 0 to Fields[Player].Count - 1 do
                if (X > Fields[Player][i].X)and(X < (Fields[Player][i].X + Fields[Player][i].Width))
                   and(Y > Fields[Player][i].Y)and(Y < (Fields[Player][i].Y + Fields[Player][i].Height)) then
                     begin
                       Missed := False;

                       Miss := Shots[Player].AddMiss;
                       Miss.Lab.Alignment := taCenter;
                       Miss.Lab.AutoSize := False;
                       Miss.Lab.Font.Size := 12;
                       Miss.Lab.Font.Style := [fsBold];
                       Miss.Lab.Font.Color := clBlue;
                       Miss.Lab.Caption := 'X';

                       FindBorderXY(X, Y);

                       Miss.X := X1;
                       Miss.Y := Y1;
                       Miss.Height := Height;
                       Miss.Width := Width;
                       Miss.Parent := pFiledSelf;

                       Fields[Player][i].Live := Fields[Player][i].Live - 100 / Fields[Player][i].Kind;

                       if Fields[Player][i].Live > 1 then
                         CompShot.csPulubsKill := CompShot.csPulubsKill + 1;

                       if Fields[Player][i].Live < 1 then
                           begin
                             Fields[Player][i].Sel.Pen.Mode := pmCopy;
                             Fields[Player][i].Sel.Brush.Color := ShipDiedCol;

                             Fields[Player].CountDead := Fields[Player].CountDead + 1;

                             Fields[Player].Kinds[Fields[Player][i].Kind] := Fields[Player].Kinds[Fields[Player][i].Kind] - 1;
                             RecToDown(Player);

                             CompShot.csInjured := False;

                             if Fields[Player][i].Height / Fields[Player][i].Width >= 1.5 then  //������������
                               Wall(Fields[Player][i].X, Fields[Player][i].Y, Fields[Player][i].Kind, 0, Player, pFiledSelf)
                             else             //��������������
                               Wall(Fields[Player][i].X, Fields[Player][i].Y, Fields[Player][i].Kind, 1, Player, pFiledSelf);

                             if Fields[Player].CountDead = 10 then
                               begin
                                Loser;

                                Exit;
                              end;
                           end; //  if Fields[Comp][i].Live = 0

                        break;   
                     end   //if (X > Fields[Player][i].X)and(X < (Fields[Player][i].X + Fields[Player][i].Width))
                else
                  Missed := True;

                  if not Missed then
                    goto ToKill
                  else
                    begin
                      if TestHaveMiss(X, Y, Player) then
                        begin
                          CompShot.csDirection.d2 := True;

                          if not CompShot.csDirection.d0 then
                            CompShot.csDirection.dDirect := 0
                          else if not CompShot.csDirection.d1 then
                                 CompShot.csDirection.dDirect := 1
                               else
                                 CompShot.csDirection.dDirect := 3;

                          CompShot.csPulubsKill := 1;

                          goto ToKill;
                        end
                      else  //if TestHaveMiss(X, Y, Player)
                        begin
                          CompShot.csDirection.d2 := True;
                          if not CompShot.csDirection.d0 then
                                CompShot.csDirection.dDirect := 0
                              else if not CompShot.csDirection.d1 then
                                     CompShot.csDirection.dDirect := 1
                                   else
                                     CompShot.csDirection.dDirect := 3;

                          CompShot.csPulubsKill := 1;

                          FindBorderXY(X, Y);

                          Miss := Shots[Player].AddMiss;
                          Miss.Lab.Alignment := taCenter;
                          Miss.Lab.AutoSize := False;
                          Miss.Lab.Font.Size := 20;
                          Miss.Lab.Caption := '''';

                          Miss.X := X1;
                          Miss.Y := Y1;
                          Miss.Height := Height;
                          Miss.Width := Width;
                          Miss.Parent := pFiledSelf;
                      //    SHowMessage('asdf');
                        end; //else   if TestHaveMiss(X, Y, Player)
                    end;//else
              end // Y <182
            else  // Y < 182
              begin
                CompShot.csDirection.d2 := True;
                if not CompShot.csDirection.d0 then
                   CompShot.csDirection.dDirect := 0
                   else if not CompShot.csDirection.d1 then
                          CompShot.csDirection.dDirect := 1
                        else
                          CompShot.csDirection.dDirect := 3;

                 CompShot.csPulubsKill := 1;

                 goto ToKill;
              end; //else
          end;
        3:
          begin
          {========================= ���� =================================================}
            X := CompShot.csX0 - Width * CompShot.csPulubsKill;
            Y := CompShot.csY0;

            if X > 0 then
              begin
                for i := 0 to Fields[Player].Count - 1 do
                if (X > Fields[Player][i].X)and(X < (Fields[Player][i].X + Fields[Player][i].Width))
                   and(Y > Fields[Player][i].Y)and(Y < (Fields[Player][i].Y + Fields[Player][i].Height)) then
                     begin
                       Missed := False;

                       Miss := Shots[Player].AddMiss;
                       Miss.Lab.Alignment := taCenter;
                       Miss.Lab.AutoSize := False;
                       Miss.Lab.Font.Size := 12;
                       Miss.Lab.Font.Style := [fsBold];
                       Miss.Lab.Font.Color := clBlue;
                       Miss.Lab.Caption := 'X';

                       FindBorderXY(X, Y);

                       Miss.X := X1;
                       Miss.Y := Y1;
                       Miss.Height := Height;
                       Miss.Width := Width;
                       Miss.Parent := pFiledSelf;

                       Fields[Player][i].Live := Fields[Player][i].Live - 100 / Fields[Player][i].Kind;

                       if Fields[Player][i].Live > 1 then
                         CompShot.csPulubsKill := CompShot.csPulubsKill + 1;

                       if Fields[Player][i].Live < 1 then
                           begin
                             Fields[Player][i].Sel.Pen.Mode := pmCopy;
                             Fields[Player][i].Sel.Brush.Color := ShipDiedCol;

                             Fields[Player].CountDead := Fields[Player].CountDead + 1;

                             Fields[Player].Kinds[Fields[Player][i].Kind] := Fields[Player].Kinds[Fields[Player][i].Kind] - 1;
                             RecToDown(Player);

                             CompShot.csInjured := False;

                             if Fields[Player][i].Height / Fields[Player][i].Width >= 1.5 then  //������������
                               Wall(Fields[Player][i].X, Fields[Player][i].Y, Fields[Player][i].Kind, 0, Player, pFiledSelf)
                             else             //��������������
                               Wall(Fields[Player][i].X, Fields[Player][i].Y, Fields[Player][i].Kind, 1, Player, pFiledSelf);

                             if Fields[Player].CountDead = 10 then
                               begin
                                Loser;

                                Exit;
                              end;
                           end; //  if Fields[Comp][i].Live = 0

                        break;   
                     end   //if (X > Fields[Player][i].X)and(X < (Fields[Player][i].X + Fields[Player][i].Width))
                else
                  Missed := True;

                  if not Missed then
                    goto ToKill
                  else
                    begin
                      if TestHaveMiss(X, Y, Player) then
                        begin
                          CompShot.csDirection.d3 := True;

                          if not CompShot.csDirection.d0 then
                            CompShot.csDirection.dDirect := 0
                          else if not CompShot.csDirection.d1 then
                                 CompShot.csDirection.dDirect := 1
                               else
                                 CompShot.csDirection.dDirect := 2;

                          CompShot.csPulubsKill := 1;

                          goto ToKill;
                        end
                      else  //if TestHaveMiss(X, Y, Player)
                        begin
                          CompShot.csDirection.d3 := True;
                          if not CompShot.csDirection.d2 then
                                CompShot.csDirection.dDirect := 2
                              else if not CompShot.csDirection.d1 then
                                     CompShot.csDirection.dDirect := 1
                                   else
                                     CompShot.csDirection.dDirect := 0;

                          CompShot.csPulubsKill := 1;

                          FindBorderXY(X, Y);

                          Miss := Shots[Player].AddMiss;
                          Miss.Lab.Alignment := taCenter;
                          Miss.Lab.AutoSize := False;
                          Miss.Lab.Font.Size := 20;
                          Miss.Lab.Caption := '''';

                          Miss.X := X1;
                          Miss.Y := Y1;
                          Miss.Height := Height;
                          Miss.Width := Width;
                          Miss.Parent := pFiledSelf;
                      //    SHowMessage('asdf');
                        end; //else   if TestHaveMiss(X, Y, Player)
                    end;//else
              end // X < 201
            else  // X < 201
              begin
                CompShot.csDirection.d3 := True;
                if not CompShot.csDirection.d2 then
                   CompShot.csDirection.dDirect := 2
                   else if not CompShot.csDirection.d1 then
                          CompShot.csDirection.dDirect := 1
                        else
                          CompShot.csDirection.dDirect := 0;

                 CompShot.csPulubsKill := 1;

                 goto ToKill;
              end; //else
          end;
      end; //case
    end
  else
    begin
  DoAgainShot:
     X := random(201);   Y := random(182);
     if iFIeldSelf.Canvas.Pixels[X, Y] <> clBlack then  //���� �������� �� �� �������
      if not TestHaveMiss(X, Y, Player) then
        begin

          for i := 0 to Fields[Player].Count - 1 do
            if (X > Fields[Player][i].X)and(X < (Fields[Player][i].X + Fields[Player][i].Width))
               and(Y > Fields[Player][i].Y)and(Y < (Fields[Player][i].Y + Fields[Player][i].Height)) then
                 begin
                   Missed := False;

                   Fields[Player][i].Sel.Pen.Mode := pmMask;

                   Miss := Shots[Player].AddMiss;
                   Miss.Lab.Alignment := taCenter;
                   Miss.Lab.AutoSize := False;
                   Miss.Lab.Font.Size := 12;
                   Miss.Lab.Font.Style := [fsBold];
                   Miss.Lab.Font.Color := clBlue;
                   Miss.Lab.Caption := 'X';

                   FindBorderXY(X, Y);

                   Miss.X := X1;
                   Miss.Y := Y1;
                   Miss.Height := Height;
                   Miss.Width := Width;
                   Miss.Parent := pFiledSelf;

                   Fields[Player][i].Live := Fields[Player][i].Live - 100 / Fields[Player][i].Kind;

                   if Fields[Player][i].Live >1 then
                    begin
                      CompShot.csInjured := True;

                      CompShot.csX0 := X;
                      CompShot.csY0 := Y;

                      CompShot.csDirection.dDirect := 0;
                      CompShot.csDirection.d0 := True;
                      CompShot.csDirection.d1 := False;
                      CompShot.csDirection.d2 := False;
                      CompShot.csDirection.d3 := False;
                      
                      CompShot.csPulubsKill := 1;
                    end;

                     if Fields[Player][i].Live < 1 then
                       begin
                         Fields[Player][i].Sel.Pen.Mode := pmCopy;
                         Fields[Player][i].Sel.Brush.Color := ShipDiedCol;

                         Fields[Player].CountDead := Fields[Player].CountDead + 1;

                         Fields[Player].Kinds[Fields[Player][i].Kind] := Fields[Player].Kinds[Fields[Player][i].Kind] - 1;
                         RecToDown(Player);

                         if Fields[Player][i].Height / Fields[Player][i].Width >= 1.5 then  //������������
                           Wall(Fields[Player][i].X, Fields[Player][i].Y, Fields[Player][i].Kind, 0, Player, pFiledSelf)
                         else             //��������������
                           Wall(Fields[Player][i].X, Fields[Player][i].Y, Fields[Player][i].Kind, 1, Player, pFiledSelf);

                         if Fields[Player].CountDead = 10 then
                           begin
                             Loser;

                             Exit;
                           end;
                       end; //  if Fields[Comp][i].Live = 0

                   break;
                 end   //if (X > Fields[Comp][i].X)and(X < (Fields[Comp][i].X + Fields[Comp][i].Width))
               else
                 Missed := True;

            if not Missed then
              goto ToKill
            else
              begin
                FindBorderXY(X, Y);

                Miss := Shots[Player].AddMiss;
                Miss.Lab.Alignment := taCenter;
                Miss.Lab.AutoSize := False;
                Miss.Lab.Font.Size := 20;
                Miss.Lab.Caption := '''';

                Miss.X := X1;
                Miss.Y := Y1;
                Miss.Height := Height;
                Miss.Width := Width;
                Miss.Parent := pFiledSelf;
              //  SHowMessage('asdf');
              end;
        end    // if not TestHaveMiss(X, Y, Player)
      else   //if not TestHaveMiss(X, Y, Player)
        goto DoAgainShot
     else  //if iFIeldSelf.Canvas.Pixels[X, Y] <> clBlack then  //���� �������� �� �� �������
       goto DoAgainShot;
    end;  // else  if CompShot.csInjured

  pFiledComp.Enabled := True;  
end;

procedure TfmMain.Loser;
{����� ��������}
var
  i: Integer;
begin
  Application.MessageBox('        �� ���������!        ', 'SeaWar', mrNone);
  pFiledComp.Enabled := False;

  for i := 0 to Fields[Comp].Count - 1 do
    Fields[Comp][i].Parent := pFiledComp;
end;

procedure TfmMain.Action1Execute(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to Fields[Comp].Count - 1 do
    Fields[Comp][i].Parent := nil;
end;

procedure TfmMain.Action2Execute(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to Fields[Comp].Count - 1 do
    Fields[Comp][i].Parent := pFiledComp;
end;

{ TMisses }

function TMisses.AddMiss: TMiss;
begin
  Result := TMiss.Create(Self);         //�������� �����������
  FMisses.Add(Result);
end;

procedure TMisses.Clear;
var
  i: Integer;
begin
  for i := Count - 1 downto 0 do
    Delete(i);
end;

constructor TMisses.Create;
begin
  inherited;

  FMisses := TList.Create;
end;

procedure TMisses.Delete(Index: Integer);
begin
  if Index > -1 then
  begin
    Misses[Index].Lab.Free;  //������� �������
    FMisses.Delete(Index);
  end;
end;

function TMisses.GetCount: Integer;
begin
  Result := FMisses.Count;
end;

function TMisses.GetMiss(Index: Integer): TMiss;
begin
  Result := FMisses[Index];
end;

function TMisses.IndexOf(Miss: TMiss): Integer;
begin
  Result := FMisses.IndexOf(Miss)
end;

{ TMiss }

constructor TMiss.Create(Misses: TMisses);
begin
  inherited Create;

  FLab := TLabel.Create(nil);      //������� �������
  FLab.Tag := Integer(Self);
end;

destructor TMiss.Destroy;
begin
  FLab.Free;                       //���������� �������������

  inherited;
end;

function TMiss.GetParent: TWinControl;
begin
  Result := FLab.Parent;
end;

procedure TMiss.SetHeight(const Value: Integer);
begin
  if Value = FHeight then Exit;

  FHeight := Value;   //���������� � ��� ���� ������ �������
  FLab.Height := FHeight;
end;

procedure TMiss.SetParent(const Value: TWinControl);
begin
  FLab.Parent := Value;
end;

procedure TMiss.SetWidth(const Value: Integer);
begin
  if Value = FWidth then Exit;

  FWidth := Value;                //���������� � ��� ���� ������ �������
  FLab.Width := FWidth;
end;

procedure TMiss.SetX(const Value: Integer);
begin
  if Value = FX then Exit;

  FX := Value;                //���������� ����� �������
  FLab.Left := Value;
end;

procedure TMiss.SetY(const Value: Integer);
begin
  if Value = FY then Exit;

  FY := Value;                //���������� ������� �������
  FLab.Top := Value;
end;

procedure TfmMain.acAboutExecute(Sender: TObject);
begin
  fmAbout.ShowModal;
end;

procedure TfmMain.Action3Execute(Sender: TObject);
begin
  sbStat.Panels.Items[0].Text := IntToStr(Shots[1].Count);
  sbStat.Panels.Items[1].Text := IntToStr(Shots[2].Count);
end;

procedure TfmMain.ServerSocketClientConnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  if ServerSocket.Socket.ActiveConnections > 1 then
    ServerSocket.Socket.Connections[ServerSocket.Socket.ActiveConnections - 1].Disconnect(
      ServerSocket.Socket.Connections[ServerSocket.Socket.ActiveConnections - 1].SocketHandle);
end;

procedure TfmMain.ServerSocketClientDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
var
  Msg: TUDPMessage;
begin
  sgField.Enabled := False;
  sbMain.Panels[0].Text := '�������� �����������...';
  sbMain.Panels[1].Text := '';
  ClearField;
  Gaming := False;
  AlignTitle(Gaming);

  try
    Msg.MsgType := udpCreateServer;
    Msg.Gaming := False;

    UDPServer.SendBuffer('255.255.255.255', UDP_CLIENT_PORT, Msg, SizeOf(Msg));
    UDPServer.SendBuffer('127.0.0.1', UDP_CLIENT_PORT, Msg, SizeOf(Msg));
  except
    UDPServer.SendBuffer('127.0.0.1', UDP_CLIENT_PORT, Msg, SizeOf(Msg));
  end;
end;

end.
