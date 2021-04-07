class Api::V1::HelpsController < AuthBaseController
  def index
    if params[:coordinates]
      @helps = Help.by_coordinates(params[:leftLong], params[:rightLong], params[:topLat], params[:bottomLat]).active
    else
      @helps = Help.active
    end
    render json: @helps.as_json(include: {:user => {except: [:password_digest, :government_id]}, :category => {only: [:name, :color]}}), status: :ok
  end

  def create
    @help = logged_in_user.helps.create(help_params)
    if @help.save
      ActionCable.server.broadcast("helps_channel_#{@help.id}", "#{@help.user.first_name} #{@help.user.first_name} just created new help #{@help.title}")
      helps = Help.active
      ActionCable.server.broadcast("help_list_channel", {helps: helps.as_json(include: {:user => {except: [:password_digest, :government_id]}, :category => {only: [:name, :color]}})})
      render json: @help, status: :created
    else
      render json: @help.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @help = Help.find(params[:id])
    if @help.user_id==logged_in_user.id
    @help.destroy
    render json: {message: "Successfuly deleted"}, status: 200

    else
      render json: {message: "You need to be that specific user to delete it"}, status: 404




    end

  end

  def update
    @help = Help.find(params[:id])

    if @help.user_id==logged_in_user.id
      @help.update(help_params)
      render json: {message: "Successfuly updated"}, status: 200
    else
      render json: {message: "You need to be that specific user to update it"}, status: 404

    
    end
  end


  def show
    help = Help.find(params[:id])
    render json: help.to_json(include: {:user => {except: :password_digest}, :category => {only: [:name, :color]}})
  end 

  def me
    @helps = logged_in_user.helps
    render json: @helps.as_json(include: {:category => {only: [:name, :color]}}), status: :ok
  end

  def reopen
    help = Help.find(params[:id])
    help.fulfilment_count = 4
    help.status = false
    if help.save
      render json: {message: 'Help reopoened successfully'}, status: :created
    end
  end

  private 
  def help_params
    params.permit(:title, :description, :category_id, :long, :lat, :status, :user_id)
  end
end