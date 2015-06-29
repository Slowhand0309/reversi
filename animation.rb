#!ruby -Ku
require "./common"
require 'observer'

#-------------------------------------
# シーン管理クラス
#-------------------------------------
class Animation

  include Reversi
  include Observable
  
  # 斑点アニメーションのスピード ※数値が少ない程遅くなる
  ANIMATION_SPEED = 0.3
  
  #=== 初期化処理
  def initialize(pieces_img)
    @pieces_img = pieces_img
  end

  #=== メンバ初期化
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

  #=== アニメーションパラメータ設定
  def set_state(pieces, statuses, turn)
    # パラメータ初期化
    clear
    
    @statuses = statuses
    @dx = @statuses[@status_count].dx
    @dy = @statuses[@status_count].dy
    @pieces_state = pieces
    @turn = turn
  end
    
  #=== アニメーション実行
  def run
    result = false
    DIVIDE_FILED_Y.times { |i|
      DIVIDE_FILED_X.times { |j|
        # 描画
        state = @pieces_state[DIVIDE_FILED_Y * i + j]
        next if state == PIECE_NONE
        
        index = state
        #p "x:#{@statuses[@status_count].x + @dx}, y:#{@statuses[@status_count].y + @dy}"
        #p "j:#{j}, i:#{i}"
        if (@status_count < @statuses.size)
          if (@statuses[@status_count].x + @dx) == j && (@statuses[@status_count].y + @dy) == i
            if @anim == false
              #-------------------------------
              # アニメーション開始
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
              # アニメーション中
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
                 # 後のターンで上書きされないように
                 result = true
              end
            end
          end
        end
        
        Window.draw(j * DIVIDE_SIZEX + (DIVIDE_SIZEX - @pieces_img[state].width) / 2, i * DIVIDE_SIZEY, @pieces_img[index])
      }
    }
    if (result == true)
      # アニメーション終了通知
      notify
    end
  end
  
  #=== アニメーション終了通知
  def notify
    changed
    notify_observers(@turn)
  end
  
  #=== アニメーションのシーケンス更新
  def update_seq(piece_state, i, j)
    # アニメーション終了
    @anim = false
    # ピース状態の更新
    @pieces_state[DIVIDE_FILED_Y * i + j] = piece_state
    # 次のピースへ
    @anim_index = @anim_index + 1
    
    # 位置更新
    @dx = @dx + @statuses[@status_count].dx
    @dy = @dy + @statuses[@status_count].dy

    if @anim_index == @statuses[@status_count].count
      # 一つの方向のアニメーションが終わり → 次の方向へ
      @status_count = @status_count + 1
      @anim_index = 0
      if @status_count == @statuses.size
        # 全ての方向のアニメーション終了
        return true
      end
      @dx, @dy = @statuses[@status_count].dx, @statuses[@status_count].dy
    end
    return false
  end
  
end

