class Dog
  attr_accessor :id, :name, :breed
  def initialize(attributes)
    attributes.each {|k,v| self.send(("#{k}="),v)}
  end

  def self.create_table
    drop_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS dogs (
        id INTEGER PRIMARY KEY,
        name TEXT,
        breed TEXT
      )
    SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS dogs"
    DB[:conn].execute(sql)
  end

  def self.new_from_db(row)
    attributes = {id: row[0], name: row[1], breed: row[2]}
    dog = Dog.new(attributes)
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * FROM dog WHERE name = ? LIMIT 1
    SQL
    self.new_from_db(DB[:conn].execute(sql, name)[0])

  end

end
