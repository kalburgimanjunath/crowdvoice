module Jobs
  class DigestJob < Struct.new(:subscription_id)
    def perform
      subscription = ::Subscription.find(subscription_id)
      ::NotifierMailer.daily_digest(subscription).deliver
    end
  end
end
