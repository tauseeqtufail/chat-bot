
module FacebookMessanger
  class Base < ApplicationService
    attr_reader :data, :sender_psid, :message

    def initialize(data)
      @data = (data || {})
      @sender_psid = sender_id
      @message = []
    end

    private

    def sender_id
      data[:sender][:id]
    end
  end
end
