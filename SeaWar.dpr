program SeaWar;

uses
  Forms,
  uMain in 'uMain.pas' {fmMain},
  uNewGame in 'uNewGame.pas' {fmNewGame},
  uSet in 'uSet.pas' {fmSet},
  uAbout in 'uAbout.pas' {fmAbout},
  uConnect in 'uConnect.pas' {fmConnect};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'SeaWar';
  Application.CreateForm(TfmMain, fmMain);
  Application.CreateForm(TfmNewGame, fmNewGame);
  Application.CreateForm(TfmSet, fmSet);
  Application.CreateForm(TfmAbout, fmAbout);
  Application.CreateForm(TfmConnect, fmConnect);
  Application.Run;
end.
