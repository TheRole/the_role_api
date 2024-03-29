module TheRole
  module Api
    module User
      extend ActiveSupport::Concern

      include TheRole::Api::BaseMethods

      # HELPERS

      # version for `User`  model
      def role_hash
        @role_hash ||= role.try(:to_hash) || {}
      end

      # ~ HELPERS

      included do
        role_options = {}
        role_options = { optional: true } if Rails.version[0..2].to_f >= 5.1

        belongs_to :role, role_options
        before_validation :set_default_role, on: :create
        after_save { |user| user.instance_variable_set(:@role_hash, nil) }
      end

      module ClassMethods
        def with_role name
          ::Role.where(name: name).first.users
        end
      end

      # FALSE if object is nil
      # If object is a USER - check for youself
      # Check for owner field - :user_id
      # Check for owner _object_ if owner field is not :user_id
      def owner? obj
        return false unless obj
        return true  if admin?

        section_name = obj.class.to_s.tableize
        return true if moderator?(section_name)

        # obj is User, simple way to define user_id
        return id == obj.id if obj.is_a?(self.class)

        # few ways to define user_id
        return id == obj.user_id     if obj.respond_to? :user_id
        return id == obj[:user_id]   if obj[:user_id]
        return id == obj[:user][:id] if obj[:user]

        false
      end

      private

      def set_default_role
        unless role
          default_role = ::Role.find_by_name(TheRole.config.default_user_role)
          self.role = default_role if default_role
        end

        if self.class.count.zero? && TheRole.config.first_user_should_be_admin
          self.role = TheRole.create_admin!
        end
      end
    end
  end
end
