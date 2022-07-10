# frozen_string_literal: true

# 66 Days
# By Dee Schaedler

ALIGN_LEFT = 0
ALIGN_CENTER = 1
ALIGN_RIGHT = 2

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
  textbox = Textbox.new(x: args.grid.center_x - (box_w / 2),
                        y: 680 - box_h,
                        w: box_w,
                        h: box_h,
                        padding: 5,
                        text_align: ALIGN_CENTER)
  args.outputs.primitives << textbox.draw
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
  end

  def tick
    args = $gtk.args

    @rect = { x: @x, y: @y, w: @w, h: @h, primitive_marker: :border }

    @active = true if args.inputs.mouse.click.inside_rect?(@rect)
  end

  def draw
    primitives = []
    primitives << @rect
    primitives
  end
end
