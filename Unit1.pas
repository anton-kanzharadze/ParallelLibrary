unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Threading;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    FFutureValue: IFuture<String>;
    function GetValue: String;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses TypInfo;

procedure TForm1.Button1Click(Sender: TObject);
begin
  FFutureValue := TTask.Future<String>(GetValue);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  if not Assigned(FFutureValue) then
   Label1.Caption := '??'
  else if FFutureValue.Status <> TTaskStatus.Completed then
    Label1.Caption := GetEnumName(TypeInfo(TTaskStatus), Integer(FFutureValue.Status))
  else
    Label1.Caption := FFutureValue.Value
end;

function TForm1.GetValue: String;
begin
  Sleep(5000);
  Abort;
  Result := 'TForm1.GetValue';
end;

end.
