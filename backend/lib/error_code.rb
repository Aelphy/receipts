class ErrorCode < Hash
  include Singleton

  def initialize
    %i(db_failure
       parameter_missing
       wrong_parameter).each_with_index do |code, index|
      self[code] = index
    end
  end

  def message(key)
    I18n.t("error_codes.#{key}")
  end
end
