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
        def retrieve_memberships(account_uid, type, opts={})
          # type = promotions, rewards, visited_businesses, business_group.businesses
          # opts = { limit: limit_int, offset: offset_int }
          get("users/#{account_uid}/memberships", query: { embed: type }.merge(opts))
        end

        def retrieve_membership_by_business_group_uid(account_uid, business_group_uid, type, opts={})
          # type = promotions, rewards, visited_businesses
          # opts = { limit: limit_int}
          get("/users/#{account_uid}/memberships/by-business-group/#{business_group_uid}", query: { embed: type }.merge(opts))
        end

        # need to revisit this endpoint - @Body RealmAddMembershipRequest.AddMembershipBody body
        # def add_membership(account_uid, type, opts={})
        #   # type = promotions, rewards, visited_businesses
        #   # opts = { limit: limit_int}
        #   post("users/#{account_uid}/memberships", query: { embed: type }.merge(opts))
        # end

        def remove_membership(account_uid, membership_id)
          delete("users/#{account_uid}/memberships/#{membership_id}")
        end
      end

    end
  end
end