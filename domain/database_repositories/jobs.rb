# frozen_string_literal: true

module ThxSeafood
    module Repository
      # Repository for Jobs
      class Jobs
        def self.find_id(id)
          db_record = Database::JobOrm.first(id: id)
          rebuild_entity(db_record)
        end
  
        def self.find_jobname(jobname)
          db_record = Database::JobOrm.first(name: jobname)
          rebuild_entity(db_record)
        end
  
        def self.find_or_create(entity)
          find_jobname(entity.name) || create_from(entity)
        end
  
        def self.create_from(entity)
          db_job = Database::JobOrm.create(
            name: entity.name,
            link: entity.link,
            company: entity.company
          )
  
          self.rebuild_entity(db_job)
        end
  
        def self.rebuild_entity(db_record)
          return nil unless db_record
  
          Entity::Job.new(
            id: db_record.id,
            name: db_record.name,
            link: db_record.link,
            company: db_record.company
          )
        end
      end
    end
  end
  