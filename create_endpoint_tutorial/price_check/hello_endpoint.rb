require 'endpoint_base'
require 'multi_json'

class HelloEndpoint < EndpointBase
  post '/' do
    process_result 200, { 'message_id' => @message[:message_id] }
  end

  post '/product_existence_check' do
    get_product_names

    if @product_names.include?(@message[:payload]['product']['name'])
      process_result 200, { 'message_id' => @message[:message_id], 'message' => 'notification:info' }
    else
      process_result 200, { 'message_id' => @message[:message_id], 'message' => 'notification:warn' }
    end
  end

  post '/query_price' do
    passed_in_name = @message[:payload]['product']['name']
    get_product_names

    if @product_names.include?(passed_in_name)
      ## Find the product whose name matches what we're passing.
      product = JSON.parse(File.read("product_catalog.json"))['products'].find{ |x| x['name'] == passed_in_name }
      process_result 200, { 'message_id' => @message[:message_id], 'message' => 'product:in_stock',
        'payload' => { 'product' => { 'name' => product['name'], 'price' => product['price'] }}}
    else
      process_result 200, { 'message_id' => @message[:message_id], 'message' => 'product:not_in_stock' }
    end
  end

private
  def get_product_names
    @product_names = JSON.parse(File.read("product_catalog.json"))['products'].map{|p| p["name"]}
  end
end