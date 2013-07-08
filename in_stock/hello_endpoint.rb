require 'endpoint_base'
require 'multi_json'

require 'endpoint_base'
require 'multi_json'

class HelloEndpoint < EndpointBase
  post '/' do
    process_result 200, { 'message_id' => @message[:message_id] }
  end

  post '/product_existence_check' do
    product_names = JSON.parse(File.read("product_catalog.json"))['products'].map{|p| p["name"]}

    if product_names.include?(@message[:payload]['product']['name'])
      process_result 200, { 'message_id' => @message[:message_id], 'message' => 'product:in_stock' }
    else
      process_result 200, { 'message_id' => @message[:message_id], 'message' => 'product:not_in_stock' }
    end
  end
end