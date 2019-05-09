require_relative 'event'

# Show menus and dialogs
class View < Event
  def main_menu
    bot.main_menu
  end
end
