unit uNewGame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Spin;

type
  TfmNewGame = class(TForm)
    bbOk: TBitBtn;
    bbCancel: TBitBtn;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    edNameSelf: TEdit;
    Label2: TLabel;
    seAgeSelf: TSpinEdit;
    Label4: TLabel;
    edNameComp: TEdit;
    Label3: TLabel;
    seAgeComp: TSpinEdit;
    rbEasy: TRadioButton;
    rbHard: TRadioButton;
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmNewGame: TfmNewGame;

implementation

{$R *.dfm}

procedure TfmNewGame.FormActivate(Sender: TObject);
begin
  edNameSelf.SetFocus;
end;

end.
