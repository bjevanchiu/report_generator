module ReportGenerator
  module Factories
    class SectionFactory
      attr_reader :attributes

      def initialize
        @attributes = {}
        @attributes[:select_columns] = []
        @attributes[:conditions] = []
        @attributes[:group_columns] = []
        @attributes[:sum_groups] = {}
        @attributes[:joins] = []
      end

      def mixin section_name, options = {}
        tmp_sf_attrs = ReportGenerator.section_factories[section_name].attributes.dup
        except_items = options[:except]
        if except_items
          tmp_except_items = except_items.is_a?(Array) ? except_items : [except_items]
          tmp_except_items.each{|x| tmp_sf_attrs.delete(x)}
        end
        @attributes.merge!(tmp_sf_attrs)
      end

      def data_source kclass
        @attributes[:data_source] = kclass
      end

      def select *cols
        @attributes[:select_columns] +=  cols
      end

      def count *cols
        @attributes[:select_columns] += cols.collect do |x|
          "COUNT(#{x}) count_#{x.to_s.gsub('.', '_')}"
        end
      end

      def distinct_count *cols
        @attributes[:select_columns] += cols.collect do |x|
          "COUNT(DISTINCT #{x}) count_distinct_#{x.to_s.gsub('.', '_')}"
        end
      end

      def sum *cols
        @attributes[:select_columns] += cols.collect{|x| "SUM(#{x})"}
      end

      def condition *arg, &block
        @attributes[:conditions]  += arg
        if block_given?
          attrs_factory = AttrsFactory.new
          attrs_factory.instance_eval(&block)
          @attributes[:conditions] << attrs_factory.attributes
        end
      end

      def group *arg
        @attributes[:select_columns] += arg
        @attributes[:group_columns] += arg
      end

      def sum_group col, manager = nil
        @attributes[:sum_groups][col] = manager
      end

      def join join_clause
        @attributes[:joins] << join_clause
      end

      def method_missing(name, *args, &block)
        @attributes[name] = args[0]
      end
    end
  end
end
