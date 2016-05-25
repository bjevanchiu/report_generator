module ReportGenerator
  module Models
    class Report
      attr_accessor :name, :initialize_fields, :report_fields, :blank_init_fields, :fields_maps

      def perform
        prepare
        integration_records = integrate_sections
        grouped_records = gen_grouped_records(integration_records)
        merged_records = merge_grouped_records(grouped_records)
        save(merged_records)
      end

      private
      def report_class
        @name
      end

      def gen_initialize_fields report_field_name, record
        result = @initialize_fields.dup
        result.tap do |x|
          @blank_init_fields.each_with_index do |blank_field_name, idx|
            x[blank_field_name] = record.send(@fields_maps[report_field_name][blank_field_name])
          end
        end
      end

      def init_blank_init_fields
        @blank_init_fields = @initialize_fields.collect{|k,v| k if v.blank?}.compact
      end

      def init_fields_maps
        @fields_maps = {}.tap do |x|
          @report_fields.each do |report_field_name, report_field_attrs|
            tmp_report_fields = @blank_init_fields + report_field_name
            x[report_field_name] = {}
            tmp_report_fields.each_with_index do |field_name, idx|
              x[report_field_name][field_name] = report_field_attrs[:section_columns][idx]
            end
          end
        end
      end

      def prepare
        init_blank_init_fields
        init_fields_maps
      end

      def gen_grouped_records records
        records.group_by{|r| r[:init_fields]}
      end

      def merge_grouped_records grouped_records
        {}.tap do |x|
          grouped_records.each do |group_key, records|
            tmp_records = records.each{|x| x.delete(:init_fields)}
            x[group_key]=tmp_records.inject(&:merge)
          end
        end
      end

      def integrate_sections
        @report_fields.collect do |field_name, field_attrs|
          section = ReportGenerator.build(ReportGenerator::Models::Section, field_attrs[:section])
          records = section.perform
          records.collect do |record|
            r = {}.tap do |x|
              x[:init_fields] = gen_initialize_fields(field_name, record)
              field_name.each{|fn| x[fn] = record.send(@fields_maps[field_name][fn])}
            end
          end
        end.flatten
      end

      def save records
        ActiveRecord::Base.transaction do
          records.each do |init_fields, record_attrs|
            r = report_class.find_or_initialize_by(init_fields)
            record_attrs.each{|k,v| r.send("#{k}=",v) }
            r.save
          end
        end
      end

    end
  end
end
