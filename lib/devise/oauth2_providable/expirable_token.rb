require 'active_support/concern'
#require 'active_record'

module Devise
  module Oauth2Providable
    module ExpirableToken
      extend ActiveSupport::Concern

      included do
        class_eval do
          extend ClassMethods
        end
      end

      module ClassMethods
        def lambda_not_expired
          lambda {
            where(self.arel_table[:expires_at].gteq(Time.now.utc))
          }
        end

        def expires_according_to(config_name)
          cattr_accessor :default_lifetime
          self.default_lifetime = Rails.application.config.devise_oauth2_providable[config_name]

          belongs_to :user
          belongs_to Devise::Oauth2Providable.ABSTRACT(:client_sym)

          after_initialize :init_token, :on => :create, :unless => :token?
          after_initialize :init_expires_at, :on => :create, :unless => :expires_at?
          validates :expires_at, :presence => true
          validates Devise::Oauth2Providable.ABSTRACT(:client_sym), :presence => true
          validates :token, :presence => true, :uniqueness => true

          scope :not_expired, lambda_not_expired
          
          scope :of_client, lambda {|id| where(Devise::Oauth2Providable.ABSTRACT(:client_sym_id) => id)}
          
          include ExpirationMethods
        end
      end

      module ExpirationMethods
        # number of seconds until the token expires
        def expires_in
          expires_at.to_i - Time.now.utc.to_i
        end

        # forcefully expire the token
        def expired!
          self.expires_at = Time.now.utc
          self.save!
        end

        private

        def init_token
          self.token = Devise::Oauth2Providable.random_id
        end
        def init_expires_at
          self.expires_at = self.default_lifetime.from_now
        end
      end
    end
  end
end

