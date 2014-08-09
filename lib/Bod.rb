require 'pg'

# A Ruby & PSQL Object Relational Mapper
class Bod

  def initialize(record)
    @id = nil
    record.each do |key, value|
      instance_variable_set("@#{key}", value)
      self.class.send(:attr_reader, key)
      self.class.send(:attr_writer, key) if key != 'id'
    end
  end

  def id
    @id
  end

  def self.inherited(subclass)
    @@resource_name = subclass.name.downcase.to_s
    @@table_name = @@resource_name + 's'
    config = YAML.load_file('database.yml')
    @@connection = PG::Connection.open(:dbname => config['database'])
  end

  def self.all
    self.exec_records("SELECT * FROM #{ @@table_name };")
  end

  def self.find(id)
    resource = self.exec_records("SELECT * FROM #{ @@table_name } WHERE id=#{ id } LIMIT 1;")
    resource.first || []
  end

  def self.where(param)
    key, value = param.sort.flatten
    self.exec_records("SELECT * FROM #{ @@table_name } WHERE #{ key }='#{ value }';")
  end


  def exec_records(sql_statement)
    self.class.exec_records(sql_statement)
  end
  def exec(sql_statement)
    self.class.exec(sql_statement)
  end
  def self.exec_records(sql_statement)
    results = self.exec(sql_statement)
    results.map { |record| self.new(record) }
  end
  def self.exec(sql_statement)
    results = @@connection.exec(sql_statement)
  end


  def save()
    columns = self.exec("SELECT column_name FROM information_schema.columns WHERE table_name='#{ @@table_name }';")
    columns = columns.values.flatten
    columns.delete('id')
    if id = self.id
      sql_statement = save_update()
    else
      sql_statement = save_insert()
    end
    id_record = self.exec(sql_statement).first
    self.class.find(id_record['id'])
  end

  private


  def save_update()
    sql_statement = "UPDATE #{ @@table_name } SET "
    instance_variables.each do |variable|
      if columns.include? variable[1..(-1)]
        sql_statement+="#{ variable[1..(-1)] }='#{ instance_variable_get(variable) }' "
      end
    end
    sql_statement+= "WHERE id='#{ id }' RETURNING id;";
  end


  def save_insert()
    sql_statement = "INSERT INTO #{ @@table_name }"
    columns_statement = ''
    value_statement = ''
    instance_variables.each do |variable|
      if columns.include? variable[1..(-1)]
        columns_statement += "#{variable[1..(-1)]}, "
        value_statement += "#{ instance_variable_get(variable) }, "
      end
    end
    sql_statement += " (#{columns_statement[0..-3]}) VALUES ('#{ value_statement[0..-3] }') RETURNING id;";
  end

end
