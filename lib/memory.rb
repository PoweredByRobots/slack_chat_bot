# Things the bot needs to remember
class Memory
  attr_reader :bot_user_id, :access_token, :bot_access_token
  attr_accessor :channel

  def initialize(memory)
    @bot_user_id = memory[:bot_user_id]
    @access_token = memory[:access_token]
    @bot_access_token = memory[:bot_access_token]
    @channel = memory[:channel]
  end
end
