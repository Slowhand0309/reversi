#!ruby -Ks
require "./common"
require "./state"

#-------------------------------------
# �R���s���[�^�N���X
#-------------------------------------
class Compute
  
  include Reversi
  
  WAIT_COUNT = 80 # �ҋ@�J�E���g
  
  def initialize(state, imgPiece, piecesState, callBack)
    @state = state
    @pieceImg = imgPiece
    @piecesState = piecesState
    @callback = callBack
    @wait_count = 0
  end
  
  def update
  
    if WAIT_COUNT > @wait_count
      # �ҋ@���E�E�E
      @wait_count += 1
      return
    end
    
    # �ҋ@�J�E���^���Z�b�g
    @wait_count = 0
    
    # ��ԂЂ�����Ԃ����������ӏ����Z�o
    x, y = compute_position
    
    # ���΂��҂�
    #sleep(WAIT_SEC)
    #p "com update x:#{x}, y:#{y}"
    # ���ۂ̍X�V
    @callback.call(x, y)
  end
  
  def draw
  end
  
  protected
  
  def compute_position
    x, y = 0, 0
    return x, y
  end
  
end

