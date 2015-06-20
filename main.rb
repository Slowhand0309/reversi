#!ruby -Ks
require "./background"
require "./scene"

# �E�B���h�E�^�C�g���ݒ�
Window.caption = "reversi"

# �t�H���g�쐬
baseFont = Font.new(32)

# �w�i�N���X����
backGround = BackGround.new

# �V�[���Ǘ��N���X����
scene = Scene.new
# �V�[���̏�����
scene.init_scene

#-----------------------------------------------
# ���C�����[�v ESC�L�[�����Ń��[�v�𔲂���
#-----------------------------------------------
Window.loop do

  # �V�[���̍X�V
  scene.update

  # �w�i�`��
  backGround.draw

  # �V�[���`��
  scene.draw

  break if Input.keyPush? K_ESCAPE
  # FPS�\��
  Window.drawFont(0, 0, Window.fps.to_s, baseFont, :color => C_RED)
end
