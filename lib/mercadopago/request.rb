require 'faraday'
require 'json'

module MercadoPago

  module Request

    class ClientError < Exception
    end

    #
    # This URL is the base for all API calls.
    #
		MERCADOPAGO_PRODUCTION_URL = 'https://api.mercadopago.com'
		MERCADOPAGO_SANDBOX_URL = 'https://api.mercadopago.com/sandbox'
		if (::Rails.env.development? || ENV["MERCADOPAGO_IS_SANDBOX"])
			MERCADOPAGO_URL = MERCADOPAGO_SANDBOX_URL
		else
    	MERCADOPAGO_URL = MERCADOPAGO_PRODUCTION_URL
    end

    #
    # Makes a POST request to a MercaPago API.
    #
    # - path: the path of the API to be called.
    # - payload: the data to be trasmitted to the API.
    # - headers: the headers to be transmitted over the HTTP request.
    #
    def self.wrap_post(path, payload, headers = {})
      raise ClientError('No data given') if payload.nil? or payload.empty?
      make_request(:post, path, payload, headers)
    end

    #
    # Makes a GET request to a MercaPago API.
    #
    # - path: the path of the API to be called, including any query string parameters.
    # - headers: the headers to be transmitted over the HTTP request.
    #
    def self.wrap_get(path, headers = {})
      make_request(:get, path, nil, headers)
    end

    #
    # Makes a PUT request to a MercaPago API.
    #
    # - path: the path of the API to be called, including any query string parameters.
    # - headers: the headers to be transmitted over the HTTP request.
    #
    def self.wrap_put(path, payload, headers = {})
      make_request(:put, path, payload, headers)
    end

    #
    # Makes a HTTP request to a MercadoPago API.
    #
    # - type: the HTTP request type (:get, :post, :put, :delete).
    # - path: the path of the API to be called.
    # - payload: the data to be trasmitted to the API.
    # - headers: the headers to be transmitted over the HTTP request.
    #
    def self.make_request(type, path, payload = nil, headers = {})
      args = [type, MERCADOPAGO_URL, path, payload, headers].compact

      connection = Faraday.new(MERCADOPAGO_URL)

      response = connection.send(type) do |req|
        req.url path
        req.headers = headers
        req.body = payload
      end

      JSON.load(response.body)
    rescue Exception => e
      if e.respond_to?(:response)
        JSON.load(e.response)
      else
        raise e
      end
    end
  end

end
