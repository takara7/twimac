module Authentications
  class OmniauthCallbacksController < DeviseTokenAuth::OmniauthCallbacksController
    def omniauth_success
      get_resource_from_auth_hash
      set_token_on_resource
      create_auth_params

      if confirmable_enabled?
        # don't send confirmation email!!!
        @resource.skip_confirmation!
      end

      sign_in(:user, @resource, store: false, bypass: false)

      @resource.save! if @resource.changed?

      update_auth_header
      yield @resource if block_given?
      render json: @resource, status: :ok
      # yield @resource if block_given?

      # render_data_or_redirect('deliverCredentials', @auth_params.as_json, @resource.as_json)
    end

    protected

    def get_resource_from_auth_hash
      # find or create user by provider and provider uid
      # authentication = Authentication.where({
      #   uid:      auth_hash['uid'],
      #   provider: auth_hash['provider']
      # }).first_or_initialize
      authentication = Authentication.find_or_create_by_omniauth(auth_hash, current_user)

      @resource = authentication.user
      unless @resource
        @resource = resource_class.new
        @resource.authentications << authentication
      end

      if @resource.new_record?
        @oauth_registration = true
      end

      # sync user info with provider, update/generate auth token
      assign_provider_attrs(@resource, auth_hash)

      # assign any additional (whitelisted) attributes
      extra_params = whitelisted_params
      @resource.assign_attributes(extra_params) if extra_params

      @resource
    end
  end
end
