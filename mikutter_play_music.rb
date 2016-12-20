# -*- coding: utf-8 -*-

Plugin.create(:mikutter_play_music) do

  defevent :play_music_info
  @last_title = nil

  on_boot do
    Plugin.call(:play_music_info)
    next_music
  end

  on_play_music_info do
    path = "#{Dir.home}/.config/Google\sPlay\sMusic\sDesktop\sPlayer/json_store/playback.json"
    json = open(path) do |io|
      JSON.load(io)
    end
    
    if json['playing']
      title = json['song']['title']
      artist = json['song']['artist']
      album = json['song']['album']
      if @last_title != title
        activity(:system, "#nowplaying #{title} / #{artist} / #{album}")
        @last_title = title
      end
    end
  end

  def next_music
    Reserver.new(60) {
      Plugin.call(:play_music_info)
      next_music
    }
  end
end
