module ReportGenerator
  module Factories
    class ReportFactory
      attr_reader :attributes

      def initialize
        @attributes = {}
        @attributes[:initialize_fields] = {}
        @attributes[:report_fields] = {}
      end

      def initialize_fields *args, &block
        if args.present?
          args.each{|x| @attributes[:initialize_fields][x]}
        end
        if block_given?
          attrs_factory = AttrsFactory.new
          attrs_factory.instance_eval(&block)
          @attributes[:initialize_fields].merge!(attrs_factory.attributes)
        end
      end

      def field *names, &block
        field_factory = ReportGenerator::Factories::ReportFieldFactory.new
        field_factory.instance_eval(&block) if block_given?
        @attributes[:report_fields][names] = field_factory.attributes
      end

      def method_missing(name, *args, &block)
        @attributes[name] = args[0]
      end

    end
  end
end
