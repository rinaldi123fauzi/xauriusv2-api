class ApplicationController < ActionController::API
    # before_action :authenticate_request

    # attr_reader :current_user
    # helper_method :current_user
  
    # private
  
    # def authenticate_request
    #   @current_user = AuthorizeApiRequest.call(request.headers).result
  
    #   render json: { error: 'Not Authorized' }, status: 401 unless @current_user
    # end

    def app_fail_render(msg)
      render json: {
        success: false,
        msg: msg
      }
    end

end 
