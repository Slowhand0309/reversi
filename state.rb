#!ruby -Ku
require "./common"
require "./reversi_status"

#-------------------------------------
# 盤上での状態管理クラス
#-------------------------------------
module State

  include Reversi

  # チェック対象方向 [上, 下, 右, 左, 右上, 左上, 左下, 右下]
  CHECK_TARGETS = [[0, -1], [0, 1], [1, 0], [-1, 0], [1, -1], [-1, -1], [-1, 1], [1, 1]]

  #=== ゲーム終了判定
  #全てのマスが埋まっていたら終了
  def game_over?(states)
    states.each { |piece|
      return false if piece == PIECE_NONE
    }
    return true
  end

  #=== 勝利者判定
  def who_winner?(states)
    # 白の枚数を数える
    count = 0
    states.each { |piece|
      if piece == PIECE_WHITE
        count += 1
      end
    }
    return PIECE_NONE if (states.size / 2 == count) # 引き分け
    return PIECE_WHITE if (states.size / 2 < count) # 白の勝ち
    return PIECE_BLACK
  end

  #=== 状態更新
  #チェック対象の方向にチェックを行い、反転できるピースを反転させる
  def updateState(pieces, x, y, state, check)
    statuses = Array.new
    # 全方向に対してチェック
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
          # 反転
          1.upto(count) { |idx|
            pieces[(y + (dy * idx)) * DIVIDE_FILED_X + x + (dx * idx)] = state
          }
        end
      end
    }
    return statuses
  end

  #=== 反転可否
  #x, yの位置からdx, dy方向へ反転できるか検索
  def reverse?(x, y, dx, dy, state, pieces)
    count = 0
    reverse = false
    _x, _y = x, y
    while ((_x >= 0 && _x <= DIVIDE_FILED_X)) &&
          ((_y >= 0 && _y <= DIVIDE_FILED_Y)) do

       # 進んだ先の状態を取得
       index = (_y + dy) * DIVIDE_FILED_X + _x + dx
       if index < 0 || index > pieces.size
         break
       end

       temp = pieces[index]
       #p "temp : #{temp}, count:#{count}"
       # 進んだ先が何も無ければ終了
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

    # 反転するかと反転するピース数を返す
    return reverse, count
  end

  module_function :updateState
  module_function :game_over?
  module_function :reverse?
  module_function :who_winner?
end
