module Chartmuseum
  class Client
    # Defines methods related to chart.
    #
    # See [https://chartmuseum.com/docs/#chart-manipulation](https://chartmuseum.com/docs/#chart-manipulation)
    module Chart
      # Gets a list of all charts.
      #
      # - option param [String] chart The name of a chart.
      # - return [JSON::Any]  List of all versions of a chart.
      #
      # ```
      # client.charts
      # ```
      def charts : JSON::Any
        get("/api/charts").parse
      end

      # Gets a list of all versions of a chart.
      #
      # - option param [String] chart The name of a chart.
      # - return [JSON::Any]  List of all versions of a chart.
      #
      # ```
      # client.charts("application_x")
      # ```
      def chart(chart : String? = nil) : JSON::Any
        get("/api/charts/#{chart}").parse
      end

      # Gets a version of chart.
      #
      # - option param [String] chart The name of a chart.
      # - option param [String] version The name of a chart.
      # - return [JSON::Any]  List of all versions of a chart.
      #
      # ```
      # client.verion("application_x", "version_1")
      # ```
      def version(chart : String? = nil, version : String? = nil) : JSON::Any
        get("/api/charts/#{chart}/#{version}").parse
      end
    end
  end
end
