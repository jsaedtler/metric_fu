module MetricFu
  
  class Benchmark < Generator
    require 'fastercsv'
    def self.verify_dependencies!
    end

    def emit
      @output = `rake test:benchmark`
    end

    def analyze
      # @matches = @output #.chomp.split("\n\n").map{|m| m.split("\n  ") }
      @matches = []
      Dir.glob('tmp/performance**/*wall_time.csv').each do |file|

        last_line = nil
        #get last line of csv
        FasterCSV.foreach(file) do |row|
          last_line=row
        end
        #parse testname
        file =~ /tmp\/performance\/(.*)\.csv/;
        testname = $1
        @matches << {:name => testname, :time => last_line[0]} if testname && last_line
      end
      
    end

    def to_h
      target = []
#      require 'ruby-debug'; debugger
      total_score = 0 # @matches.shift.first.split('=').last.strip
      @matches.each do |test|
        target << {:testname => test[:name], :time => test[:time]}
      end
      {:benchmark => {:matches => target.flatten}}
    end
  end
end
