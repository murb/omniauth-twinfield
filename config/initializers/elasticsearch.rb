hosts = begin
  Rails.application.config.elasticsearch[:hosts]
rescue NoMethodError
  [{
    host: 'localhost',
    port: '9200'
  }]
end
Elasticsearch::Model.client = Elasticsearch::Client.new hosts: hosts