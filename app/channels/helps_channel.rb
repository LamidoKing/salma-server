class HelpsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "helps_channel_#{params[:id]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def receive(data)
    ActionCable.server.broadcast("helps_channel_#{params[:id]}", data)
  end
end
