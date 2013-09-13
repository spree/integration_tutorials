require 'endpoint_base'

class FulfillmentEndpoint < EndpointBase
  post '/drop_ship' do
    process_result 200, { 'message_id' => @message[:message_id] }
  end

  post '/validate_address' do
    address = @message[:payload]['order']['shipping_address']

    begin
      result = DummyShip.validate_address(address)
      process_result 200, { 'message_id' => @message[:message_id], 
                            'notifications' => [
                              { 'level' => "info",
                                'subject' => "",
                                'description' => "The address is valid, and the shipment will be sent." }
                            ]
                          }

    rescue Exception => e
      process_result 200, { 'message_id' => @message[:message_id],
                            'notifications' => [
                              { 'level' => "error",
                                'subject' => 'address is invalid',
                                'description' => e.message }
                            ]
                          }
    end
  end
end
