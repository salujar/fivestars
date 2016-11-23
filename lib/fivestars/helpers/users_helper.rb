module FiveStars
  module UsersHelper
    # verify pin ressponse
    def has_phone_token?(response)
      get_phone_token(response) != nil
    end

    def get_phone_token(response)
      response['phone_token']
    end

    def pin_verified?(response)
      expected_attrs = ["meta", "phone_token"]
      response.keys.sort == expected_attrs.sort  && has_phone_token?(response)
    end

    # user login response
    def logged_in?(response)
      expected_attrs = ["account_uid", "expires", "meta", "session_token"]
      response.keys.sort == expected_attrs.sort && has_session_token?(response)
    end

    def has_session_token?(response)
      get_session_token(response) != nil
    end

    def get_session_token(response)
      response['session_token']
    end

    def get_account_uid(response)
      response['account_uid'].to_s
    end

  end
end

# ex: user /verify_in response
# {
#   "meta": {
#     "embed": {
#     },
#     "links": {
#       "login": {
#         "href": "/login",
#         "type": "controller"
#       },
#       "request_pin": {
#         "href": "/request_pin",
#         "type": "controller"
#       },
#       "user": {
#         "href": "/api/unified/users/me",
#         "type": "document"
#       },
#       "verify_pin": {
#         "href": "/verify_pin",
#         "type": "controller"
#       }
#     }
#   },
#   "phone_token": "rqPkHEJSHiAFPSx31UG8RXrpjrZ2pyOxujWuyNszoGmdoeW46FyXM76h4ZNcSGio56vfxTEqvp0mnF7kdPu4XLCpmSPheCxdZPJcb5asOQoydhwHMFFmCKa0LsB3Fu46"
# }

# ex: user /login response
# {
#   "account_uid": "117faace984a43e1b338bae7315f4ca4",
#   "expires": "2016-12-07T10:49:46.938690",
#   "meta": {
#     "embed": {
#     },
#     "links": {
#       "login": {
#         "href": "/login",
#         "type": "controller"
#       },
#       "request_pin": {
#         "href": "/request_pin",
#         "type": "controller"
#       },
#       "user": {
#         "href": "/api/unified/users/117faace984a43e1b338bae7315f4ca4",
#         "type": "document"
#       },
#       "verify_pin": {
#         "href": "/verify_pin",
#         "type": "controller"
#       }
#     }
#   },
#   "session_token": "fufvt0bul4k5t1meei3jiftx1nmukqjx"
# }