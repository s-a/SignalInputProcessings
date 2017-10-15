class C
{

    **
     * "Smoothed zero-score alogrithm" 
     *  Uses a rolling mean and a rolling deviation (separate) to identify peaks in a vector
     *
     * @param y - The input vector to analyze
     * @param lag - The lag of the moving window (i.e. how big the window is)
     * @param threshold - The z-score at which the algorithm signals (i.e. how many standard deviations away from the moving mean a peak (or signal) is)
     * @param influence - The influence (between 0 and 1) of new signals on the mean and standard deviation (how much a peak (or signal) should affect other values near it)
     * @return - The calculated averages (avgFilter) and deviations (stdFilter), and the signals (signals)
     */

    public static HashMap<String, List<Object>> thresholdingAlgo(List<Double> y, Long lag, Double threshold, Double influence) {
        //init stats instance
        SummaryStatistics stats = new SummaryStatistics()

        //the results (peaks, 1 or -1) of our algorithm
        List<Integer> signals = new ArrayList<Integer>(Collections.nCopies(y.size(), 0))
        //filter out the signals (peaks) from our original list (using influence arg)
        List<Double> filteredY = new ArrayList<Double>(y)
        //the current average of the rolling window
        List<Double> avgFilter = new ArrayList<Double>(Collections.nCopies(y.size(), 0.0d))
        //the current standard deviation of the rolling window
        List<Double> stdFilter = new ArrayList<Double>(Collections.nCopies(y.size(), 0.0d))
        //init avgFilter and stdFilter
        (0..lag-1).each { stats.addValue(y[it as int]) }
        avgFilter[lag - 1 as int] = stats.getMean()
        stdFilter[lag - 1 as int] = Math.sqrt(stats.getPopulationVariance()) //getStandardDeviation() uses sample variance (not what we want)
        stats.clear()
        //loop input starting at end of rolling window
        (lag..y.size()-1).each { i ->
            //if the distance between the current value and average is enough standard deviations (threshold) away
            if (Math.abs((y[i as int] - avgFilter[i - 1 as int]) as Double) > threshold * stdFilter[i - 1 as int]) {
                //this is a signal (i.e. peak), determine if it is a positive or negative signal
                signals[i as int] = (y[i as int] > avgFilter[i - 1 as int]) ? 1 : -1
                //filter this signal out using influence
                filteredY[i as int] = (influence * y[i as int]) + ((1-influence) * filteredY[i - 1 as int])
            } else {
                //ensure this signal remains a zero
                signals[i as int] = 0
                //ensure this value is not filtered
                filteredY[i as int] = y[i as int]
            }
            //update rolling average and deviation
            (i - lag..i-1).each { stats.addValue(filteredY[it as int] as Double) }
            avgFilter[i as int] = stats.getMean()
            stdFilter[i as int] = Math.sqrt(stats.getPopulationVariance()) //getStandardDeviation() uses sample variance (not what we want)
            stats.clear()
        }

        return [
            signals  : signals,
            avgFilter: avgFilter,
            stdFilter: stdFilter
        ]
    }

   public static void main(String[] args)
   {
      System.out.println("Application C entry point");
   }
}
