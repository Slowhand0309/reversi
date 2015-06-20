#!ruby -Ks
require "./common"
require "./player"
require "./simplekun"
require "./state"
require "./animation"

#-------------------------------------
# シーン管理クラス
#-------------------------------------
class Scene
  
  include Reversi
  
  TURN_PLAYER = 1      # プレイヤー出番
  TURN_COMPUTER = 2    # コンピュータ出番
  TURN_REVERSI = 3     # 反転中
  TURN_GAMEOVER = 9    # ゲーム終了
  
  PIECEIMG_FILEPATH = "res/piece.png"
  PIECEIMG_XCOUNT = 5
  PIECEIMG_YCOUNT = 1
  
  @@turn = TURN_PLAYER
  
  #=== アニメーション終了監視
  class AnimationObserver
    def update(turn)
      if (turn == TURN_PLAYER)
        # プレイヤー→コンピュータ
        Scene.set_turn(TURN_COMPUTER)
      elsif (turn == TURN_COMPUTER)
        # コンピュータ→プレイヤー
        Scene.set_turn(TURN_PLAYER)
      end
    end
  end
  
  #=== ターン変更
  def Scene.set_turn(turn)
    @@turn = turn
  end
  
  #=== 初期化処理
  #各ピース画像の生成、プレイヤークラスの生成を行います
  def initialize
    # 盤上での状態値
    @pieces_state = Array.new(DIVIDE_FILED_X * DIVIDE_FILED_Y, PIECE_NONE);
    
    # ピースイメージ作成
    tx = DIVIDE_SIZEX / 2
    ty = DIVIDE_SIZEY / 2
    @pieces = Image.loadTiles(PIECEIMG_FILEPATH, PIECEIMG_XCOUNT, PIECEIMG_YCOUNT)
    
    # 出番初期化
    @player = Player.new(@pieces[PIECE_BLACK], Proc.new{|x, y| update_secen(x, y, PIECE_BLACK)})
    @computer = SimpleKun.new(PIECE_WHITE, @pieces[PIECE_WHITE], @pieces_state, Proc.new{|x, y| update_secen(x, y, PIECE_WHITE)})
    
    # アニメーション処理クラス
    @animation = Animation.new(@pieces)
    @animation.add_observer(AnimationObserver.new)
    
    @font = Font.new(40)
  end
  
  #=== セル内に収まる円の半径を算出
  # x * y / 2 = √(x * x + y * y) * r / 2
  def calc_radius(x, y)
    r = x * y / Math::sqrt(x * x + y * y)
  end
  
  #=== シーン初期化
  #
  def init_scene
    # シーンの初期化
    _white = (DIVIDE_FILED_Y + 1) * ((DIVIDE_FILED_Y / 2) - 1)
    _black = _white + 1
    @pieces_state[_white] = PIECE_WHITE
    @pieces_state[_black] = PIECE_BLACK
    
    _white = (DIVIDE_FILED_Y + 1) * (DIVIDE_FILED_Y / 2)
    _black = _white - 1
    @pieces_state[_white] = PIECE_WHITE
    @pieces_state[_black] = PIECE_BLACK
  end

  #=== シーンの更新
  # - x::新規ピースx座標
  # - y::新規ピースy座標
  def update_secen(x, y, state)
    # ピースの位置を求める
    place = y * DIVIDE_FILED_X + x
    
    if @@turn == TURN_COMPUTER && x == -1 && y == -1
      # どこにも置き場所が無い
      @@turn = TURN_PLAYER
      return
    end
    if @pieces_state[place] == PIECE_NONE
      # 盤上更新
      statuses = State.updateState(@pieces_state, x, y, state, false)
      if statuses.size > 0
        @pieces_state[place] = state
        if USE_ANIMATION == true
          #@turn = TURN_REVERSI + @turn
          # アニメーション設定
          @animation.set_state(@pieces_state, statuses, @@turn)
          @@turn = TURN_REVERSI
        else
          @@turn = @@turn == TURN_PLAYER ? TURN_COMPUTER : TURN_PLAYER
        end
      end
    end
  end
  
  #=== 更新処理
  #
  def update
    # 終了判定
    if State.game_over?(@pieces_state) == true
      # ゲーム終了
      @@turn = TURN_GAMEOVER
    end
    
    if @@turn == TURN_PLAYER
      # プレイヤーの番
      @player.update
    elsif @@turn == TURN_COMPUTER
      # PCの番
      @computer.update
      
    elsif @@turn == TURN_GAMEOVER
      # 勝利者判定
      @winner = State.who_winner?(@pieces_state)
    end
  end
  
  #=== 描画処理
  #現在の状態に応じたピース画像を描画します
  def draw
    # シーンの描画
    if @@turn == TURN_PLAYER
      # プレイヤーの番
      draw_pieces
      @player.draw
      
    elsif @@turn == TURN_COMPUTER
      # PCの番
      draw_pieces
      
    elsif @@turn == TURN_REVERSI
      # 反転中
      @animation.run
      
    elsif @@turn == TURN_GAMEOVER
      # ゲーム終了
      str = ""
      if @winner == PIECE_NONE
        str = "引き分け。"
      elsif @winner == PIECE_WHITE
        str = "白の勝ち。"
      elsif @winner == PIECE_BLACK
        str = "黒の勝ち。"
      end
      Window.drawFont(50, 100, str, @font, :color => C_RED)
    end
  end

  #=== 各ピースを描画
  def draw_pieces
    DIVIDE_FILED_Y.times { |i|
      DIVIDE_FILED_X.times { |j|
        # 描画
        state = @pieces_state[DIVIDE_FILED_Y * i + j]
        # state => 9 : 何も無い
        next if state == PIECE_NONE
        Window.draw(j * DIVIDE_SIZEX + (DIVIDE_SIZEX - @pieces[state].width) / 2, i * DIVIDE_SIZEY, @pieces[state])
      }
    }
  end
end

