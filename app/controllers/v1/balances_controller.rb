module V1
    class BalancesController < ApplicationController
        include ActionController::Cookies
        before_action :authenticate_request

        def index
            @balances = Balance.where(user_id: decoded_auth_token[:user_id])
            render json: {
                success: true,
                msg: "Data barhasil diambil.",
                data: @balances
            }
        end

        private
        def decoded_auth_token
            if request.headers["JWT"]
                @decoded_auth_token ||= JsonWebToken.decode(request.headers["JWT"])
            else
                @decoded_auth_token ||= JsonWebToken.decode(cookies[:JWT])
            end
        end
    
        def authenticate_request
            if request.headers["JWT"]
                @current_user = AuthorizeApiRequest.call(request.headers["JWT"]).result
            else
                @current_user = AuthorizeApiRequest.call(cookies[:JWT]).result
            end
        
            render json: { error: 'Not Authorized' }, status: 401 unless @current_user
        end
    end
end