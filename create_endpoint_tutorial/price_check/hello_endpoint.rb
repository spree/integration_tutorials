require 'endpoint_base'
require 'multi_json'

class HelloEndpoint < EndpointBase
  post '/' do
    process_result 200, { 'message_id' => @message[:message_id] }
  end

  post '/product_existence_check' do
    if product_names.include?(passed_in_name)
      process_result 200, { 'message_id' => @message[:message_id], 'message' => 'notification:info' }
    else
      process_result 200, { 'message_id' => @message[:message_id], 'message' => 'notification:warn' }
    end
  end

  post '/query_price' do
    ## Find the product whose name matches what we're passing.
    if product = products.find { |product| product['name'] == passed_in_name }
      process_result 200, { 'message_id' => @message[:message_id], 'message' => 'product:in_stock',
        'payload' => { 'product' => { 'name' => product['name'], 'price' => product['price'] }}}
    else
      process_result 200, { 'message_id' => @message[:message_id], 'message' => 'product:not_in_stock' }
    end
  end

private
  def product_names
    @product_names ||= products.map { |product| product["name"] }
  end

  def products
    @products ||= JSON.parse(File.read("product_catalog.json"))['products']
  end

  def passed_in_name
    @passed_in_name ||= @message[:payload]['product']['name']
  end
end