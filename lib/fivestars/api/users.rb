module FiveStars
  module API

    module Users
      module Auth
        def user_request_pin(phone)
          post('users/auth/request_pin', body: { phone: phone }.to_json)
        end

        # returns phone_token
        def user_verify_pin(credentials)
          post('users/auth/verify_pin', body: credentials.to_json)
        end

        # returns session_token
        def user_login(credentials)
          post('users/auth/login', body: credentials.to_json)
        end
      end

      module Memberships
        def retrieve_memberships(account_uid, embed_type=nil)
          # embed_type = business_group, promotions, visited_businesses
          get("users/#{account_uid}/memberships", query: { embed: embed_type })
        end

        def retrieve_membership_by_business_group_uid(account_uid, business_group_uid)
          get("users/#{account_uid}/memberships/by-business-group/#{business_group_uid}")
        end

        def add_membership(account_uid, business_group_uid, business_uid)
          post("users/#{account_uid}/memberships", body: { business_group_uid: business_group_uid, business_uid: business_uid })
        end

        def remove_membership(account_uid, membership_uid)
          delete("users/#{account_uid}/memberships/#{membership_uid}")
        end
      end

      include FiveStars::API::Users::Auth
      include FiveStars::API::Users::Memberships 
    end
    
  end
end