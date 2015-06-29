#!ruby -Ku
require "./background"
require "./scene"

# ウィンドウタイトル設定
Window.caption = "reversi"

# フォント作成
baseFont = Font.new(32)

# 背景クラス生成
backGround = BackGround.new

# シーン管理クラス生成
scene = Scene.new
# シーンの初期化
scene.init_scene

#-----------------------------------------------
# メインループ ESCキー押下でループを抜ける
#-----------------------------------------------
Window.loop do

  # シーンの更新
  scene.update

  # 背景描画
  backGround.draw

  # シーン描画
  scene.draw

  break if Input.keyPush? K_ESCAPE
  # FPS表示
  Window.drawFont(0, 0, Window.fps.to_s, baseFont, :color => C_RED)
end
