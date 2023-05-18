module V1
    module Admin
        class VerifyController < ApplicationController
            include ActionController::Cookies
            before_action :authenticate_request

            def deposit
                if decoded_auth_token[:role] == "admin"
                    user_id = params[:user_id]
                    @deposits = Deposit.where(user_id: user_id, status: "Menunggu verifikasi admin").first
                    if @deposits.present?
                        @deposits.status = "Terverifikasi"
                        if @deposits.save
                            @checkBalances = Balance.find_by_user_id(user_id)
                            if @checkBalances
                                @sum = @deposits.total + @checkBalances.balance_value
                                @checkBalances.balance_value = @sum          
                                @checkBalances.currency = "IDR"
                                @checkBalances.save
                            else
                                @balance = Balance.new
                                @balance.balance_value = @deposits.total          
                                @balance.currency = "IDR"  
                                @balance.user_id = user_id 
                                @balance.save       
                            end 
                            render json: {success: true, msg:'Deposits is verified', data:@deposits}, status: :ok
                        else
                            render json: {success: false, msg:'Deposits is not verified', data:@deposits.error}, status: :ok
                        end
                    else
                        render json: {success: false, msg:'User tidak ditemukan / Deposit sudah terverifikasi'}, status: :ok
                    end
                else
                    render json: {success: false, msg:'Not Authorized'}, status: :ok
                end
            end

            def kyc
                if decoded_auth_token[:role] == "admin"
                    user_id = params[:user_id]
                    @profiles = Profile.find_by_user_id(user_id)
                    if @profiles.present?
                        if @profiles.status_kyc == false
                            @profiles.status_kyc = true
                            if @profiles.save
                                render json: {success: true, msg:'KYC Terverifikasi', data: @profiles}, status: :ok
                            else
                                render json: {success: false, msg:'KYC gagal verifikasi', data: @profiles.error}, status: :ok
                            end
                        else
                            render json: {success: false, msg:'KYC Sudah Terverifikasi'}, status: :ok
                        end
                    else
                        render json: {success: false, msg:'User tidak ditemukan'}, status: :ok
                    end
                else
                    render json: {success: false, msg:'Not Authorized'}, status: :ok
                end 
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
end