# frozen_string_literal: true

module ThxSeafood
  module Repository
    # Repository for Jobs
    class Jobs
      # def self.find_id(id)
      #   db_record = Database::JobOrm.first(id: id)
      #   rebuild_entity(db_record)
      # end
      
      # def self.find(entity)
      #   find_jobname(entity.name)
      # end

      def self.all
        Database::JobOrm.all.map { |db_record| rebuild_entity(db_record) }
      end  

      def self.find_jobs_by_using_regexp(keyword)
        # 這邊使用了regex，傳回欄位中有包含keyword的所有job，而不是完全match
        # 靠北，SQLite不支援regex，Sequel文件說可能只有PostgreSQL跟MySQL能用= =
        db_records = Database::JobOrm.where(name: /.*#{keyword}.*/).all
        db_records.map{ |db_record| rebuild_entity(db_record) }
      end


      def self.find_hot_jobs_by_city_using_regexp(topnum, city)
        db_records = Database::JobOrm.where(addr_no_descript: /.*#{city}.*/).all[0..topnum-1]
        db_records.map{ |db_record| rebuild_entity(db_record) }
      end


      def self.find_jobs_by_blank_link()
        # 這邊使用了regex，傳回欄位中有包含keyword的所有job，而不是完全match
        # 靠北，SQLite不支援regex，Sequel文件說可能只有PostgreSQL跟MySQL能用= =
        # db_records = Database::JobOrm.where(name: /.*#{keyword}.*/).all
        # db_records.map{ |db_record| rebuild_entity(db_record) }
        
        # 這邊暫時先回傳任何Link是空的資料
        db_records = Database::JobOrm.where(link: '').all
        db_records.map{ |db_record| rebuild_entity(db_record) }
      end

      def self.find_jobs_by_user_query(user_query)
        db_records = Database::JobOrm.where(user_query: user_query).all
        db_records.map{ |db_record| rebuild_entity(db_record) }
      end

      def self.find_jobname(jobname)
        db_record = Database::JobOrm.first(name: jobname)
        rebuild_entity(db_record)
      end

      # def self.find_or_create(entity)
      #   find_jobname(entity.name) || create(entity)
      # end

      def self.create(entity)
        # 這邊的create動作會真的把資料存進DB裡面
        db_job = Database::JobOrm.create(
          name: entity.name,
          link: entity.link,
          company: entity.company,
          lng: entity.lng,
          lat: entity.lat,
          address: entity.address,
          addr_no_descript: entity.addr_no_descript,
          # description: entity.description,  
          user_query: entity.user_query 
        )
        
        # rebuild的目的只是傳Entity回去比起傳Dataset回去還好看而已
        self.rebuild_entity(db_job)
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record

        Entity::Job.new(
          rank: db_record.id,
          name: db_record.name,
          link: db_record.link,
          company: db_record.company,
          lng: db_record.lng,
          lat: db_record.lat,
          address: db_record.address,
          addr_no_descript: db_record.addr_no_descript,
          # description: db_record.description,
          user_query: db_record.user_query 
        )
      end
    end
  end
end
