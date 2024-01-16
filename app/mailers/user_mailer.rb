class UserMailer < ApplicationMailer
    def welcome_email
        @reciever = params[:reciever]
        puts "heree=========="
        @url  = 'https://www.google.com/'
        mail(to: @reciever, subject: 'Welcome to My Awesome Site')
    end
end