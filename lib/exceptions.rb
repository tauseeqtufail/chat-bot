# frozen_string_literal: true

# custom exceptions
module Exceptions
  class ExternalError < StandardError
    attr_reader :code

    def initialize(message = nil, code = nil)
      super(message)
      @code = code
    end
  end
end
