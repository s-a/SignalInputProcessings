unit TresholdsUnitTest;

interface
uses
  DUnitX.TestFramework, InputSignalProcessor;

type

  [TestFixture]
  TMyTestObject = class(TObject)
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    // Sample Methods
    // Simple single Test
    [Test]
    procedure Test1;
  end;

implementation

uses
  Winapi.Windows;



procedure TMyTestObject.Setup;
begin
end;

procedure TMyTestObject.TearDown;
begin
end;

procedure TMyTestObject.Test1;
const
  data : array[0..73] of double =
    (
      1, 1, 1.1, 1, 0.9, 1, 1, 1.1, 1, 0.9, 1, 1.1, 1, 1, 0.9, 1, 1, 1.1, 1, 1,
      1, 1, 1.1, 0.9, 1, 1.1, 1, 1, 0.9, 1, 1.1, 1, 1, 1.1, 1, 0.8, 0.9, 1, 1.2, 0.9, 1,
      1, 1.1, 1.2, 1, 1.5, 1, 3, 2, 5, 3, 2, 1, 1, 1, 0.9, 1,
      1, 3, 2.6, 4, 3, 3.2, 2, 1, 1, 0.8, 4, 4, 2, 2.5, 1, 1, 1
    );
  lag : longint = 5;
  treshold : double = 3.5;
  influence : double = 0.3;
var
    InputSignalProcessor : TInputSignalProcessor;
    SignalProcessingResult : TInputSignalProcessResult;
    i : integer;
    signals : array of integer;
begin
  InputSignalProcessor := TInputSignalProcessor.Create();
  SignalProcessingResult := InputSignalProcessor.ComputeTresholds(data, lag, treshold, influence);
end;

initialization
  TDUnitX.RegisterTestFixture(TMyTestObject);
end.
