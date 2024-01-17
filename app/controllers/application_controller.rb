class ApplicationController < ActionController::Base
    before_action :configure_permitted_parameters, if: :devise_controller?
    before_action :set_active_storage_url_options

    def after_sign_in_path_for(resource)
        # Customize the redirect path here.
        root_path
      end

      protected

      def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:sign_up, keys: [:profile_image])
      end
      
      private

      def set_active_storage_url_options
        ActiveStorage::Current.url_options = {
          host: request.base_url,
          protocol: request.protocol
          # Add any other options you might need
        }
      end
end
