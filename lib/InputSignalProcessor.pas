unit InputSignalProcessor;

interface

type

  TInputSignalProcessResult = record
    signals : array of integer;
    avgFilter : array of double;
    stdFilter : array of double;
  end;

  TInputSignalProcessor = Class

  private
    procedure resetIntegerArray(var arr : array of integer);
    procedure resetDoubleArray(var arr : array of double);

  public
      constructor Create();
      destructor Destroy;
      function ComputeTresholds(const y : array of double; const lag:  longint; const threshold: Double; const influence: Double) : TInputSignalProcessResult;
  end;


implementation

uses

  SysUtils, StrUtils, System.Math;

constructor TInputSignalProcessor.Create();
begin
end;

destructor TInputSignalProcessor.Destroy();
begin
  inherited;
end;

procedure TInputSignalProcessor.resetIntegerArray(var arr : array of integer);
var
  i: Integer;
begin
  for i := 0 to length(arr) do begin
    arr[0] := 0;  
  end;
end;

procedure TInputSignalProcessor.resetDoubleArray(var arr : array of double);
var
  i: Integer;
begin
  for i := 0 to length(arr) do begin
    arr[0] := 0.00;  
  end;
end;

{
 y - The input vector to analyze
 lag - The lag of the moving window (i.e. how big the window is)
 threshold - The z-score at which the algorithm signals (i.e. how many standard deviations away from the moving mean a peak (or signal) is)
 influence - The influence (between 0 and 1) of new signals on the mean and standard deviation (how much a peak (or signal) should affect other values near it)
}
function TInputSignalProcessor.ComputeTresholds(const y : array of double; const lag:  longint; const threshold: Double; const influence: Double) : TInputSignalProcessResult;
var
    stats : array of double;
    filteredY : array of double;
    dataLength : LongInt;
    x, a, i: longint;
begin

    dataLength := Length(y);
    setlength( stats, dataLength );
    // the results (peaks, 1 or -1) of our algorithm
    //// List<Integer> signals = new ArrayList<Integer>(Collections.nCopies(y.size(), 0))
    setlength( result.signals, dataLength );
    ////// resetIntegerArray(result.signals);
    //filter out the signals (peaks) from our original list (using influence arg)
    //// List<Double> filteredY = new ArrayList<Double>(y)
    setlength( filteredY, dataLength );
    ////// resetDoubleArray(filteredY);
    //the current average of the rolling window
    //// List<Double> avgFilter = new ArrayList<Double>(Collections.nCopies(y.size(), 0.0d))
    setlength( result.avgFilter, dataLength );
    ////// resetDoubleArray(result.avgFilter);
    //the current standard deviation of the rolling window
    //// List<Double> stdFilter = new ArrayList<Double>(Collections.nCopies(y.size(), 0.0d))
    setlength( result.stdFilter, dataLength );
    ////// resetDoubleArray(result.stdFilter);

    //init avgFilter and stdFilter
    ////// (0..lag-1).each { stats.addValue(y[it as int]) }
    for i := 0 to dataLength - 1 do begin
      stats[i] := y[i];
    end;
    ////// avgFilter[lag - 1 as int] = stats.getMean()
    result.avgFilter[lag -1] := Mean(stats);
    ////// stdFilter[lag - 1 as int] = Math.sqrt(stats.getPopulationVariance()) //getStandardDeviation() uses sample variance (not what we want)
    result.stdFilter[lag - 1] := Sqrt( PopnVariance(stats) );
    ////// stats.clear()

//////        (lag..y.size()-1).each { i ->
//////            //if the distance between the current value and average is enough standard deviations (threshold) away
//////            if (Math.abs((y[i as int] - avgFilter[i - 1 as int]) as Double) > threshold * stdFilter[i - 1 as int]) {
//////                //this is a signal (i.e. peak), determine if it is a positive or negative signal
//////                signals[i as int] = (y[i as int] > avgFilter[i - 1 as int]) ? 1 : -1
//////                //filter this signal out using influence
//////                filteredY[i as int] = (influence * y[i as int]) + ((1-influence) * filteredY[i - 1 as int])
//////            } else {
//////                //ensure this signal remains a zero
//////                signals[i as int] = 0
//////                //ensure this value is not filtered
//////                filteredY[i as int] = y[i as int]
//////            }
//////            //update rolling average and deviation
//////            (i - lag..i-1).each { stats.addValue(filteredY[it as int] as Double) }
//////            avgFilter[i as int] = stats.getMean()
//////            stdFilter[i as int] = Math.sqrt(stats.getPopulationVariance()) //getStandardDeviation() uses sample variance (not what we want)
//////            stats.clear()
//////        }

    for i := lag to dataLength - 1 do begin
      // if the distance between the current value and average is enough standard deviations (threshold) away
      if (abs((y[i] - result.avgFilter[i - 1])) > threshold * result.stdFilter[i - 1]) then begin
          //this is a signal (i.e. peak), determine if it is a positive or negative signal
          if (y[i] > result.avgFilter[i - 1]) then begin
            result.signals[i] := 1;
          end else begin
            result.signals[i] := -1;
          end;
          //filter this signal out using influence
          filteredY[i] := (influence * y[i]) + ((1-influence) * filteredY[i - 1]);
      end else begin
          //ensure this signal remains a zero
          result.signals[i] := 0;
          //ensure this value is not filtered
          filteredY[i] := y[i];
      end;
      //update rolling average and deviation
      ////// (i - lag..i-1).each { stats.addValue(filteredY[it as int] as Double) }
      SetLength(stats, lag);
      x := 0;
      for a := i - lag to i - 1 do begin
        stats[x] := filteredY[a];
        x := x + 1;
      end;
      ////// avgFilter[i as int] = stats.getMean()
      result.avgFilter[i] := Mean(stats);
      ////// stdFilter[i as int] = Math.sqrt(stats.getPopulationVariance()) //getStandardDeviation() uses sample variance (not what we want)
      result.stdFilter[i] := Sqrt( PopnVariance(stats) ); //getStandardDeviation() uses sample variance (not what we want)
      SetLength(stats, 0);

    end;

end;



end.
