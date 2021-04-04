class Api::V1::ProfileController < AuthBaseController
  def index
    render json: logged_in_user.as_json(except: :password_digest), status: :ok
  end
end