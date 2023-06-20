class ApplicationController < ActionController::API
    # before_action :authenticate_request
    before_action :cors_set_access_control_headers

    # attr_reader :current_user
    # helper_method :current_user
  
    # private
  
    # def authenticate_request
    #   @current_user = AuthorizeApiRequest.call(request.headers).result
  
    #   render json: { error: 'Not Authorized' }, status: 401 unless @current_user
    # end

    def cors_set_access_control_headers
      headers['Access-Control-Allow-Origin'] = '*'
      headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
      headers['Access-Control-Request-Method'] = '*'
      headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
    end

    def app_fail_render(msg)
      render json: {
        success: false,
        msg: msg
      }
    end

end 
