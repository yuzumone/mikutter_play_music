# -*- coding: utf-8 -*-

require 'json'

Plugin.create(:mikutter_play_music) do

  @path = "#{Dir.home}/.config/Google\sPlay\sMusic\sDesktop\sPlayer/json_store/playback.json"
  @last_title = nil

  def music_info
    json = open(@path) do |io|
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
      music_info
      next_music
    }
  end

  music_info
  next_music
end
