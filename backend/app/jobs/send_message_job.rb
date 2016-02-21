class SendMessageJob < ActiveJob::Base
  queue_as :default

  def perform(phone, message)
    TgMessageService.transmit(phone, message)
  end
end
