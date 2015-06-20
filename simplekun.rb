#!ruby -Ks
require "./compute"

#-------------------------------------
# �R���s���[�^�N���X
#-------------------------------------
class SimpleKun < Compute
  
  def initialize(state, imgPiece, piecesState, callBack)
    super(state, imgPiece, piecesState, callBack)
  end
  
  protected
  
  def compute_position
    count = 0
    x, y = -1, -1
    # ��ԂЂ�����Ԃ����������ӏ����Z�o
    DIVIDE_FILED_Y.times { |i|
      DIVIDE_FILED_X.times { |j|
        if @piecesState[i * DIVIDE_FILED_X + j] != PIECE_NONE
          # ���ɔz�u�ς�
          next
        end
        State::CHECK_TARGETS.each { |dx, dy|
          reverse, temp = State.reverse?(j, i, dx, dy, @state, @piecesState)
          p "computer update reserve:#{reverse}, temp:#{temp}"
          if reverse == true && temp > count
            count = temp
            x = j
            y = i
          end
        }
      }
    }
    return x, y
  end
  
end

