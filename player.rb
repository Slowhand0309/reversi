#!ruby -Ks
require "./common"

#-------------------------------------
# �v���C���[�N���X
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
    
    # ���N���b�N���ꂽ�ꍇ
    if Input.mousePush?(M_LBUTTON)
      # �R�[���o�b�N���\�b�h�Ăяo��
      @callback.call(@mx / DIVIDE_SIZEX, @my / DIVIDE_SIZEY)
    end
  end
  
  def draw
    # ���s�[�X�`��
    Window.draw(@mx - @pieceImg.width / 2, @my - @pieceImg.height / 2, @pieceImg)
  end
  
end

