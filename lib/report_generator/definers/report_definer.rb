module ReportGenerator
  module Definers
    class ReportDefiner
      def report name, &block
        report_factory = ReportGenerator::Factories::ReportFactory.new
        report_factory.instance_eval(&block) if block_given?
        ReportGenerator.report_factories[name] = report_factory
      end
    end
  end
end
