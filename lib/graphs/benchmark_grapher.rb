module MetricFu
  
  class BenchmarkGrapher < Grapher
    
    attr_accessor :benchmarks, :labels
    
    def initialize
      super
      @benchmarks = {}
      @labels = {}
    end
    
    def get_metrics(metrics, date)
      unless  metrics.nil? || metrics[:benchmark].blank? || metrics[:benchmark][:matches].blank?
        metrics[:benchmark][:matches].each do |test_line|
          test = test_line[:testname]
          time = test_line[:time]
          
          @benchmarks[test] ||=[]
          
          if @benchmarks[test].size < @labels.size
            @labels.size.times {@benchmarks[test].push('')}
          end
          @benchmarks[test].push((time.to_f * 1000).to_i)
        end
      end
      
      @labels.update( { @labels.size => date })
    end
    
  end
  
end
