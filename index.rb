require 'rubygems'
require 'sinatra'
require 'chord'

## 
# Uke/Tommacwright
#
# TODO: generalize chord library
# TODO: track dependencies
# TODO: store front page configuration as YAML
# TODO: create backend system or interface
# TODO: standardize syntax
# TODO: create user input system
# TODO: optimize w/ caching
# TODO: switch from HAML to erb
# TODO: switch to uchord


def get_tabs
  @tabs  = []
  Dir.new('/home/tom/ukulele/tabs').entries.each do |tab|
    if tab.include? "-" and parts = tab.split("-")
      artist = parts[0].gsub(/_/, " ")
      song = parts[1].gsub(/_/, " ").sub(".txt", " ")
      url = '/tab/'+tab.sub(".txt", "")
      @tabs << {:artist => artist, :song => song, :url => url}
    end
  end
  return @tabs
end

get '/' do
  @tabs = get_tabs
  haml :index
end

get '/tab/:tab' do
  # return a tab; this needs to be checked against
  # reaching back in the filesystem
  require 'tab_parser'
  tab = params[:tab]
  #TODO: detect when files are not found
  text = File.read('/home/tom/ukulele/tabs/'+tab+".txt")
  CHO = /\[([^\[\]]+)\]/x
  @tab_text = RedCloth.new(text).to_html
  @chords = text.scan(CHO).uniq.map{ |c| c[0].gsub("#", "x") }
  # print @chords
  @artist = tab.split("-")[0].gsub(/_/, " ")
  @song = tab.split("-")[1].gsub(/_/, " ").sub(".txt", "")
  @tabs = get_tabs
  haml :tab
end

get '/chord/:chordname' do
  # Generate or redirect to a chord image;
  # this is dependent on the chord images being statically served
  chord_name = params[:chordname]
  draw_chord(chord_name)
  redirect '/chords/'+chord_name+'.png'
end
