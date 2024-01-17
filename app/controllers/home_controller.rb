class HomeController < ApplicationController
  before_action :authenticate_user!  
  def index

  end

  def contact
  end


  def profile
  end

  def contact_email
    @user = User.find_by(email: params[:email])
    UserMailer.with(reciever: params[:email]).welcome_email.deliver_now
  end

  def about

  end
end
