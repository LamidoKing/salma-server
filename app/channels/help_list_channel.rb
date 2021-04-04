class HelpListChannel < ApplicationCable::Channel
  def subscribed
    stream_from "help_list_channel"
    @helps = Help.active
    ActionCable.server.broadcast("help_list_channel", {helps: @helps.as_json(include: {:user => {except: [:password_digest, :government_id]}, :category => {only: [:name, :color]}})})
  end

  def unsubscribed
    
  end

  def receive(data)
  
  end
end