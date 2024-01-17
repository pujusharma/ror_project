class ApplicationController < ActionController::Base
    def after_sign_in_path_for(resource)
        # Customize the redirect path here.
        root_path
      end
end
