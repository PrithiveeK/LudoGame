class NotifyUserJob < ApplicationJob
  queue_as :default    

  def perform(message, to_whom:)
    NotificationChannel.broadcast_to(
      to_whom,
      message: message
    )
  end
end
