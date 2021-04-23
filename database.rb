module Database

  DB = Sequel.connect(
    adapter:  'mysql2',
    user:     'root',
    password: 'Walia@219',
    host:     'localhost',
    database: 'scrapper'
  )

  def create_table
    unless DB.table_exists?(:products)
      DB.create_table :products do
        column :name,  String
        column :price, String
      end
    end
  end

  def table
    DB[:products]
  end

  def insert(name, price)
    table.insert(name: name, price: price)
  end

end
