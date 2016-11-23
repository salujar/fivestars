require 'spec_helper'

describe 'Login and Memberships' do 

  before :all do
    @credentials = { phone: '5555541943', pin: '1234' }
    # @business_group_uid = 'd68d99cc15784871a33333a628721a76' #'9cb770acd33b47ad97e57a32ca65f1fc'

    @client = FiveStars::Client.new(@credentials)
    @phone_token = @client.verify_pin
    # @session_token = @client.user_auth  # a new session_token will be generated everytime it is requested
    puts "\nUsing user credentails = #{@credentials}\n\n"
  end

  context "Login" do 
    # users/auth/verify_pin
    it ": should able to verify pin using valid phone:pin" do
      response = @client.user_verify_pin(@credentials)
      expect(@client.pin_verified?(response)).to eq true
    end

    it ": should return Error 401 Unauthorized if verify pin using invalid phone:pin" do 
      @credentials = { phone: '5555541943', pin: '1234999' }
      response = @client.user_verify_pin(@credentials)
      expect(response.code).to eq 401
    end

    # users/auth/login
    it ": should able to authenticate using valid phone:phone_token" do 
      payload = { phone: @credentials[:phone], phone_token: @phone_token }
      response = @client.user_login(payload)
      expect(@client.logged_in?(response)).to eq true
    end

    it ": should return Error 401 Unauthorized if authenticate using invalid phone:phone_token" do 
      payload = { phone: @credentials[:phone], phone_token: 'invalid_phone_token_blah' }
      response = @client.user_login(payload)
      expect(response.code).to eq 401
    end
  end

  context 'Memberships', in_development: true do 

  end

    
  # response = @client.retrieve_user_memberships(@business_group_uid)
end