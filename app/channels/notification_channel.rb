class NotificationChannel < ApplicationCable::Channel
  def subscribed
    stream_for current_user
    NotifyUserJob.perform_now("Greetings #{current_user.username}", to_whom: current_user)
  end

  def mark_as_read
    # Mark unread notifications as read
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
