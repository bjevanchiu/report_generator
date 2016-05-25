require 'ostruct'

require 'report_generator/helpers/query_builder'
require 'report_generator/factories/attrs_factory'
require 'report_generator/factories/report_field_factory'
require 'report_generator/factories/section_factory'
require 'report_generator/factories/report_factory'
require 'report_generator/definers/section_definer'
require 'report_generator/definers/report_definer'
require 'report_generator/models/report'
require 'report_generator/models/report_field'
require 'report_generator/models/section'
require 'report_generator/version'

module ReportGenerator
  @factories = {
    ReportGenerator::Models::Section => {},
    ReportGenerator::Models::Report => {}
  }
  class << self
    def section_factories
      @factories[ReportGenerator::Models::Section]
    end

    def report_factories
      @factories[ReportGenerator::Models::Report]
    end

    def configure &block
      class_eval(&block) if block_given?
    end

    def define_section &block
      section_definer = ReportGenerator::Definers::SectionDefiner.new
      section_definer.instance_eval(&block) if block_given?
    end

    def define_report &block
      generator_definer = ReportGenerator::Definers::ReportDefiner.new
      generator_definer.instance_eval(&block) if block_given?
    end

    def build model_class, name, attributes = {}
      tmp_factory_attributes = @factories[model_class][name].attributes
      if attributes.present?
        tmp_factory_attributes.merge!(attributes)
      end
      tmp_model = model_class.new
      tmp_model.tap do |x|
        x.name = name
        tmp_factory_attributes.each do |k,v|
          x.send("#{k}=", v)
        end
      end
    end

  end
end
