#!ruby -Ks
require "./common"

#-------------------------------------
# �w�i�Ǘ��N���X
#-------------------------------------
class BackGround
  
  include Reversi
  
  BASE_COLOR = [255, 10, 255, 10]  # �y��w�i�F
  LINE_COLOR = C_BLACK             # ���C���F
  
  def initialize
    # �C���[�W�쐬
    @baseImage = Image.new(Window.width, Window.height, BASE_COLOR)
  end
  
  def draw
    # �y��`��
    Window.draw(0, 0, @baseImage)

    # Y���������C���`��
    DIVIDE_FILED_Y.times { |i|
      Window.drawLine(i * DIVIDE_SIZEX, 0, i * DIVIDE_SIZEX, Window.height, LINE_COLOR)
    }
    # X���������C���`��
    DIVIDE_FILED_X.times { |j|
      Window.drawLine(0, j * DIVIDE_SIZEY, Window.width, j * DIVIDE_SIZEY, LINE_COLOR)
    }
  end
  
end

