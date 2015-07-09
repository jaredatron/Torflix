class << Sprockets::CoffeeScriptProcessor

  SYNTAX_ERROR_MESSAGE = /SyntaxError: \[stdin\]:(\d+):(\d+)/
  def call_with_better_errors(input)
    call_without_better_errors(input)
  rescue ExecJS::RuntimeError => error
    # binding.pry
    raise error unless error.message.match(SYNTAX_ERROR_MESSAGE)
    line, col = $1, $2
    message = "SyntaxError: #{input[:filename]}:#{line}:#{col}"
    message += "\n\n#{add_line_numbers(input[:data])}"
    error.instance_variable_set(:@message, message)
    def error.message
      @message
    end
    raise error
  end
  alias_method_chain :call, :better_errors

  private

  def add_line_numbers(source)
    source.split("\n").each_with_index.map do |line, index|
      "#{index+1}: #{line}"
    end.join("\n")
  end
end
