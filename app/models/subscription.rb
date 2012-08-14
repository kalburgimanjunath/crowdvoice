# == Schema Information
#
# Table name: subscriptions
#
#  id         :integer(4)      not null, primary key
#  email      :string(255)
#  voice_id   :integer(4)
#  email_hash :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Subscription < ActiveRecord::Base
  attr_accessible :email, :voice_id, :email_hash
  belongs_to :voice
  validates :email, :presence => true,
                    :format => {
                      :with => %r{^(?:[_a-z0-9-]+)(\.[_a-z0-9-]+)*@([a-z0-9-]+)(\.[a-zA-Z0-9\-\.]+)*(\.[a-z]{2,4})$}i,
                      :messsage => "is invalid"

                    },
                    :uniqueness => {
                      :scope => :voice_id,
                      :message => "has already been subscribed."
                    }
  validates :email_hash,
    :uniqueness => true
  before_save :generate_email_hash

  # Returns a unique MD5 hash that corresponds to the subscription to
  # allow users to unsubscribe
  # @return [String] the param for the subscription
  def to_param
    email_hash
  end

  private

  # Hashes an email along with the id of the subscription to get
  # a key for the unsubscribe param
  def generate_email_hash
    self.email_hash = Digest::MD5.hexdigest([email, Time.now.to_i].join("--"))[0...6]
  end
end
