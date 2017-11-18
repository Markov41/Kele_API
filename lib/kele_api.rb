require 'httparty'
require 'json'

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
  
  def get_me
    response = self.class.get(base_api_endpoint("users/me"), headers: { "authorization" => @auth_token })
    @user_data = JSON.parse(response.body)
  end
  
  
  private

  def base_api_endpoint(end_point)
    "https://www.bloc.io/api/v1/#{end_point}"
  end
      
end
