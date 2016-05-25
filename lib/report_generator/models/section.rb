module ReportGenerator
  module Models
    class Section
      include ReportGenerator::Helpers::QueryBuilder
      attr_accessor :name, :data_source, :select_columns, :joins, :conditions, :group_columns, :sum_groups

      def perform
        p "current_section: #{name}"
        records = query(data_source, select_columns, joins, conditions, group_columns)
        if sum_groups.present?
          sum_records = sum_groups.collect do |sum_col, distributer|
            tmp_sum_col = sum_col.to_s.split('.').last
            sum_group_items = distributer.distribute(records.map(&tmp_sum_col.to_sym).uniq.compact)
            tmp_group_columns,tmp_select_columns = group_columns.dup, select_columns.dup
            tmp_group_columns.delete(sum_col)
            tmp_select_columns.delete(sum_col)
            sum_group_items.collect do |sum_group_item|
              tmp_conditions = []
              tmp_conditions = conditions.dup
              group_name = sum_group_item.shift
              tmp_conditions << {sum_col => sum_group_item} if sum_group_item.compact.present?
              result = query(data_source, tmp_select_columns, joins, tmp_conditions,tmp_group_columns)
              result.tap do |x|
                x.collect! do|r|
                  tmp_attrs = r.attributes.dup
                  tmp_attrs[tmp_sum_col] = group_name
                  OpenStruct.new(tmp_attrs)
                end
              end
            end # group_items
          end # sum_groups
          records += sum_records.flatten
        end
        records
      end
    end
  end
end
