#!ruby -Ks
require "./common"
require 'observer'

#-------------------------------------
# �V�[���Ǘ��N���X
#-------------------------------------
class Animation

  include Reversi
  include Observable
  
  # ���_�A�j���[�V�����̃X�s�[�h �����l�����Ȃ����x���Ȃ�
  ANIMATION_SPEED = 0.3
  
  #=== ����������
  def initialize(pieces_img)
    @pieces_img = pieces_img
  end

  #=== �����o������
  def clear
    @statuses = nil
    @status_count = 0
    @anim_index = 0
    @anim = false
    @anim_dir = 1
    @anim_count = 0.0
    @counter = 0
    @turn
    @dx = 0
    @dy = 0
  end

  #=== �A�j���[�V�����p�����[�^�ݒ�
  def set_state(pieces, statuses, turn)
    # �p�����[�^������
    clear
    
    @statuses = statuses
    @dx = @statuses[@status_count].dx
    @dy = @statuses[@status_count].dy
    @pieces_state = pieces
    @turn = turn
  end
    
  #=== �A�j���[�V�������s
  def run
    result = false
    DIVIDE_FILED_Y.times { |i|
      DIVIDE_FILED_X.times { |j|
        # �`��
        state = @pieces_state[DIVIDE_FILED_Y * i + j]
        next if state == PIECE_NONE
        
        index = state
        #p "x:#{@statuses[@status_count].x + @dx}, y:#{@statuses[@status_count].y + @dy}"
        #p "j:#{j}, i:#{i}"
        if (@status_count < @statuses.size)
          if (@statuses[@status_count].x + @dx) == j && (@statuses[@status_count].y + @dy) == i
            if @anim == false
              #-------------------------------
              # �A�j���[�V�����J�n
              #-------------------------------
              if state == PIECE_WHITE
                @anim_dir = -1 * ANIMATION_SPEED
              elsif state == PIECE_BLACK
                @anim_dir = ANIMATION_SPEED
              end
              @anim_count = state.to_f
              @anim = true
            else
              #-------------------------------
              # �A�j���[�V������
              #-------------------------------
              @anim_count = @anim_count + @anim_dir
              index = @anim_count.to_i
              temp = false
              if state == PIECE_WHITE
                if index == PIECE_BLACK
                  temp = update_seq(PIECE_BLACK, i, j)
                end
              elsif state == PIECE_BLACK
                if index == PIECE_WHITE
                  temp = update_seq(PIECE_WHITE, i, j)
                end
              end
              if temp == true && result == false
                 # ��̃^�[���ŏ㏑������Ȃ��悤��
                 result = true
              end
            end
          end
        end
        
        Window.draw(j * DIVIDE_SIZEX + (DIVIDE_SIZEX - @pieces_img[state].width) / 2, i * DIVIDE_SIZEY, @pieces_img[index])
      }
    }
    if (result == true)
      # �A�j���[�V�����I���ʒm
      notify
    end
  end
  
  #=== �A�j���[�V�����I���ʒm
  def notify
    changed
    notify_observers(@turn)
  end
  
  #=== �A�j���[�V�����̃V�[�P���X�X�V
  def update_seq(piece_state, i, j)
    # �A�j���[�V�����I��
    @anim = false
    # �s�[�X��Ԃ̍X�V
    @pieces_state[DIVIDE_FILED_Y * i + j] = piece_state
    # ���̃s�[�X��
    @anim_index = @anim_index + 1
    
    # �ʒu�X�V
    @dx = @dx + @statuses[@status_count].dx
    @dy = @dy + @statuses[@status_count].dy

    if @anim_index == @statuses[@status_count].count
      # ��̕����̃A�j���[�V�������I��� �� ���̕�����
      @status_count = @status_count + 1
      @anim_index = 0
      if @status_count == @statuses.size
        # �S�Ă̕����̃A�j���[�V�����I��
        return true
      end
      @dx, @dy = @statuses[@status_count].dx, @statuses[@status_count].dy
    end
    return false
  end
  
end

