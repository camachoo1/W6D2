require_relative 'db_connection'
require 'active_support/inflector'
require 'byebug'
# NB: the attr_accessor we wrote in phase 0 is NOT used in the rest
# of this project. It was only a warm up.

class SQLObject
  def self.columns
    @table ||= DBConnection.execute2(<<-SQL)
      SELECT *
      FROM "#{table_name}"
      SQL
    @table.first.map(&:to_sym)
  end

  def self.finalize!
    self.columns.each do |col|
      define_method(:"#{col}") do 
        self.attributes[col]
      end
      
      define_method(:"#{col}=") do |value|
        self.attributes[col] = value
      end
    end
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    @table_name = self.to_s.downcase + 's'
  end

  def self.all
    # ...
  end

  def self.parse_all(results)
    # ...
  end

  def self.find(id)
    # ...
  end

  def initialize(params = {})
    params.each do |attr_name, value|
      symbol = :"#{attr_name}"
      unless self.class.columns.include?(symbol)
        raise "unknown attribute '#{attr_name}'"
      else
        send("#{symbol}=",value) 
      end 
    end
  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    # ...
  end

  def insert
    # ...
  end

  def update
    # ...
  end

  def save
    # ...
  end
end
