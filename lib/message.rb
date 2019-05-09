# The presentation layer
class Message

  private

  def button(options)
    text = options[:label]
    name = options[:name] || options[:label]
    style = options[:style] || 'default'
    value = options[:value] || options[:label]
    button_options = { name: name, text: text, style: style,
                       value: value.to_s, type: 'button' }
    return button_options unless options[:confirm]
    button_options.merge(confirm: options[:confirm])
  end

  def web_button(options)
    button(options).merge(url: options[:url])
  end

  def submit_cancel
    { text: '', callback_id: callback_id('submit'),
      actions: [cancel_button, submit_button] }
  end

  def submit_button
    button(label: 'Submit', style: 'primary')
  end
end
