#!ruby -Ks
require 'dxruby'

#-------------------------------------
# ‹¤’Ê’è‹`
#-------------------------------------
module Reversi

  DIVIDE_FILED_X = 8
  DIVIDE_FILED_Y = 8

  PIECE_NONE = 9
  PIECE_WHITE = 4
  PIECE_BLACK = 0

  DIVIDE_SIZEX = Window.width / DIVIDE_FILED_X
  DIVIDE_SIZEY = Window.height / DIVIDE_FILED_Y

  # use : true, not use : false
  USE_ANIMATION = true

end

