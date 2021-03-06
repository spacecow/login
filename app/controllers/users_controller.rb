class UsersController < ApplicationController
  before_filter :find_page_by_id_or_username, :only => :show
  load_and_authorize_resource
  
  def show
  end
  
  def new
  	@questions = User::QUESTIONS.map{|e| t(e)}.zip( User::QUESTIONS )
  end
  
  def create
  	@questions = User::QUESTIONS.map{|e| t(e)}.zip( User::QUESTIONS )
    if @user.save
      session[:user_id] = @user.id
      flash[:notice] = t('message.signup_thanks')+" "+t('message.logged_in')
      redirect_to root_url
    else
      render :action => 'new'
    end
  end

	def change_password
		@token = params[:token]
		reset = Reset.find_by_token( @token )
		if reset.nil?
			flash[:error] = t('error.no_token')
			redirect_to root_path and return 
		end
		if reset.used
			flash[:error] = t('error.used_token')
			redirect_to root_path and return 
		end
		@user = reset.user
	end
	
	def update_password
		@token = params[:token]
		reset = Reset.find_by_token(params[:token])
		@user = reset.user
		
		if @user.update_attributes(params[:user])
			if params[:user][:password].blank?
				flash.now[:error] = t('error.blank_password')
				render :action => 'change_password' and return
			end
			session[:user_id] = @user.id
    	flash[:notice] = t('notice.change_success')+" "+t('message.logged_in')
    	reset.update_attribute( :used, true )
    	#@reset_password.destroy
    	redirect_to root_path
    else
      render :action => 'change_password'
    end
	end

private

  def find_page_by_id_or_username
    @user = params[:id].to_i == 0 ? User.find_by_username( params[:id] ) : User.find( params[:id])
  end  
end
