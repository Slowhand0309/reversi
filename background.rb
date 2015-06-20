#!ruby -Ks
require "./common"

#-------------------------------------
# 背景管理クラス
#-------------------------------------
class BackGround
  
  include Reversi
  
  BASE_COLOR = [255, 10, 255, 10]  # 土台背景色
  LINE_COLOR = C_BLACK             # ライン色
  
  def initialize
    # イメージ作成
    @baseImage = Image.new(Window.width, Window.height, BASE_COLOR)
  end
  
  def draw
    # 土台描画
    Window.draw(0, 0, @baseImage)

    # Y軸方向ライン描画
    DIVIDE_FILED_Y.times { |i|
      Window.drawLine(i * DIVIDE_SIZEX, 0, i * DIVIDE_SIZEX, Window.height, LINE_COLOR)
    }
    # X軸方向ライン描画
    DIVIDE_FILED_X.times { |j|
      Window.drawLine(0, j * DIVIDE_SIZEY, Window.width, j * DIVIDE_SIZEY, LINE_COLOR)
    }
  end
  
end

