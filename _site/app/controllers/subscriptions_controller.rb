class SubscriptionsController < ApplicationController
  before_filter :find_voice

  #Creates a subscription and sends a confirmation email
  def create
    @subscription = @voice.subscriptions.build(params[:subscription])
    if @subscription.save
      Delayed::Job.enqueue Jobs::ConfirmationJob.new(@subscription.id)
      flash[:notice] = t('flash.subscriptions.create.subscribed')
    else
      flash[:alert] = @subscription.errors.full_messages.to_sentence
    end
    redirect_to @voice
  end

  #Cancels a subscription
  def destroy
    @subscription = Subscription.find_by_email_hash(params[:id])
    @subscription.destroy
    flash[:notice] = t('flash.subscriptions.destroy.unsubscribed')
    redirect_to @voice
  end

  private

  #Finds a voice based on the slug in the URL. sets `@voice`
  def find_voice
    @voice = Voice.find_by_slug(params[:voice_id])
  end
end
