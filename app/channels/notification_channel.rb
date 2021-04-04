class NotificationChannel < ApplicationCable::Channel
  def subscribed
    @help = Help.find(params[:id]) 
    stream_for @help
  end

  def receive(data)
    if data['key'] == 'typing'
      @message = current_user.first_name + ' is typing...'
    else
      @message = ' '
    end
    
    self.broadcast_to(@help, {data: data['key'], message: @message})
  end
end