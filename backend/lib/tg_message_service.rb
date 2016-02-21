module TgMessageService
  def self.transmit(phone, message)
    send_through_nc("add_contact #{phone} user #{phone}")
    send_through_nc("msg user_#{phone} #{message}")
  end

  private

  def self.send_through_nc(command)
    system("echo #{command} | nc #{Settings.telegram.host} #{Settings.telegram.port} -q 1")
  end
end
