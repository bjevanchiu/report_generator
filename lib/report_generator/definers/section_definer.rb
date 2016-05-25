module ReportGenerator
  module Definers
    class SectionDefiner
      def section name, &block
        section_factory = ReportGenerator::Factories::SectionFactory.new
        section_factory.instance_eval(&block) if block_given?
        ReportGenerator.section_factories[name] = section_factory
      end
    end
  end
end
