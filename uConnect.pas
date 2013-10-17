unit uConnect;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ActnList, uMain, ExtCtrls, IdBaseComponent,
  IdComponent, IdUDPBase, IdUDPClient, IdUDPServer, IdSocketHandle,
  IdAntiFreezeBase, IdAntiFreeze;

type
  TfmConnect = class(TForm)
    ActionList: TActionList;
    acOk: TAction;
    acCancel: TAction;
    acRefreshServers: TAction;
    AntiFreeze: TIdAntiFreeze;
    UDPClient: TIdUDPServer;
    Label1: TLabel;
    lvServers: TListView;
    ledServer: TLabeledEdit;
    bRefreshServers: TButton;
    bOk: TButton;
    bCancel: TButton;
    procedure FormShow(Sender: TObject);
    procedure acOkExecute(Sender: TObject);
    procedure ActionListUpdate(Action: TBasicAction; var Handled: Boolean);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure UDPClientUDPRead(Sender: TObject; AData: TStream;
      ABinding: TIdSocketHandle);
    procedure acCancelExecute(Sender: TObject);
    procedure lvServersSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure lvServersDblClick(Sender: TObject);
    procedure acRefreshServersExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }

    GameServer: TGameServer;
  end;

var
  fmConnect: TfmConnect;

implementation

{$R *.dfm}

uses uNet;

const
  GamingText: array[Boolean] of string = ('Нет', 'Да');

procedure TfmConnect.FormShow(Sender: TObject);
var
  i: Integer;
  Msg: TUDPMessage;
begin
  Self.Left := (Screen.Width - Self.Width) div 2;
  Self.Top := (Screen.Height - Self.Height) div 2;

  for i := 0 to lvServers.Items.Count - 1 do
    if lvServers.Items[i].Data <> nil then Dispose(lvServers.Items[i].Data);
  lvServers.Clear;
  lvServers.SetFocus;

  UDPClient.Active := True;

  try
    Msg.ID := GAMEGUID;
    Msg.MsgType := udpFindServer;
    Msg.ServerName := '';

    UDPClient.SendBuffer('255.255.255.255', UDP_SERVER_PORT, Msg, SizeOf(Msg));
    Sleep(Random(100));
    UDPClient.SendBuffer('255.255.255.255', UDP_SERVER_PORT, Msg, SizeOf(Msg));
    UDPClient.SendBuffer('127.0.0.1', UDP_SERVER_PORT, Msg, SizeOf(Msg));    
  except
    UDPClient.SendBuffer('127.0.0.1', UDP_SERVER_PORT, Msg, SizeOf(Msg));
  end;
end;

procedure TfmConnect.acOkExecute(Sender: TObject);
begin
  if not acOk.Enabled then Exit;

  if lvServers.Selected <> nil then
    GameServer := TGameServer(lvServers.Selected.Data^)
  else
    begin
      GameServer.Name := '';
      GameServer.Host := ledServer.Text;
      GameServer.IP := ledServer.Text;
    end;

  Self.ModalResult := mrOk;
end;

procedure TfmConnect.ActionListUpdate(Action: TBasicAction;
  var Handled: Boolean);
begin
  acOk.Enabled := ((lvServers.Selected <> nil) and not PGameServer(lvServers.Selected.Data)^.Gaming)
    or (ledServer.Text <> '');
end;

procedure TfmConnect.FormDestroy(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to lvServers.Items.Count - 1 do
    if lvServers.Items[i].Data <> nil then Dispose(lvServers.Items[i].Data);
end;

procedure TfmConnect.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  UDPClient.Active := False;
end;

procedure TfmConnect.FormCreate(Sender: TObject);
begin
  Randomize;
  UDPClient.DefaultPort := UDP_CLIENT_PORT;
end;

procedure TfmConnect.UDPClientUDPRead(Sender: TObject; AData: TStream;
  ABinding: TIdSocketHandle);
var
  Msg: TUDPMessage;
  i: Integer;
  GameServer: PGameServer;
begin
  if AData.Size <> SizeOf(Msg) then Exit;
  AData.Position := 0;
  AData.ReadBuffer(Msg, SizeOf(Msg));

  case Msg.MsgType of
  udpFindServer, udpCreateServer:
    begin
      for i := 0 to lvServers.Items.Count - 1 do
        if PGameServer(lvServers.Items[i].Data)^.IP = ABinding.PeerIP then
          begin
            PGameServer(lvServers.Items[i].Data)^.Gaming := Msg.Gaming; 
            Exit;
          end;

      with lvServers.Items.Add do
        begin
          Caption := Msg.ServerName;
          SubItems.Add(ABinding.PeerIP);
          SubItems.Add(GamingText[Msg.Gaming]);

          New(GameServer);
          GameServer^.Name := Msg.ServerName;
          GameServer^.Host := GetHostByIP(ABinding.PeerIP);
          GameServer^.IP := ABinding.PeerIP;
          GameServer^.Gaming := Msg.Gaming;

          Data := GameServer;
        end;
    end;
  udpCloseServer:
    begin
      for i := 0 to lvServers.Items.Count - 1 do
        if PGameServer(lvServers.Items[i].Data).IP = ABinding.PeerIP then
          begin
            if lvServers.Items[i].Data <> nil then Dispose(lvServers.Items[i].Data);
            lvServers.Items.Delete(i);
            Exit
          end;
    end;
  end;
end;

procedure TfmConnect.acCancelExecute(Sender: TObject);
begin
  Self.ModalResult := mrCancel
end;

procedure TfmConnect.lvServersSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  if not Self.Visible then Exit;
  
  if Item = nil then ledServer.Text := ''
    else ledServer.Text := PGameServer(Item.Data)^.IP;
end;

procedure TfmConnect.lvServersDblClick(Sender: TObject);
begin
  acOk.Execute;
end;

procedure TfmConnect.acRefreshServersExecute(Sender: TObject);
var
  i: Integer;
  Msg: TUDPMessage;
begin
  for i := 0 to lvServers.Items.Count - 1 do
    if lvServers.Items[i].Data <> nil then Dispose(lvServers.Items[i].Data);
  lvServers.Clear;

  try
    Msg.ID := GAMEGUID;
    Msg.MsgType := udpFindServer;
    Msg.ServerName := '';

    UDPClient.SendBuffer('255.255.255.255', UDP_SERVER_PORT, Msg, SizeOf(Msg));
    Sleep(Random(100));
    UDPClient.SendBuffer('255.255.255.255', UDP_SERVER_PORT, Msg, SizeOf(Msg));
    UDPClient.SendBuffer('127.0.0.1', UDP_SERVER_PORT, Msg, SizeOf(Msg));    
  except
    UDPClient.SendBuffer('127.0.0.1', UDP_SERVER_PORT, Msg, SizeOf(Msg));
  end;
end;

end.
