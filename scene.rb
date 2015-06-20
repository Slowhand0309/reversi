#!ruby -Ks
require "./common"
require "./player"
require "./simplekun"
require "./state"
require "./animation"

#-------------------------------------
# �V�[���Ǘ��N���X
#-------------------------------------
class Scene
  
  include Reversi
  
  TURN_PLAYER = 1      # �v���C���[�o��
  TURN_COMPUTER = 2    # �R���s���[�^�o��
  TURN_REVERSI = 3     # ���]��
  TURN_GAMEOVER = 9    # �Q�[���I��
  
  PIECEIMG_FILEPATH = "res/piece.png"
  PIECEIMG_XCOUNT = 5
  PIECEIMG_YCOUNT = 1
  
  @@turn = TURN_PLAYER
  
  #=== �A�j���[�V�����I���Ď�
  class AnimationObserver
    def update(turn)
      if (turn == TURN_PLAYER)
        # �v���C���[���R���s���[�^
        Scene.set_turn(TURN_COMPUTER)
      elsif (turn == TURN_COMPUTER)
        # �R���s���[�^���v���C���[
        Scene.set_turn(TURN_PLAYER)
      end
    end
  end
  
  #=== �^�[���ύX
  def Scene.set_turn(turn)
    @@turn = turn
  end
  
  #=== ����������
  #�e�s�[�X�摜�̐����A�v���C���[�N���X�̐������s���܂�
  def initialize
    # �Տ�ł̏�Ԓl
    @pieces_state = Array.new(DIVIDE_FILED_X * DIVIDE_FILED_Y, PIECE_NONE);
    
    # �s�[�X�C���[�W�쐬
    tx = DIVIDE_SIZEX / 2
    ty = DIVIDE_SIZEY / 2
    @pieces = Image.loadTiles(PIECEIMG_FILEPATH, PIECEIMG_XCOUNT, PIECEIMG_YCOUNT)
    
    # �o�ԏ�����
    @player = Player.new(@pieces[PIECE_BLACK], Proc.new{|x, y| update_secen(x, y, PIECE_BLACK)})
    @computer = SimpleKun.new(PIECE_WHITE, @pieces[PIECE_WHITE], @pieces_state, Proc.new{|x, y| update_secen(x, y, PIECE_WHITE)})
    
    # �A�j���[�V���������N���X
    @animation = Animation.new(@pieces)
    @animation.add_observer(AnimationObserver.new)
    
    @font = Font.new(40)
  end
  
  #=== �Z�����Ɏ��܂�~�̔��a���Z�o
  # x * y / 2 = ��(x * x + y * y) * r / 2
  def calc_radius(x, y)
    r = x * y / Math::sqrt(x * x + y * y)
  end
  
  #=== �V�[��������
  #
  def init_scene
    # �V�[���̏�����
    _white = (DIVIDE_FILED_Y + 1) * ((DIVIDE_FILED_Y / 2) - 1)
    _black = _white + 1
    @pieces_state[_white] = PIECE_WHITE
    @pieces_state[_black] = PIECE_BLACK
    
    _white = (DIVIDE_FILED_Y + 1) * (DIVIDE_FILED_Y / 2)
    _black = _white - 1
    @pieces_state[_white] = PIECE_WHITE
    @pieces_state[_black] = PIECE_BLACK
  end

  #=== �V�[���̍X�V
  # - x::�V�K�s�[�Xx���W
  # - y::�V�K�s�[�Xy���W
  def update_secen(x, y, state)
    # �s�[�X�̈ʒu�����߂�
    place = y * DIVIDE_FILED_X + x
    
    if @@turn == TURN_COMPUTER && x == -1 && y == -1
      # �ǂ��ɂ��u���ꏊ������
      @@turn = TURN_PLAYER
      return
    end
    if @pieces_state[place] == PIECE_NONE
      # �Տ�X�V
      statuses = State.updateState(@pieces_state, x, y, state, false)
      if statuses.size > 0
        @pieces_state[place] = state
        if USE_ANIMATION == true
          #@turn = TURN_REVERSI + @turn
          # �A�j���[�V�����ݒ�
          @animation.set_state(@pieces_state, statuses, @@turn)
          @@turn = TURN_REVERSI
        else
          @@turn = @@turn == TURN_PLAYER ? TURN_COMPUTER : TURN_PLAYER
        end
      end
    end
  end
  
  #=== �X�V����
  #
  def update
    # �I������
    if State.game_over?(@pieces_state) == true
      # �Q�[���I��
      @@turn = TURN_GAMEOVER
    end
    
    if @@turn == TURN_PLAYER
      # �v���C���[�̔�
      @player.update
    elsif @@turn == TURN_COMPUTER
      # PC�̔�
      @computer.update
      
    elsif @@turn == TURN_GAMEOVER
      # �����Ҕ���
      @winner = State.who_winner?(@pieces_state)
    end
  end
  
  #=== �`�揈��
  #���݂̏�Ԃɉ������s�[�X�摜��`�悵�܂�
  def draw
    # �V�[���̕`��
    if @@turn == TURN_PLAYER
      # �v���C���[�̔�
      draw_pieces
      @player.draw
      
    elsif @@turn == TURN_COMPUTER
      # PC�̔�
      draw_pieces
      
    elsif @@turn == TURN_REVERSI
      # ���]��
      @animation.run
      
    elsif @@turn == TURN_GAMEOVER
      # �Q�[���I��
      str = ""
      if @winner == PIECE_NONE
        str = "���������B"
      elsif @winner == PIECE_WHITE
        str = "���̏����B"
      elsif @winner == PIECE_BLACK
        str = "���̏����B"
      end
      Window.drawFont(50, 100, str, @font, :color => C_RED)
    end
  end

  #=== �e�s�[�X��`��
  def draw_pieces
    DIVIDE_FILED_Y.times { |i|
      DIVIDE_FILED_X.times { |j|
        # �`��
        state = @pieces_state[DIVIDE_FILED_Y * i + j]
        # state => 9 : ��������
        next if state == PIECE_NONE
        Window.draw(j * DIVIDE_SIZEX + (DIVIDE_SIZEX - @pieces[state].width) / 2, i * DIVIDE_SIZEY, @pieces[state])
      }
    }
  end
end

