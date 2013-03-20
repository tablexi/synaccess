require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir  = File.join(File.dirname(__FILE__), '..', 'vcr')
  c.allow_http_connections_when_no_cassette = true
  c.hook_into :webmock
end

RSpec.configure do |c|
  c.treat_symbols_as_metadata_keys_with_true_values = true
  c.around(:each, :vcr) do |example|
    name = example.metadata[:full_description].split(/\s+/, 2).join("/").downcase.gsub(/[^\w\/]+/, "_")
    VCR.use_cassette(name) { example.call }
  end
end