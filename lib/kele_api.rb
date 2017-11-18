require 'httparty'

class KeleApi
  include HTTParty
  
  def initialize(email, password)
      @base_url = 'https://www.bloc.io/api/v1'
      response = self.class.post(
			"#{@base_url}/sessions", body: { email: email, password: password }
        )

    if response && response["auth_token"]
      @auth_token = response["auth_token"]
      puts "#{email} has sucessfully logged in"
    else
      puts "Login invalid"
    end
  end
      
end
