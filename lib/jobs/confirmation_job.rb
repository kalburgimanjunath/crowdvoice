module Jobs
  class ConfirmationJob < Struct.new(:subscription_id)
    def perform
      subscription = ::Subscription.find(subscription_id)
      ::NotifierMailer.subscription_confirmation(subscription).deliver
    end
  end
end
