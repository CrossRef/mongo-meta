require 'mongo'
require 'json'

DRY_RUN = true

ARGV.each do |filename|
  File.open(filename) do |file|
    metadata = JSON.parse(file.read)

    metadata['indexes'].each do |index|
      db_name, coll_name = index['ns'].split '.'
      
      index_key = []
      index['key'].each_pair do |field, order|
        index_key << [field, order]
      end

      puts "Inserting index into DB #{db_name}, Collection #{coll_name} with key:"
      p index_key

      if !DRY_RUN
        conn = Mongo::Connection.new
        db = conn[db_name]
        coll = db[coll_name]
        coll.create_index index_key
      end
    end
  end
end
      
      
    
