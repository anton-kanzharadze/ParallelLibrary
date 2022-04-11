unit uHandlingExceptions;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TForm61 = class(TForm)
    Memo1: TMemo;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form61: TForm61;

implementation

{$R *.dfm}

uses Threading, Diagnostics;

function PrimesBelow(ANumber: Integer): Integer;
begin
  Result := 0;
end;

procedure TForm61.Button1Click(Sender: TObject);
begin
  TTask.Run(
    procedure
    var
      Stopwatch: TStopWatch;
      Total: Integer;
      ElapsedSeconds: Double;
    begin
      Stopwatch := TStopWatch.StartNew;
      // oops, something happened!
      raise Exception.Create('An error of some sort occurred in the task');
      Total := PrimesBelow(200000);
      ElapsedSeconds := Stopwatch.Elapsed.TotalSeconds;
      TThread.Synchronize(nil,
        procedure
        begin
          Memo1.Lines.Add(Format('There are %d primes under' + ' 200,000',
            [Total]));
          Memo1.Lines.Add(Format('It took %:2f seconds to ' + 'calcluate that',
            [ElapsedSeconds]));
        end);
    end);
end;

procedure TForm61.Button2Click(Sender: TObject);
begin
  TTask.Run(
    procedure
    var
      Stopwatch: TStopWatch;
      Total: Integer;
      ElapsedSeconds: Double;
    begin
      try
        Stopwatch := TStopWatch.StartNew;
        // oops, something happened!
        raise Exception.Create('An error of some sort occurred in the task');
        Total := PrimesBelow(200000);
        ElapsedSeconds := Stopwatch.Elapsed.TotalSeconds;
        TThread.Synchronize(nil,
          procedure
          begin
            Memo1.Lines.Add(Format('There are %d primes under 200,000',
              [Total]));
            Memo1.Lines.Add(Format('It took %:2f seconds to calcluate that',
              [ElapsedSeconds]));
          end);
      except
        on e: Exception do
        begin
          TThread.Queue(TThread.CurrentThread,
            procedure
            begin
              raise e;
            end);
        end
      end;
    end);

end;

procedure TForm61.Button3Click(Sender: TObject);
var
  AcquiredException: TObject;
begin
  TTask.Run(
    procedure
    var
      Stopwatch: TStopWatch;
      Total: Integer;
      ElapsedSeconds: Double;
    begin
      try
        Stopwatch := TStopWatch.StartNew;
        // oops, something happened!
        raise Exception.Create
          ('An error of some sort occurred in the task');
        Total := PrimesBelow(200000);
        ElapsedSeconds := Stopwatch.Elapsed.TotalSeconds;
        TThread.Synchronize(nil,
          procedure
          begin
            Memo1.Lines.Add(Format('There are %d primes' + ' under 200,000',
              [Total]));
            Memo1.Lines.Add(Format('It took %:2f seconds' +
              ' to calcluate that', [ElapsedSeconds]));
          end);
      except
        on e: Exception do
        begin
          AcquiredException := AcquireExceptionObject;
          TThread.Queue(TThread.CurrentThread,
            procedure
            begin
              raise AcquiredException;
            end);
        end
      end;
    end);
end;

end.
