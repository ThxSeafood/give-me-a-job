# frozen_string_literal: true

module ThxSeafood
  module Repository
    # Repository for Jobs
    class Hots

      def self.all
        Database::HotOrm.all.map { |db_record| rebuild_entity(db_record) }
      end
      
      def self.find_by_city(city)
        Database::HotOrm.where(city: city).all.map { |db_record| rebuild_entity(db_record) }
      end

      def self.create(entity, city)
        # 這邊的create動作會真的把資料存進DB裡面
        db_job = Database::HotOrm.create(
          name: entity.name,
          link: entity.link,
          company: entity.company,
          lng: entity.lng,
          lat: entity.lat,
          address: entity.address,
          addr_no_descript: entity.addr_no_descript,
          # description: entity.description,  
          user_query: entity.user_query,
          city: city 
        )
        
        # rebuild的目的只是傳Entity回去比起傳Dataset回去還好看而已
        self.rebuild_entity(db_job)
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record

        Entity::Hot.new(
          rank: db_record.id,
          name: db_record.name,
          link: db_record.link,
          company: db_record.company,
          lng: db_record.lng,
          lat: db_record.lat,
          address: db_record.address,
          addr_no_descript: db_record.addr_no_descript,
          # description: db_record.description,
          user_query: db_record.user_query, 
          city: db_record.city
        )
      end
    end
  end
end
