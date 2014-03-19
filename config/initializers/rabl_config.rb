Rabl.configure do |config|
  config.include_json_root = false
  config.include_child_root = false
  config.cache_all_output = true
  config.cache_sources = true 
  config.cache_engine = Rabl::CacheEngine.new
  config.perform_caching = true
end
