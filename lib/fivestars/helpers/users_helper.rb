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

    # memberships
    def is_list_memberships?(response)
      expected_attrs = ["items", "meta"]
      response.keys.sort == expected_attrs.sort && response.keys.is_a?(Array)
    end

    def is_a_membership?(response)
      expected_attrs = ["business_group_uid", "created_at", "last_visit", "lifetime_points", "meta", "points", "uid", "user_uid", "vip", "visits"]
      response.keys.sort == expected_attrs.sort
    end

    def get_list_business_group_uids(response)
      memberships_items = list_business_group_memberships(response)
      memberships_items.map do |membership_item|
        membership_item['business_group_uid']
      end
    end

    def get_business_group_memberships_count(response)
      memberships = list_business_group_memberships(response)
      memberships.size
    end

    def get_business_group_uid(response)
      response['business_group_uid']
    end

    def get_membership_uid(response)
      response['uid']
    end

    def has_business_group_by_uid?(response, uid)
      business_group_uids = get_list_business_group_uids(response)
      business_group_uids.include?(uid)
    end

    def get_list_membership_uids(response)
      memberships_items = list_business_group_memberships(response)
      memberships_items.map do |membership_item|
        membership_item['uid']
      end
    end

    # return an array of business group memberships
    def list_business_group_memberships(response)
      response['items']
    end



  end
end


# 5555541943 
# ["4def0b9054ad40c69e49e8d44b44fe13", "fc883b44a50f4189975b1bcb71fa2f89", "d7d9c34665864043b00dbf9566dafad1", "07aef728f40d456789a798bb261d3616"]

    # remove 07aef728f40d456789a798bb261d3616

# 5555541942
["c3c18ab8031543fb92d0bf1d9969fb13", "22e377cdd4b2426381e1a9582a287862", "b3065dc3b8fd408481cd4f4edafe348e", "5e633c68ab504e5daa4c49d9554ad7d7", "28118313178f4d2e99d04d2ceb46d2d9", "d028cdac50d14196a137b74fccdd304c"]


# ex: POST /verify_in response
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

# ex: POST /login response
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

