# Implementation of "Smoothed zero-score alogrithm" in Delphi

This class uses a rolling mean and a rolling deviation (separate) to identify peaks in a vector to process serial measurement data in "real time". Inspired by [this article](https://stackoverflow.com/questions/22583391/peak-signal-detection-in-realtime-timeseries-data)

## Usage

```objectpascal
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
```

```bash
SignalProcessingResult.signals yields => (0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
```

## Visual draph demonstraton

![graph](/graph.gif)
