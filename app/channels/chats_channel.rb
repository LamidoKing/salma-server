class ChatsChannel < ApplicationCable::Channel
  def subscribed
    @help = Help.find(params[:id]) 
    stream_for @help
    chats = @help.chats
    data = {initial: true, chats: chats.to_json(include: user_relation), help: @help.to_json(include: user_relation)}
    self.broadcast_to(@help, data)
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def receive(data)
    # data['chat'] = @help.to_json(include: {:user => {only: [:first_name, :last_name]}})
    # self.broadcast_to(@help, data)
  end

  def typing(data)
    p data
    data
  end

  private
    def user_relation
      {:user => {only: [:first_name, :last_name]}}
    end
end
