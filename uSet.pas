unit uSet;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons;

type
  TfmSet = class(TForm)
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    cbRightToDel: TCheckBox;
    bbOk: TBitBtn;
    bbCancel: TBitBtn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmSet: TfmSet;

implementation

{$R *.dfm}

end.
