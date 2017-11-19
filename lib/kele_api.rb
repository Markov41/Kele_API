require 'httparty'
require 'json'
require './lib/roadmap.rb'

class KeleApi
  include HTTParty
  include RoadMap
  
  def initialize(email, password)
      @base_url = 'https://www.bloc.io/api/v1'
      response = self.class.post(
			"#{@base_url}/sessions", body: { email: email, password: password }
        )

    if response && response["auth_token"]
      @auth_token = response["auth_token"]
      puts "#{email} has successfully logged in"
    else
      puts "Login invalid"
    end
  end
  
  def get_me
    response = self.class.get(base_api_endpoint("users/me"), headers: { "authorization" => @auth_token })
    @user_data = JSON.parse(response.body)
  end
  
  def get_mentor_availability(mentor_id)
    response = self.class.get(base_api_endpoint("mentors/#{mentor_id}/student_availability"), headers: { "authorization" => @auth_token })
    @mentor_availability = JSON.parse(response.body)
  end
  
  def get_messages(page=nil)
    if page == nil
    response = self.class.get(base_api_endpoint("message_threads"), headers: { "authorization" => @auth_token })
    else
    response = self.class.get(base_api_endpoint("message_threads"), body: {"page" => page}, headers: { "authorization" => @auth_token })
    end
    @messages = JSON.parse(response.body)
  end
  
  def create_message(sender, recipient_id, token=nil, subject, stripped_text)
    response = self.class.post(base_api_endpoint("messages"),
    body: {
      "sender": sender,
      "recipient_id": recipient_id,
      "token": token,
      "subject": subject,
      "stripped-text": stripped_text
    },
    headers: {"authorization" => @auth_token})
    JSON.parse(response.body)
  end
  
  
  private

  def base_api_endpoint(end_point)
    "https://www.bloc.io/api/v1/#{end_point}"
  end
      
end
