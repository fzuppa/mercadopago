module MercadoPago

  module Preapproval

    #
    # Allows you to create a recurring payment
    # Receives an access_token and a preferences hash and creates a new checkout preference.
    # Once you have created the preapproval, you can use the init_point URL
    # to start the payment flow.
    #
    # - access_token: the MercadoPago account associated with this access_token will
    #                 receive the money from the payment of this checkout preference.
    # - data: a hash of preferences that will be trasmitted to checkout API.
    #
    def self.create_preapproval_payment(access_token, data)
      payload = JSON.generate(data)
      headers = { content_type: 'application/json', accept: 'application/json' }

      MercadoPago::Request.wrap_post("/preapproval?access_token=#{access_token}", payload, headers)
    end

    # Returns the hash with the details of certain preapproval payment.
    #
    # - access_token: the MercadoPago account access token
    # - id: the preapproval ID
    #
    def self.get_preference(access_token, preapproval_payment_id)
      headers = { accept: 'application/json' }
      MercadoPago::Request.wrap_get("/preapproval/#{preapproval_payment_id}?access_token=#{access_token}")
    end

    # Cancel recurring payment
    def self.cancel_preapproval_payment(access_token, preapproval_payment_id)
      headers = { content_type: 'application/json', accept: 'application/json' }
      cancel_status = {"status" => "cancelled"}
      MercadoPago::Request.wrap_put("/preapproval/#{preapproval_payment_id}?access_token=#{access_token}", cancel_status, headers)
    end


  end

end
