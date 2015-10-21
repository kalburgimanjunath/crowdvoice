# == Schema Information
#
# Table name: settings
#
#  id         :integer(4)      not null, primary key
#  name       :text
#  value      :text
#  created_at :datetime
#  updated_at :datetime
#

class Setting < ActiveRecord::Base
  attr_accessible :name, :value, :positive_treshold, :negative_threshold
  validates :name, :presence => true
  validates :value, :presence => true

  # Updates each setting
  # @param [Hash] params the hash containing the value for all the
  #   settings.
  def self.update_settings(params)
    Setting.positive_threshold = params['max-value']
    Setting.negative_threshold = params['min-value']
    Setting.posts_per_page = params[:posts]
  end

  # Returns the positive threshold setting value
  # @return [Integer] the value of the positive threshold setting
  def self.positive_threshold
    find_or_create_by_method_name(__method__).value.to_i
  end

  # Returns the negative threshold setting value
  # @return [Integer] the value of the negative threshold setting
  def self.negative_threshold
    find_or_create_by_method_name(__method__).value.to_i
  end

  # Returns the posts per page setting value
  # @return [Integer] the value of the posts per page setting
  def self.posts_per_page
    find_or_create_by_method_name(__method__).value.to_i
  end

  # Sets the value for the positive threshold setting
  # @param [Integer] value the new value for the positive threshold
  #   setting
  def self.positive_threshold=(value)
    s = self.find_or_create_by_method_name(__method__)
    s.value = value
    s.save!
  end

  # Sets the value for the negative threshold setting
  # @param [Integer] value the new value for the negative threshold
  #   setting
  def self.negative_threshold=(value)
    s = self.find_or_create_by_method_name(__method__)
    s.value = value
    s.save!
  end

  # Sets the value for the posts per page setting
  # @param [Integer] value the new value for the posts per page setting
  def self.posts_per_page=(value)
    if value.to_i >= 25
      s = self.find_or_create_by_method_name(__method__)
      s.value = value
      s.save!
    end
  end

  # Finds or creates a `Setting` based on the name of the method called
  # @param [Symbol] method_name the name of the method to search for
  # @return [Setting] the setting that corresponds to the method name
  def self.find_or_create_by_method_name(method_name)
    m_name = method_name.to_s.titlecase.gsub('=','')
    find_by_name(m_name) || create(:name => m_name, :value => APP_CONFIG[:default_settings][method_name.to_s.gsub('=','')])
  end

end