# ex: GET /memberships
# {
#   "items": [
#     {
#       "business_group_uid": "4def0b9054ad40c69e49e8d44b44fe13",
#       "created_at": "2014-01-28T15:16:30.600696",
#       "last_visit": "2014-01-28T15:16:30.600696",
#       "lifetime_points": 1,
#       "meta": {
#         "embed": {
#         },
#         "links": {
#           "business_group": {
#             "href": "/api/unified/business-groups/4def0b9054ad40c69e49e8d44b44fe13",
#             "type": "document"
#           },
#           "promotions": {
#             "href": "/api/unified/users/117faace984a43e1b338bae7315f4ca4/promotions/by-business-group/4def0b9054ad40c69e49e8d44b44fe13",
#             "type": "collection"
#           },
#           "rewards": {
#             "href": "/api/unified/business-groups/4def0b9054ad40c69e49e8d44b44fe13/rewards",
#             "type": "collection"
#           },
#           "self": {
#             "href": "/api/unified/users/117faace984a43e1b338bae7315f4ca4/memberships/3c5ae30a0d424e8dac40210dc2272575",
#             "type": "document"
#           },
#           "visited_businesses": {
#             "href": "/api/unified/users/117faace984a43e1b338bae7315f4ca4/memberships/3c5ae30a0d424e8dac40210dc2272575/visited_businesses",
#             "type": "collection"
#           }
#         }
#       },
#       "points": 1,
#       "uid": "3c5ae30a0d424e8dac40210dc2272575",
#       "user_uid": "1ee56d1bff3d41dca3668c56233e4538",
#       "vip": null,
#       "visits": 1
#     },
#     {
#       "business_group_uid": "fc883b44a50f4189975b1bcb71fa2f89",
#       "created_at": "2014-11-21T08:54:37.535418",
#       "last_visit": null,
#       "lifetime_points": 0,
#       "meta": {
#         "embed": {
#         },
#         "links": {
#           "business_group": {
#             "href": "/api/unified/business-groups/fc883b44a50f4189975b1bcb71fa2f89",
#             "type": "document"
#           },
#           "promotions": {
#             "href": "/api/unified/users/117faace984a43e1b338bae7315f4ca4/promotions/by-business-group/fc883b44a50f4189975b1bcb71fa2f89",
#             "type": "collection"
#           },
#           "rewards": {
#             "href": "/api/unified/business-groups/fc883b44a50f4189975b1bcb71fa2f89/rewards",
#             "type": "collection"
#           },
#           "self": {
#             "href": "/api/unified/users/117faace984a43e1b338bae7315f4ca4/memberships/e968ed5ee0104c83be67c54f7c9e0319",
#             "type": "document"
#           },
#           "visited_businesses": {
#             "href": "/api/unified/users/117faace984a43e1b338bae7315f4ca4/memberships/e968ed5ee0104c83be67c54f7c9e0319/visited_businesses",
#             "type": "collection"
#           }
#         }
#       },
#       "points": 0,
#       "uid": "e968ed5ee0104c83be67c54f7c9e0319",
#       "user_uid": "1ee56d1bff3d41dca3668c56233e4538",
#       "vip": null,
#       "visits": 0
#     },
#     {
#       "business_group_uid": "d7d9c34665864043b00dbf9566dafad1",
#       "created_at": "2016-08-23T16:15:10.619638",
#       "last_visit": null,
#       "lifetime_points": 1,
#       "meta": {
#         "embed": {
#         },
#         "links": {
#           "business_group": {
#             "href": "/api/unified/business-groups/d7d9c34665864043b00dbf9566dafad1",
#             "type": "document"
#           },
#           "promotions": {
#             "href": "/api/unified/users/117faace984a43e1b338bae7315f4ca4/promotions/by-business-group/d7d9c34665864043b00dbf9566dafad1",
#             "type": "collection"
#           },
#           "rewards": {
#             "href": "/api/unified/business-groups/d7d9c34665864043b00dbf9566dafad1/rewards",
#             "type": "collection"
#           },
#           "self": {
#             "href": "/api/unified/users/117faace984a43e1b338bae7315f4ca4/memberships/6030d2a3a53e466aa13707fb86ecac1d",
#             "type": "document"
#           },
#           "visited_businesses": {
#             "href": "/api/unified/users/117faace984a43e1b338bae7315f4ca4/memberships/6030d2a3a53e466aa13707fb86ecac1d/visited_businesses",
#             "type": "collection"
#           }
#         }
#       },
#       "points": 1,
#       "uid": "6030d2a3a53e466aa13707fb86ecac1d",
#       "user_uid": "1ee56d1bff3d41dca3668c56233e4538",
#       "vip": null,
#       "visits": 0
#     },
#     {
#       "business_group_uid": "07aef728f40d456789a798bb261d3616",
#       "created_at": "2016-10-01T13:40:15.156283",
#       "last_visit": null,
#       "lifetime_points": 1,
#       "meta": {
#         "embed": {
#         },
#         "links": {
#           "business_group": {
#             "href": "/api/unified/business-groups/07aef728f40d456789a798bb261d3616",
#             "type": "document"
#           },
#           "promotions": {
#             "href": "/api/unified/users/117faace984a43e1b338bae7315f4ca4/promotions/by-business-group/07aef728f40d456789a798bb261d3616",
#             "type": "collection"
#           },
#           "rewards": {
#             "href": "/api/unified/business-groups/07aef728f40d456789a798bb261d3616/rewards",
#             "type": "collection"
#           },
#           "self": {
#             "href": "/api/unified/users/117faace984a43e1b338bae7315f4ca4/memberships/4b480c36bbd94d90a4872f6ebc6fe80e",
#             "type": "document"
#           },
#           "visited_businesses": {
#             "href": "/api/unified/users/117faace984a43e1b338bae7315f4ca4/memberships/4b480c36bbd94d90a4872f6ebc6fe80e/visited_businesses",
#             "type": "collection"
#           }
#         }
#       },
#       "points": 1,
#       "uid": "4b480c36bbd94d90a4872f6ebc6fe80e",
#       "user_uid": "1ee56d1bff3d41dca3668c56233e4538",
#       "vip": null,
#       "visits": 0
#     }
#   ],
#   "meta": {
#     "limit": 20,
#     "next": null,
#     "offset": 0,
#     "previous": null,
#     "total_count": 4
#   }
# }
