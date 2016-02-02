require 'coveralls'
Coveralls.wear!

require 'active_record'
require_relative '../lib/active_data_tables'

ActiveRecord::Base.establish_connection(
  :adapter  => 'sqlite3',
  :database => ':memory:'
)

ActiveRecord::Schema.define do
  unless ActiveRecord::Base.connection.tables.include? 'events'
    create_table :events do |table|
      table.column :title,          :string
      table.column :description,    :string
      table.column :date,           :datetime
      table.column :category,       :string
      table.column :party,          :boolean
    end
  end
end
