program GetSignalPeaks;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  InputSignalProcessor;

procedure ComputeSignalPeaks();
const
  data: array [0 .. 73] of double = (1, 1, 1.1, 1, 0.9, 1, 1, 1.1, 1, 0.9, 1,
    1.1, 1, 1, 0.9, 1, 1, 1.1, 1, 1, 1, 1, 1.1, 0.9, 1, 1.1, 1, 1, 0.9, 1, 1.1,
    1, 1, 1.1, 1, 0.8, 0.9, 1, 1.2, 0.9, 1, 1, 1.1, 1.2, 1, 1.5, 1, 3, 2, 5, 3,
    2, 1, 1, 1, 0.9, 1, 1, 3, 2.6, 4, 3, 3.2, 2, 1, 1, 0.8, 4, 4, 2,
    2.5, 1, 1, 1);
  lag: longint = 5;
  treshold: double = 3.5;
  influence: double = 0.3;
var
  InputSignalProcessor: TInputSignalProcessor;
  SignalProcessingResult: TInputSignalProcessResult;
  i: integer;
  signals: array of integer;
  dataString, signal, avg, std: string;
  InvariantSettings: TFormatSettings;
begin
  InvariantSettings.DecimalSeparator := '.';
  InputSignalProcessor := TInputSignalProcessor.Create();
  SignalProcessingResult := InputSignalProcessor.ComputeTresholds(data, lag,
    treshold, influence);

  Writeln('Serial Data;Signal;AVG Filter;STD Filter');

  for i := 0 to high(SignalProcessingResult.signals) - 1 do
  begin
    dataString := FloatToStr(data[i], InvariantSettings);
    avg := FloatToStr(SignalProcessingResult.avgFilter[i], InvariantSettings);
    std := FloatToStr(SignalProcessingResult.stdFilter[i], InvariantSettings);
    signal := IntToStr(SignalProcessingResult.signals[i]);
    Writeln(dataString + ';' + signal + ';' + avg + ';' + std);
  end;

end;

begin
  try
    ComputeSignalPeaks();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;

end.
