class HomeController < ApplicationController

  def index

  end

  def contact
  end

  def contact_email
    @user = User.find_by(email: params[:email])
    UserMailer.with(reciever: params[:email]).welcome_email.deliver_later
  end

  def about

  end
end
