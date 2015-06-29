#!ruby -Ku
require "./common"

#-------------------------------------
# プレイヤークラス
#-------------------------------------
class Player

  include Reversi

  def initialize(imgPiece, callBack)
    @mx = 0
    @my = 0
    @pieceImg = imgPiece
    @callback = callBack
  end

  def update
    @mx = Input.mousePosX
    @my = Input.mousePosY

    # 左クリックされた場合
    if Input.mousePush?(M_LBUTTON)
      # コールバックメソッド呼び出し
      @callback.call(@mx / DIVIDE_SIZEX, @my / DIVIDE_SIZEY)
    end
  end

  def draw
    # 自ピース描画
    Window.draw(@mx - @pieceImg.width / 2, @my - @pieceImg.height / 2, @pieceImg)
  end

end
