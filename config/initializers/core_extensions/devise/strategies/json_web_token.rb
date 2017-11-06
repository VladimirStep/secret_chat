module Devise
  module Strategies
    class JsonWebToken < Base
      def valid?
        request.headers['Authorization'].present?
      end

      def authenticate!
        return fail! unless claims
        return fail! unless claims.has_key?('user_id')
        success! User.find(claims['user_id'])
      end

      private

      def claims
        strategy, token = request.headers['Authorization'].split(' ')
        return nil unless strategy.downcase == 'bearer'
        JWTCoder.decode(token) rescue nil
      end
    end
  end
end