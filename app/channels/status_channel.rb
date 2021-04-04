class StatusChannel < ApplicationCable::Channel
  def subscribed
    @help = Help.find(params[:id]) 
    stream_for @help
  end

end
