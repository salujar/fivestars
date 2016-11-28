require 'spec_helper'

describe 'User Login and Memberships' do 

  before :all do
    @credentials = { phone: '5555541943', pin: '1234' }
    @business_group_uid = '9cb770acd33b47ad97e57a32ca65f1fc'
    @business_uid = '5265e8f45f9449bba29d278d72ff87fa'

    @client = FiveStars::Client.new(@credentials)
    @phone_token = @client.verify_pin
    # @session_token = @client.user_auth  # a new session_token will be generated everytime it is requested
    puts "\nuser credentials   = #{@credentials}"
    puts "business_group_uid = #{@business_group_uid}"
    puts "business_uid       = #{@business_uid}\n\n"

  end

  describe 'User Login' do 
    context 'POST users/auth/verify_pin' do
      it ': should able to verify pin using valid phone:pin' do
        response = @client.user_verify_pin(@credentials)
        expect(@client.pin_verified?(response)).to eq true
      end

      it ': should return Error 401 Unauthorized if verify pin using invalid phone:pin' do 
        @credentials = { phone: @credentials[:phone], pin: "#{Time.new.to_i}" }
        response = @client.user_verify_pin(@credentials)
        expect(response.code).to eq 401
      end
    end

    context 'POST users/auth/login' do
      it ': should able to authenticate using valid phone:phone_token' do 
        payload = { phone: @credentials[:phone], phone_token: @phone_token }
        response = @client.user_login(payload)
        expect(@client.logged_in?(response)).to eq true
      end

      it ': should return Error 401 Unauthorized if authenticate using invalid phone:phone_token' do 
        payload = { phone: @credentials[:phone], phone_token: 'invalid_phone_token_blah' }
        response = @client.user_login(payload)
        expect(response.code).to eq 401
      end
    end
  end

  describe 'User Memberships' do 
    before :all do
      @session_token = @client.user_auth
      payload = { phone: @credentials[:phone], phone_token: @phone_token }
      response = @client.user_login(payload)
      @account_uid = @client.get_account_uid(response)
    end

    context 'GET users/:account_uid/memberships' do 
      it ': should return user memberships by account_uid' do 
        response = @client.retrieve_memberships(@account_uid)
        expect(response.code).to eq 200
        expect(@client.is_list_memberships?(response)).to eq true
      end

      it ': should return Error 404 Not Found if user account_uid is invalid' do
        response = @client.retrieve_memberships("invalid_account_uid_#{Time.new.to_i}")
        expect(response.code).to eq 404
      end
    end
  
    context 'GET users/:account_uid/memberships/by-business-group/:business_group_uid' do
      it ': should return memberships by business_group_uid' do
        response = @client.retrieve_memberships(@account_uid)
        business_group_uids = @client.get_list_business_group_uids(response)

        if !business_group_uids.empty?
          response = @client.retrieve_membership_by_business_group_uid(@account_uid, business_group_uids.first)
          expect(@client.get_business_group_uid(response)).to eq business_group_uids.first
          expect(@client.is_a_membership?(response)).to eq true
        end
      end

      it ': should return Error 404 Not Found if user business_group_uid is invalid' do
        response = @client.retrieve_membership_by_business_group_uid(@account_uid, "invalid_business_group_uid_#{Time.new.to_i}")
        expect(response.code).to eq 404
      end
    end

    context 'POST users/:account_uid/memberships' do 
      before :all do
        # @business_group_uid = '9cb770acd33b47ad97e57a32ca65f1fc'
        # @business_uid = '5265e8f45f9449bba29d278d72ff87fa'
        # before add: ["4def0b9054ad40c69e49e8d44b44fe13", "fc883b44a50f4189975b1bcb71fa2f89", "d7d9c34665864043b00dbf9566dafad1", "07aef728f40d456789a798bb261d3616",
        # after add : ["4def0b9054ad40c69e49e8d44b44fe13", "fc883b44a50f4189975b1bcb71fa2f89", "d7d9c34665864043b00dbf9566dafad1", "07aef728f40d456789a798bb261d3616", "9cb770acd33b47ad97e57a32ca65f1fc"]
  
        # remove user membership if @business_group_uid already existed, so it can be used to test the add membership API endpoint
        response = @client.retrieve_membership_by_business_group_uid(@account_uid, @business_group_uid)
        if response.code == 200 # membership existed
          membership_uid = @client.get_membership_uid(response)
          response = @client.remove_membership(@account_uid, membership_uid)
          expect(response.code).to eq 204
          # expect(response.parsed_response).to eq nil
        end
      end

      it ': should add new membership' do 
        # validate the add membership response
        response = @client.add_membership(@account_uid, @business_group_uid, @business_uid)
        expect(response.code).to eq 201
        expect(@client.get_business_group_uid(response)).to eq @business_group_uid

        # validate the new membership is properly added to memberships
        response = @client.retrieve_memberships(@account_uid)
        expect(@client.has_business_group_by_uid?(response, @business_group_uid)).to eq true      
      end

      it ": should NOT duplicate membership if already existed" do 
        response = @client.retrieve_memberships(@account_uid)
        membership_size_before = @client.get_business_group_memberships_count(response)

        # add existing membership again
        2.times do
          response = @client.add_membership(@account_uid, @business_group_uid, @business_uid)
          expect(response.code).to eq 201
        end

        # validate there's no duplicates
        response = @client.retrieve_memberships(@account_uid)
        membership_size_current = @client.get_business_group_memberships_count(response)
        expect(membership_size_current).to eq membership_size_before
      end

      it ': should return Error code 404 Not Found if business_uid is invalid' do
        response = @client.add_membership(@account_uid, @business_group_uid, "invalid_business_uid_#{Time.new.to_i}")
        expect(response.code).to eq 404
      end
    end

    context 'DELETE users/:account_uid/memberships/:membership_uid' do 
      before :all do
        response = @client.add_membership(@account_uid, @business_group_uid, @business_uid)
        expect(response.code).to eq 201
        @membership_uid = @client.get_membership_uid(response)
      end

      it ': should remove user membership by membership_uid' do
        response = @client.remove_membership(@account_uid, @membership_uid)
        expect(response.code).to eq 204
      end

      it ': should return Error code 404 Not Found if membership_uid is invalid' do
        response = @client.remove_membership(@account_uid, "invalid_membership_uid_#{Time.new.to_i}")
        expect(response.code).to eq 404
      end
    end

  end
end