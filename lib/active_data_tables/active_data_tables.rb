require 'jbuilder'

class ActiveDataTables

  def initialize(query, params)
    @query = query
    @params = params
  end

  def execute
    total = @query.count
    filtered = total # don't currently support filtering records so this will be the same as the total

    apply_paging
    apply_ordering

    DataTablesResult.new(@params[:draw].to_i, @query, total, filtered)
  end

  def self.find(query, params)
    new(query, params).execute
  end

  class DataTablesResult

    attr_accessor :data, :draw, :records_total, :records_filtered

    def initialize(draw, data, records_total, records_filtered)
      @draw = draw
      @data = data
      @records_total = records_total
      @records_filtered = records_filtered
    end

    def to_json
      data = @data.map do |a|
        a.is_a?(OpenStruct) ? a.marshal_dump : a
      end
      Jbuilder.encode do |json|
        json.draw @draw
        json.recordsTotal @records_total
        json.recordsFiltered @records_filtered
        json.data data
      end
    end

  end

  private

  def apply_paging
    if @params[:start]
      if @query.respond_to?(:offset)
        @query = @query.offset(@params[:start])
      else
        @query = @query.drop(@params[:start].to_i)
      end
    end

    if @params[:length]
      if @query.respond_to?(:limit)
        @query = @query.limit(@params[:length])
      else
        @query = @query.first(@params[:length].to_i)
      end
    end
  end

  def apply_ordering
    order_instructions = @params[:order] || {}

    columns = load_columns
    order = {}
    order_instructions.each_pair do |k, v|
      column_index = v[:column]
      column_name = columns[column_index.to_sym][:data]
      order[column_name.to_sym] = v[:dir].to_sym
    end

    if @query.respond_to?(:reorder)
      @query = @query.reorder(order)
    else
      @query = @query.sort do |row1, row2|
        keys = order.map{ |key, direction|
          val = direction == :desc ? -1 : 1
          val * (row1[key] <=> row2[key])
        }
        keys.find { |x| x != 0 } || 0
      end
    end
  end

  def load_columns
    @params[:columns] || {}
  end

end
