module ApplicationHelper
  module FlashCodes
    LOGIN_YAY = 1
    REGISTER_YAY = 2
    WRONG_PASS = 3
    NO_USER = 4
    USER_TAKEN = 5
    PASS_NOT_MATCH = 6
    INTERNAL_SERVER_ERROR = 7
    ALREADY_LOGGED_IN = 8
    SHIT_PASS = 9
  end

  def get_name(user: nil)
    user = @current_user unless user.present?
    if user
      # Helpers don't recognise model classes somehow
      if user.fullname.present?
        user.fullname
      elsif user.username.present?
        user.username
      else
        'no name'
      end
    else
      [
        'guest',
        'random idiot',
        'lost soul',
        'traveller',
        'reader'
      ].sample
    end
  end
end
