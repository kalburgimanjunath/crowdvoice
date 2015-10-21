class VoicesSweeper < ActionController::Caching::Sweeper
  observe Voice

  def after_create(voice)
    expire_cache
  end

  def after_update(voice)
    expire_cache
  end

  def after_destroy(voice)
    expire_cache
  end

  private
  def expire_cache
    expire_fragment('aside_menu_bar')
    expire_fragment('homepage')
  end
end
