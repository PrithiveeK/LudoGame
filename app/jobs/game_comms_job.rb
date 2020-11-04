class GameCommsJob < ApplicationJob
  queue_as :default

  def perform(action, payload, to_where:)
    ActionCable.server.broadcast(
      to_where,
      action: action,
      payload: payload
    )
  end
end