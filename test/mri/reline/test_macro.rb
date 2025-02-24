require_relative 'helper'

class Reline::MacroTest < Reline::TestCase
  def setup
    Reline.send(:test_mode)
    @config = Reline::Config.new
    @encoding = Reline.core.encoding
    @line_editor = Reline::LineEditor.new(@config)
    @output = @line_editor.output = File.open(IO::NULL, "w")
  end

  def teardown
    @output.close
    Reline.test_reset
  end

  def input_key(char, combined_char = char, with_meta = false)
    @line_editor.input_key(Reline::Key.new(char, combined_char, with_meta))
  end

  def input(str)
    str.each_byte {|c| input_key(c)}
  end

  def test_simple_input
    input('abc')
    assert_equal 'abc', @line_editor.line
  end

  def test_alias
    class << @line_editor
      alias delete_char ed_delete_prev_char
    end
    input('abc')
    assert_nothing_raised(ArgumentError) {
      input_key(:delete_char)
    }
    assert_equal 'ab', @line_editor.line
  end
end
