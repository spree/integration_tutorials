require 'endpoint_base'

class CustomAttributeEndpoint < EndpointBase
  post '/validate_address' do
    get_address    

    begin
      result = DummyShip.validate_address(@address)
      process_result 200, { 'message_id' => @message[:message_id], 'message' => "notification:info",
        "payload" => { "result" => "The address is valid, and the shipment will be sent." } }
    rescue Exception => e
      process_result 200, { 'message_id' => @message[:message_id], 'message' => "notification:error",
        "payload" => { "result" => e.message } }
    end
  end

  post '/get_biz_signer' do
    get_address

    begin
      result = @address['variety'] == "Business" ? "do" : "do not"
      process_result 200, { 'message_id' => @message[:message_id], 'message' => "notification:info", 
        "payload" => { "result" => "You #{result} need to get a signature for this package." } }
    rescue Exception => e
      process_result 200, { 'message_id' => @message[:message_id], 'message' => "notification:error", 
        "payload" => { "result" => e.message} }
    end
  end

  def get_address
    @address = @message[:payload]['order']['ship_address']
  end
end