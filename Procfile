web: bundle exec puma -t 5:5 -p ${PORT:-3000} -e ${RACK_ENV:-development}
worker: bundle exec shoryuken -r ./workers/find_hot_jobs_worker.rb -C ./workers/shoryuken.yml