require 'endpoint_base'

Dir['./lib/*.rb'].each { |f| require f }

class FulfillmentEndpoint < EndpointBase
  post '/drop_ship' do
    get_address
    @order = @message[:payload]['order']

    begin
      result = DummyShip.ship_package(@address, @order)
      process_result 200, { 'message_id' => @message[:message_id], 
                            'notifications' => [
                              { 'level' => 'info',
                                'subject' => '',
                                'description' => 'The address is valid, and the shipment will be sent.' }
                            ],
                            'parameters' => [
                              { 'name' => 'tracking_number', 'value' => result.tracking_number },
                              { 'name' => 'ship_date', 'value' => result.ship_date }
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

  def get_address
    @address = @message[:payload]['order']['shipping_address']
  end

end
