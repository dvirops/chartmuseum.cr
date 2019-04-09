module Chartmuseum
  class Client
    # Defines methods related to chart.
    #
    # See [https://chartmuseum.com/docs/#chart-manipulation](https://chartmuseum.com/docs/#chart-manipulation)
    module Chart
      # Gets a list of all charts.
      #
      # - return [JSON::Any] List of all charts and their versions.
      #
      # ```
      # client.charts
      # ```
      def charts : JSON::Any
        get("/api/charts").parse
      end

      # Gets a list of all versions of a chart.
      #
      # - chart [String] The name of a chart.
      # - return [JSON::Any] List of all versions of a specific chart.
      #
      # ```
      # client.charts("application_x")
      # ```
      def chart(chart : String) : JSON::Any
        get("/api/charts/#{chart}").parse
      end

      # Gets a version of chart.
      #
      # - chart [String] The name of a chart.
      # - version [String] The name of a chart.
      # - return [JSON::Any] specific version of a chart.
      #
      # ```
      # client.verion("application_x", "version_1")
      # ```
      def version(chart : String, version : String) : JSON::Any
        get("/api/charts/#{chart}/#{version}").parse
      end
    end
  end
end
