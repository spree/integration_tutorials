require 'endpoint_base'
require 'multi_json'

class HelloEndpoint < EndpointBase
  post '/' do
    process_result 200, { 'message_id' => @message[:message_id] }
  end

  post '/product_existence_check' do
    product_names = JSON.parse(File.read("product_catalog.json"))['products'].map{|p| p["name"]}

    if product_names.include?(@message[:payload]['product']['name'])
      process_result 200, { 'message_id' => @message[:message_id], 
                            'noticiations' => [ 
                              { 'level' => 'info', 'subject' => 'product exists' , 'description' => 'product exists in the database'} ] }
    else
      process_result 200, { 'message_id' => @message[:message_id], 
                            'notifications' => [
                              { 'level' => 'warn', 'subject' => 'product does not exsit', 'description' => 'product does not exist in the database' } ] }
    end
  end

  post '/query_price' do
    ## Find the product whose name matches what we're passing.
    if product = products.find { |product| product['name'] == passed_in_name }
      process_result 200, { 'message_id' => @message[:message_id],
                            'messages' => [
                              { 'message' => 'product:in_stock',
                                'payload' => {
                                  'product' => {
                                    'name' => product['name'],
                                    'price' => product['price'] }
                                }
                              }
                            ]
                          }

    else
      process_result 200, { 'message_id' => @message[:message_id], 
                            'messages' => [
                              { 'message' => 'product:not_in_stock',
                                'payload' => {} }
                            ]
                          }
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
