module DummyShip
  def self.ship_package(address, order)
    validate_address(address)
    shipment = Shipment.new(order)
    shipment
  end

  def self.validate_address(address)
    ## Zipcode must be within a given range.
    unless (20170..20179).to_a.include?(address['zipcode'].to_i)
      halt 406
    end
  end
end