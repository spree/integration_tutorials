class Shipment
  attr_reader :tracking_number, :mailing_address, :ship_date

  def initialize(order)
    ## This method runs when the new method is called on a Shipment object.
    @tracking_number = generate_shipment_number
    @mailing_address = order['shipping_address']
    @ship_date = Date.today
  end

  def generate_shipment_number
    record = true
    random = "S#{Array.new(6){rand(6)}.join}"
    random
  end
end