require 'sinatra'
require 'endpoint_base'

class HelloEndpoint < EndpointBase::Sinatra::Base
  post '/' do
    process_result 200
  end

  post '/product_existence_check' do
    if product_names.include?(@message[:payload]['product']['name'])
      add_notification 'info', 'product exists', 'product exists in the database'

      process_result 200
    else
      add_notification 'info', 'product does not exists', 'product does not exists in the database'

      process_result 200
    end
  end

  post '/query_price' do
    ## Find the product whose name matches what we're passing.
    if product = products.find { |product| product['name'] == passed_in_name }
      add_message 'product:in_stock', { 'product' => {
                                          'name' => product['name'],
                                          'price' => product['price'] } }

      process_result 200

    else
      add_message 'product:not_in_stock', {}

      process_result 200
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
