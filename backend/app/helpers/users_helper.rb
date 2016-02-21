module UsersHelper
  def sign_up_message(password)
    I18n.t('notifications.messages.sign_up', password: password)
  end

  def new_password_message(password)
    I18n.t('notifications.messages.new_password', password: password)
  end
end
