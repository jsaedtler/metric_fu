require 'active_support'

module MetricFu
  class Grapher
    BLUFF_GRAPH_SIZE = "1000x600"
    BLUFF_DEFAULT_OPTIONS = <<-EOS
      var g = new Bluff.Line('graph', "#{BLUFF_GRAPH_SIZE}");
      g.theme_37signals();
      g.tooltips = true;
      g.title_font_size = "24px"
      g.legend_font_size = "12px"
      g.marker_font_size = "10px"
    EOS
  end
  
  class BenchmarkBluffGrapher < BenchmarkGrapher
    def graph!
      content = <<-EOS
        #{BLUFF_DEFAULT_OPTIONS}
        g.title = 'rake:benchmark wall times:';
      EOS
      @benchmarks.each do |test, data|
        content << "g.data('#{test}',[#{data.join(',')}]);"
      end
      content << "g.labels = #{@labels.to_json};"
      content << "g.draw();"
      File.open(File.join(MetricFu.output_directory, 'benchmark.js'), 'w') {|f| f << content }
    end
  end

  class FlayBluffGrapher < FlayGrapher
    def graph!
      content = <<-EOS
        #{BLUFF_DEFAULT_OPTIONS}
        g.title = 'Flay: duplication';
        g.data('flay', [#{@flay_score.join(',')}]);
        g.labels = #{@labels.to_json};
        g.draw();
      EOS
      File.open(File.join(MetricFu.output_directory, 'flay.js'), 'w') {|f| f << content }
    end
  end

  class FlogBluffGrapher < FlogGrapher
    def graph!
      content = <<-EOS
        #{BLUFF_DEFAULT_OPTIONS}
        g.title = 'Flog: code complexity';
        g.data('average', [#{@flog_average.join(',')}]);
        g.data('top 5% average', [#{@top_five_percent_average.join(',')}])
        g.labels = #{@labels.to_json};
        g.draw();
      EOS
      File.open(File.join(MetricFu.output_directory, 'flog.js'), 'w') {|f| f << content }
    end
  end

  class RcovBluffGrapher < RcovGrapher
    def graph!
      content = <<-EOS
        #{BLUFF_DEFAULT_OPTIONS}
        g.title = 'Rcov: code coverage';
        g.data('rcov', [#{@rcov_percent.join(',')}]);
        g.labels = #{@labels.to_json};
        g.draw();
      EOS
      File.open(File.join(MetricFu.output_directory, 'rcov.js'), 'w') {|f| f << content }
    end
  end

  class ReekBluffGrapher < ReekGrapher
    def graph!
      legend = @reek_count.keys.sort
      data = ""
      legend.each do |name|
        data += "g.data('#{name}', [#{@reek_count[name].join(',')}])\n"
      end
      content = <<-EOS
        #{BLUFF_DEFAULT_OPTIONS}
        g.title = 'Reek: code smells';
        #{data}
        g.labels = #{@labels.to_json};
        g.draw();
      EOS
      File.open(File.join(MetricFu.output_directory, 'reek.js'), 'w') {|f| f << content }
    end
  end

  class RoodiBluffGrapher < RoodiGrapher
    def graph!
      content = <<-EOS
        #{BLUFF_DEFAULT_OPTIONS}
        g.title = 'Roodi: design problems';
        g.data('roodi', [#{@roodi_count.join(',')}]);
        g.labels = #{@labels.to_json};
        g.draw();
      EOS
      File.open(File.join(MetricFu.output_directory, 'roodi.js'), 'w') {|f| f << content }
    end
  end
end
