module Mojang
  module Errors
    class NoSuchUserError < StandardError
      attr_reader :user

      def initialize(user)
        @user = user
      end

      def message
        "No such user '#{@user}'."
      end
    end

    class MojangError < StandardError
      attr_reader :error
      attr_reader :msg

      def initialize(error, msg)
        @error = error
        @msg = msg
      end

      def message
        "#{@msg} (#{@error}"
      end
    end
  end
end
