require_relative 'event'
require_relative 'view'

# Process incoming events
class Controller < Event
  def url_verification
    data['challenge']
  end

  def message
    return nil if ignorable? || invalid_command?
    case message_text
    when 'help'
      bot.help
    else 
      bot.pardon?
    end
  end

  private

  def view
    View.new(data, user_id)
  end

  def invalid_command?
    message_text.split.size != 1
  end

  def message_text
    data['text'] || data['event']['text']
  end

  def channel_id
    channel = data['channel'] || data['event']['channel']
    return channel unless channel.is_a? Hash
    channel['id']
  end

  def actions
    data['actions'].first
  end

  def button
    actions['name']
  end

  def original_message
    data['original_message']['attachments'].first
  end

  def selected_options
    actions['selected_options'].first
  end

  def original_selected_option
    original_message['actions'].first['selected_options']&.first
  end

  def ignorable?
    bot_message? || message_text.nil?
  end

  def bot_message?
    user_id == $memory.bot_user_id || data['event']['subtype'] == 'bot_message'
  end

  def value
    selected_options['value']
  end
end
