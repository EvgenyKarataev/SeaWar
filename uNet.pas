unit uNet;

interface

uses SysUtils, WinSock;

function GetHostByIP(IP: string): string;

implementation

function GetHostByIP(IP: string): string;
var
  SockAddrIn: TSockAddrIn;
  HostEnt: PHostEnt;
  WSAData: TWSAData;
begin
  Result := '';
  WSAStartup($101, WSAData);
  SockAddrIn.sin_addr.s_addr := inet_addr(PChar(IP));
  HostEnt := gethostbyaddr(@SockAddrIn.sin_addr.S_addr, 4, AF_INET);
  if HostEnt <> nil then Result := StrPas(Hostent^.h_name)
end;

end.
