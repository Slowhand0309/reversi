#!ruby -Ks
require "./common"
require "./state"

#-------------------------------------
# コンピュータクラス
#-------------------------------------
class Compute
  
  include Reversi
  
  WAIT_COUNT = 80 # 待機カウント
  
  def initialize(state, imgPiece, piecesState, callBack)
    @state = state
    @pieceImg = imgPiece
    @piecesState = piecesState
    @callback = callBack
    @wait_count = 0
  end
  
  def update
  
    if WAIT_COUNT > @wait_count
      # 待機中・・・
      @wait_count += 1
      return
    end
    
    # 待機カウンタリセット
    @wait_count = 0
    
    # 一番ひっくり返す数が多い箇所を算出
    x, y = compute_position
    
    # しばし待つ
    #sleep(WAIT_SEC)
    #p "com update x:#{x}, y:#{y}"
    # 実際の更新
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

