require 'endpoint_base'
require 'multi_json'

class FulfillmentEndpoint < EndpointBase
  post '/drop_ship' do
    get_address
    @order = @message[:payload]['order']
    begin
      result = DummyShip.ship_package(@address, @order)
      process_result 200, [ { 'message_id' => @message[:message_id], 'message' => "notification:info",
        "payload" => { "result" => "The address is valid, and the shipment will be sent." } },
        { 'message_id' => @message[:message_id], 'message' => "shipment:confirm",
        "payload" => { "tracking_number" => result.tracking_number, "ship_date" => result.ship_date } } ]
    rescue Exception => e
      process_result 200, { 'message_id' => @message[:message_id], 'message' => "notification:error",
        "payload" => { "result" => "There was a problem with this address." } }
    end
  end

  post '/validate_address' do
    get_address

    begin
      result = DummyShip.validate_address(@address)
      process_result 200, { 'message_id' => @message[:message_id], 'message' => "notification:info",
        "payload" => { "result" => "The address is valid, and the shipment will be sent." } }
    rescue Exception => e
      process_result 200, { 'message_id' => @message[:message_id], 'message' => "notification:error",
        "payload" => { "result" => "There was a problem with this address." } }
    end
  end

  def get_address
    @address = @message[:payload]['order']['shipping_address']
  end
end