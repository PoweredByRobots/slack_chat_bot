# Incoming events
class Event
  attr_reader :user_id, :data, :bot

  def initialize(data, user_id)
    @data = data
    @user_id = user_id
  end

  private

  def bot
    @bot ||= SlackBot.new(user_id)
  end

  def admin?
    user_id == ENV['ADMIN_ID']
  end

  def callback_id
    data['callback_id']
  end
end
