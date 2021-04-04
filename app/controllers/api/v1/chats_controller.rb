class Api::V1::ChatsController < AuthBaseController
  def create
    chat = Chat.create chat_params
  #  help = Help.find(chat_params[:help_id])
    if chat.save
      help = chat.help
      volunteer_chats = Chat.where(user_id: chat.user.id, help_id: help.id).count 
      if (volunteer_chats < 2) && (chat.user.id != help.user_id) 
        help.fulfilment_count = help.fulfilment_count + 1
        help.save
      end
      ChatsChannel.broadcast_to(help, chat.to_json(include: user_relation))
      render json: chat.to_json(include: user_relation), status: :created
    end
  end

  def fetch_for_help
    chats = Chat.includes(:user).where(help_id: params[:help_id]).order(created_at: :desc)
    render json: chats.to_json(include: user_relation)
  end
 
  private
   def chat_params
    params.permit(:message, :help_id, :user_id)
   end  

   def user_relation
    {:user => {only: [:id, :first_name, :last_name]}}
   end
end