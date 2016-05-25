module ReportGenerator
  module Factories
    class ReportFieldFactory
      attr_reader :attributes

      def initialize
        @attributes = {}
        @attributes[:section_columns] = []
      end

      def section name
        @attributes[:section] = name
      end

      def column column_name
        @attributes[:section_columns] << column_name
      end

      def columns *args
        @attributes[:section_columns] += args
      end

      def method_missing(name, *args, &block)
        @attributes[name] = args
      end

    end
  end
end
