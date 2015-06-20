#!ruby -Ks
require "./common"
require "./reversi_status"

#-------------------------------------
# �Տ�ł̏�ԊǗ��N���X
#-------------------------------------
module State
  
  include Reversi
  
  # �`�F�b�N�Ώە��� [��, ��, �E, ��, �E��, ����, ����, �E��]
  CHECK_TARGETS = [[0, -1], [0, 1], [1, 0], [-1, 0], [1, -1], [-1, -1], [-1, 1], [1, 1]]
  
  #=== �Q�[���I������
  #�S�Ẵ}�X�����܂��Ă�����I��
  def game_over?(states)
    states.each { |piece|
      return false if piece == PIECE_NONE
    }
    return true
  end
  
  #=== �����Ҕ���
  def who_winner?(states)
    # ���̖����𐔂���
    count = 0
    states.each { |piece|
      if piece == PIECE_WHITE
        count += 1
      end
    }
    return PIECE_NONE if (states.size / 2 == count) # ��������
    return PIECE_WHITE if (states.size / 2 < count) # ���̏���
    return PIECE_BLACK
  end
  
  #=== ��ԍX�V
  #�`�F�b�N�Ώۂ̕����Ƀ`�F�b�N���s���A���]�ł���s�[�X�𔽓]������
  def updateState(pieces, x, y, state, check)
    statuses = Array.new
    # �S�����ɑ΂��ă`�F�b�N
    CHECK_TARGETS.each { |dx, dy|
      #p "-------------------------------------"
      #p "x:#{x}, y:#{y}, dx:#{dx}, dy:#{dy}, state:#{state}"
      reverse, count = reverse?(x, y, dx, dy, state, pieces)
      #p "reverse:#{reverse}, count:#{count}"
      #p "-------------------------------------"
      if reverse == true
        reversi_state = ReversiStatus.new
        reversi_state.count = count
        reversi_state.dx = dx
        reversi_state.dy = dy
        reversi_state.x = x
        reversi_state.y = y
        statuses << reversi_state
        #p "add state : #{statuses}"
        if USE_ANIMATION == false
          # ���]
          1.upto(count) { |idx|
            pieces[(y + (dy * idx)) * DIVIDE_FILED_X + x + (dx * idx)] = state
          }
        end
      end
    }
    return statuses
  end
  
  #=== ���]��
  #x, y�̈ʒu����dx, dy�����֔��]�ł��邩����
  def reverse?(x, y, dx, dy, state, pieces)
    count = 0
    reverse = false
    _x, _y = x, y
    while ((_x >= 0 && _x <= DIVIDE_FILED_X)) &&
          ((_y >= 0 && _y <= DIVIDE_FILED_Y)) do

       # �i�񂾐�̏�Ԃ��擾
       index = (_y + dy) * DIVIDE_FILED_X + _x + dx
       if index < 0 || index > pieces.size
         break
       end
       
       temp = pieces[index]
       #p "temp : #{temp}, count:#{count}"
       # �i�񂾐悪����������ΏI��
       break if temp == PIECE_NONE
       if count == 0
         break if temp == state
       elsif count > 0
         if temp == state
           reverse = true
           break
         end
       end
       count = count + 1
       _x, _y = _x + dx, _y + dy
    end
    
    # ���]���邩�Ɣ��]����s�[�X����Ԃ�
    return reverse, count
  end

  module_function :updateState
  module_function :game_over?
  module_function :reverse?
  module_function :who_winner?
end

