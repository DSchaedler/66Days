# frozen_string_literal: true

# 66 Days
# By Dee Schaedler

ALIGN_LEFT = 0
ALIGN_CENTER = 1
ALIGN_RIGHT = 2
KEY_BLACKLIST = %w[
  raw_key
  char
  shift_left
  shift_right
  shift
  alt_left
  alt_right
  alt
  control
  control_left
  control_right
  tab
  pageup
  pagedown
  home
  end
  delete
  enter
  up
  down
  left
  right
  space
  backspace
].freeze

def tick(args)
  args.outputs.primitives << {
    x: args.grid.center_x,
    y: 700,
    text: 'Daily task:',
    alignment_enum: ALIGN_CENTER,
    primitive_marker: :label
  }
  box_w = 300
  box_h = 30
  args.state.textbox ||= Textbox.new(x: args.grid.center_x - (box_w / 2),
                                     y: 680 - box_h,
                                     w: box_w,
                                     h: box_h,
                                     padding: 5,
                                     text_align: ALIGN_CENTER)
  args.state.textbox.tick
  args.outputs.primitives << args.state.textbox.draw
end

class Textbox
  attr_accessor :x, :y, :w, :h, :padding, :text_align, :contents

  def initialize(x:, y:, w:, h:, padding:, text_align:)
    @x = x
    @y = y
    @w = w
    @h = h
    @padding = padding
    @text_align = text_align
    @contents = ''
    @active = false
    @rect = { x: @x, y: @y, w: @w, h: @h, primitive_marker: :border }
    @cursor = false
  end

  def tick
    args = $gtk.args

    @rect = { x: @x, y: @y, w: @w, h: @h, primitive_marker: :border }

    @cursor = !@cursor if (args.state.tick_count % 30).zero?

    @active = args.inputs.mouse.click.inside_rect?(@rect) if args.inputs.mouse.click

    return unless @active && args.inputs.keyboard.has_focus

    args.inputs.keyboard.keys.down.each do |i|
      unless KEY_BLACKLIST.include? i.to_s
        key = i.to_s
        key = key.upcase if args.inputs.keyboard.keys.down_or_held.include? :shift_left
        @contents += key
      end
      if i.to_s == 'space'
        key = ' '
        @contents += key
      end
      @contents = @contents.chop if i.to_s == 'backspace'
    end
  end

  def draw
    primitives = []
    primitives << @rect
    string = @contents.dup
    string += '|' if @active && @cursor
    primitives << {
      x: @x + (@w / 2),
      y: @y + @padding + 20,
      text: string,
      primitive_marker: :label,
      alignment_enum: ALIGN_CENTER
    }
    primitives
  end
end
