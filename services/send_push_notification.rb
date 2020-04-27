require 'fcm'
class SendPushNotification
    def initialize(param)
      @param = param
    end

    def fcm_push_notification
      fcm_client = FCM.new(ENV["FCM_SERVER_KEY"]) 
      options = { priority: 'high',
                  data: { message: message, icon: image },
                  notification: { body: 'message',
                                  title: 'title',
                                  sound: 'default',
                                  icon: 'image.png'
                                }
                }
      registration_ids = ["registration_id1", "registration_id2"]
      #([Array of registration ids up to 1000])
      # Registration ID looks something like: "dAlDYuaPXes:APA91bFEipxfcckxglzRo8N1SmQHqC6g8SWFATWBN9orkwgvTM57kmlFOUYZAmZKb4XGGOOL9wqeYsZHvG7GEgAopVfVupk_gQ2X5Q4Dmf0Cn77nAT6AEJ5jiAQJgJ_LTpC1s64wYBvC"
      response = fcm_client.send(registration_ids, options)
      end
end