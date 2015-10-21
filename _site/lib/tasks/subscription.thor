require File.expand_path('config/environment.rb')

class Subscription < Thor
  desc "digest", "Delivers a digest with all today's contents to the subscriptions"
  def digest
    # OPTIMIZE: send only one mail per voice to all users subscribed as bcc
    Subscription.all.each do |subscription|
      Delayed::Job.enqueue Jobs::DigestJob.new(subscription.id)
    end
  end
end