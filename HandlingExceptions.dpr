program HandlingExceptions;

uses
  Vcl.Forms,
  uHandlingExceptions in 'uHandlingExceptions.pas' {Form61};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm61, Form61);
  Application.Run;
end.
