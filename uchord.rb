require 'rubygems'
require 'RMagick'

# This script draws ukulele chords for use in
# tabs or elsewhere. By default, it draws chords for concert/soprano
# ukuleles in GCEA tuning
#
# Author:: Tom MacWright (mailto:macwright@gmail.com

class UChord
  # This is a list of ukulele chords in standard (GCEA) tuning
  CHORD_LIST = {
    'C'      => [3, 0, 0, 0],
    'Cm'       => [3, 3, 3, 0],
    'C7'       => [1, 0, 0, 0],
    'CM7'      => [2, 0, 0, 0],
    'Cm7'      => [3, 3, 3, 3],
    'Cdim'     => [3, 2, 3, 2],
    'Cm7(b5)'    => [3, 2, 3, 3],
    'Caug'     => [3, 0, 0, 1],
    'Csus4'    => [3, 3, 5, 5],
    'C6'       => [0, 0, 0, 0],
    'C7(9)'    => [1, 0, 2, 0],
    'CM7(9)'     => [2, 0, 2, 0],
    'CmM7'     => [3, 3, 3, 4],
    'Cadd9'    => [3, 0, 2, 0],
    'C#'       => [4, 1, 1, 1],
    'C#m'      => [4, 4, 4, 1],
    'C#7'      => [2, 1, 1, 1],
    'C#M7'     => [3, 1, 1, 1],
    'C#m7'     => [2, 0, 1, 1],
    'C#dim'    => [1, 0, 1, 0],
    'C#m7(b5)'   => [3, 2, 3, 3],
    'C#aug'    => [0, 1, 1, 2],
    'C#sus4'     => [2, 2, 1, 1],
    'C#6'      => [1, 1, 1, 1],
    'C#7(9)'     => [2, 1, 3, 1],
    'C#M7(9)'    => [3, 1, 3, 1],
    'C#mM7'    => [3, 0, 1, 1],
    'C#add9'     => [4, 1, 3, 1],
    'Db'       => [4, 1, 1, 1],
    'Dbm'      => [4, 4, 4, 1],
    'Db7'      => [2, 1, 1, 1],
    'DbM7'     => [3, 1, 1, 1],
    'Dbm7'     => [2, 0, 1, 1],
    'Dbdim'    => [1, 0, 1, 0],
    'Dbm7(b5)'   => [3, 2, 3, 3],
    'Dbaug'    => [0, 1, 1, 2],
    'Dbsus4'     => [2, 2, 1, 1],
    'Db6'      => [1, 1, 1, 1],
    'Db7(9)'     => [2, 1, 3, 1],
    'DbM7(9)'    => [3, 1, 3, 1],
    'DbmM7'    => [3, 0, 1, 1],
    'Dbadd9'     => [4, 1, 3, 1],
    'D'      => [0, 2, 2, 2],
    'Dm'       => [0, 1, 2, 2],
    'D7'       => [3, 2, 2, 2],
    'DM7'      => [4, 2, 2, 2],
    'Dm7'      => [3, 1, 2, 2],
    'Ddim'     => [2, 1, 2, 1],
    'Dm7(b5)'    => [3, 1, 2, 1],
    'Daug'     => [1, 2, 2, 3],
    'Dsus4'    => [0, 3, 2, 2],
    'D6'       => [2, 2, 2, 2],
    'D7(9)'    => [3, 2, 4, 2],
    'DM7(9)'     => [4, 2, 4, 2],
    'DmM7'     => [4, 1, 2, 2],
    'Dadd9'    => [5, 2, 4, 2],
    'D#'       => [1, 3, 3, 0],
    'D#m'      => [1, 2, 3, 3],
    'D#7'      => [4, 3, 3, 3],
    'D#M7'     => [5, 3, 3, 3],
    'D#m7'     => [4, 2, 3, 3],
    'D#dim'    => [3, 2, 3, 2],
    'D#m7(b5)'   => [4, 2, 3, 2],
    'D#aug'    => [2, 3, 3, 0],
    'D#sus4'     => [1, 4, 3, 3],
    'D#6'      => [4, 4, 4, 4],
    'D#7(9)'     => [1, 1, 1, 0],
    'D#M7(9)'    => [1, 1, 2, 0],
    'D#mM7'    => [5, 2, 3, 3],
    'D#add9'     => [1, 1, 3, 0],
    'Eb'       => [1, 3, 3, 0],
    'Ebm'      => [1, 2, 3, 3],
    'Eb7'      => [4, 3, 3, 3],
    'EbM7'     => [5, 3, 3, 3],
    'Ebm7'     => [4, 2, 3, 3],
    'Ebdim'    => [3, 2, 3, 2],
    'Ebm7(b5)'   => [4, 2, 3, 2],
    'Ebaug'    => [2, 3, 3, 0],
    'Ebsus4'     => [1, 4, 3, 3],
    'Eb6'      => [4, 4, 4, 4],
    'Eb7(9)'     => [1, 1, 1, 0],
    'EbM7(9)'    => [1, 1, 2, 0],
    'EbmM7'    => [5, 2, 3, 3],
    'Ebadd9'     => [1, 1, 3, 0],
    'E'      => [2, 4, 4, 4],
    'Em'       => [2, 3, 4, 0],
    'E7'       => [2, 0, 2, 1],
    'EM7'      => [2, 0, 3, 1],
    'Em7'      => [2, 0, 2, 0],
    'Edim'     => [1, 0, 1, 0],
    'Em7(b5)'    => [1, 0, 2, 0],
    'Eaug'     => [3, 0, 0, 1],
    'Esus4'    => [2, 5, 4, 4],
    'E6'       => [2, 0, 1, 1],
    'E7(9)'    => [2, 2, 2, 1],
    'EM7(9)'     => [2, 2, 3, 1],
    'EmM7'     => [2, 0, 3, 0],
    'Eadd9'    => [2, 2, 4, 1],
    'F'      => [0, 1, 0, 2],
    'Fm'       => [3, 1, 0, 1],
    'F7'       => [3, 1, 3, 2],
    'FM7'      => [0, 0, 5, 5],
    'Fm7'      => [3, 1, 3, 1],
    'Fdim'     => [2, 1, 2, 1],
    'Fm7(b5)'    => [2, 1, 3, 1],
    'Faug'     => [0, 1, 1, 2],
    'Fsus4'    => [1, 1, 0, 3],
    'F6'       => [3, 1, 2, 2],
    'F7(9)'    => [3, 3, 3, 2],
    'FM7(9)'     => [0, 0, 0, 0],
    'FmM7'     => [3, 1, 4, 1],
    'Fadd9'    => [0, 1, 0, 0],
    'F#'       => [1, 2, 1, 3],
    'F#m'      => [0, 2, 1, 2],
    'F#7'      => [4, 2, 4, 3],
    'F#M7'     => [4, 2, 5, 3],
    'F#m7'     => [4, 2, 4, 2],
    'F#dim'    => [3, 2, 3, 2],
    'F#m7(b5)'   => [3, 2, 4, 2],
    'F#aug'    => [1, 2, 2, 3],
    'F#sus4'     => [4, 2, 4, 4],
    'F#6'      => [4, 2, 3, 3],
    'F#7(9)'     => [4, 4, 4, 3],
    'F#M7(9)'    => [1, 1, 1, 1],
    'F#mM7'    => [4, 2, 5, 2],
    'F#add9'     => [1, 2, 1, 1],
    'Gb'       => [1, 2, 1, 3],
    'Gbm'      => [0, 2, 1, 2],
    'Gb7'      => [4, 2, 4, 3],
    'GbM7'     => [4, 2, 5, 3],
    'Gbm7'     => [4, 2, 4, 2],
    'Gbdim'    => [3, 2, 3, 2],
    'Gbm7(b5)'   => [3, 2, 4, 2],
    'Gbaug'    => [1, 2, 2, 3],
    'Gbsus4'     => [4, 2, 4, 4],
    'Gb6'      => [4, 2, 3, 3],
    'Gb7(9)'     => [4, 4, 4, 3],
    'GbM7(9)'    => [1, 1, 1, 1],
    'GbmM7'    => [4, 2, 5, 2],
    'Gbadd9'     => [1, 2, 1, 1],
    'G'      => [2, 3, 2, 0],
    'Gm'       => [1, 3, 2, 0],
    'G7'       => [2, 1, 2, 0],
    'GM7'      => [2, 2, 2, 0],
    'Gm7'      => [1, 1, 2, 0],
    'Gdim'     => [1, 0, 1, 0],
    'Gm7(b5)'    => [1, 1, 1, 0],
    'Gaug'     => [2, 3, 3, 0],
    'Gsus4'    => [3, 3, 2, 0],
    'G6'       => [2, 0, 2, 0],
    'G7(9)'    => [2, 1, 2, 2],
    'GM7(9)'     => [2, 2, 2, 2],
    'GmM7'     => [5, 3, 6, 3],
    'Gadd9'    => [2, 3, 2, 2],
    'G#'       => [3, 4, 3, 5],
    'G#m'      => [2, 4, 3, 1],
    'G#7'      => [3, 2, 3, 1],
    'G#M7'     => [3, 3, 3, 1],
    'G#m7'     => [2, 2, 3, 1],
    'G#dim'    => [2, 1, 2, 1],
    'G#m7(b5)'   => [2, 2, 2, 1],
    'G#aug'    => [3, 0, 0, 1],
    'G#sus4'     => [4, 4, 3, 1],
    'G#6'      => [3, 1, 3, 1],
    'G#7(9)'     => [3, 2, 3, 3],
    'G#M7(9)'    => [3, 3, 3, 3],
    'G#mM7'    => [6, 4, 7, 4],
    'G#add9'     => [3, 4, 3, 3],
    'Ab'       => [3, 4, 3, 5],
    'Abm'      => [2, 4, 3, 1],
    'Ab7'      => [3, 2, 3, 1],
    'AbM7'     => [3, 3, 3, 1],
    'Abm7'     => [2, 2, 3, 1],
    'Abdim'    => [2, 1, 2, 1],
    'Abm7(b5)'   => [2, 2, 2, 1],
    'Abaug'    => [3, 0, 0, 1],
    'Absus4'     => [4, 4, 3, 1],
    'Ab6'      => [3, 1, 3, 1],
    'Ab7(9)'     => [3, 2, 3, 3],
    'AbM7(9)'    => [3, 3, 3, 3],
    'AbmM7'    => [6, 4, 7, 4],
    'Abadd9'     => [3, 4, 3, 3],
    'A'      => [0, 0, 1, 2],
    'Am'       => [0, 0, 0, 2],
    'A7'       => [0, 0, 1, 0],
    'AM7'      => [0, 0, 1, 1],
    'Am7'      => [0, 0, 0, 0],
    'Adim'     => [3, 2, 3, 2],
    'Am7(b5)'    => [3, 3, 3, 2],
    'Aaug'     => [0, 1, 1, 2],
    'Asus4'    => [0, 0, 2, 2],
    'A6'       => [4, 2, 4, 2],
    'A7(9)'    => [2, 3, 1, 2],
    'AM7(9)'     => [2, 4, 1, 2],
    'AmM7'     => [0, 0, 0, 1],
    'Aadd9'    => [2, 0, 1, 2],
    'A#'       => [1, 1, 2, 3],
    'A#m'      => [1, 1, 1, 3],
    'A#7'      => [1, 1, 2, 1],
    'A#M7'     => [0, 1, 2, 3],
    'A#m7'     => [1, 1, 1, 1],
    'A#dim'    => [1, 0, 1, 0],
    'A#m7(b5)'   => [1, 0, 1, 1],
    'A#aug'    => [1, 2, 2, 3],
    'A#sus4'     => [1, 1, 3, 3],
    'A#6'      => [1, 1, 2, 0],
    'A#7(9)'     => [3, 4, 2, 3],
    'A#M7(9)'    => [5, 5, 5, 5],
    'A#mM7'    => [1, 1, 1, 2],
    'A#add9'     => [3, 1, 2, 3],
    'Bb'       => [1, 1, 2, 3],
    'Bbm'      => [1, 1, 1, 3],
    'Bb7'      => [1, 1, 2, 1],
    'BbM7'     => [0, 1, 2, 3],
    'Bbm7'     => [1, 1, 1, 1],
    'Bbdim'    => [1, 0, 1, 0],
    'Bbm7(b5)'   => [1, 0, 1, 1],
    'Bbaug'    => [1, 2, 2, 3],
    'Bbsus4'     => [1, 1, 3, 3],
    'Bb6'      => [1, 1, 2, 0],
    'Bb7(9)'     => [3, 4, 2, 3],
    'BbM7(9)'    => [5, 5, 5, 5],
    'BbmM7'    => [1, 1, 1, 2],
    'Bbadd9'     => [3, 1, 2, 3],
    'B'      => [2, 2, 3, 4],
    'Bm'       => [2, 2, 2, 4],
    'B7'       => [2, 2, 3, 2],
    'BM7'      => [1, 2, 3, 4],
    'Bm7'      => [2, 2, 2, 2],
    'Bdim'     => [2, 1, 2, 1],
    'Bm7(b5)'    => [2, 1, 2, 2],
    'Baug'     => [2, 3, 3, 4],
    'Bsus4'    => [2, 2, 4, 4],
    'B6'       => [2, 2, 3, 1],
    'B7(9)'    => [4, 2, 3, 2],
    'BM7(9)'     => [4, 1, 3, 3],
    'BmM7'     => [2, 2, 2, 3],
    'Badd9'    => [4, 2, 3, 4],
  }
  
  NOTES = ['C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B']
  STRINGS = ['G', 'C', 'E', 'A']
  
  def draw_chord(chord_name)
    # chord_name.gsub!("x", "#")
    if not FileTest.exist? "/home/tom/ukulele/static/chords/"+chord_name+".png"
      chord(chord_name)
    end
  end
  
  def chord(chord_name)
    return generate(chord_name, get_flets(chord_name.gsub("x", "#")))
  end
  
  def get_flets(chord_name)
    if CHORD_LIST.has_key? chord_name then
      return CHORD_LIST[chord_name].reverse
    else
      chord_name.sub!("maj", "M")
      if CHORD_LIST.has_key? chord_name then
        return CHORD_LIST[chord_name].reverse
      end
    end
  end
  
  def generate(chord, flets)
    # Frets are 10px high
    # The strings are 12px apart
    height = (flets.max * 10) + 60
    width = ((STRINGS.length - 1) * 12) + 16
    last_fret = 15 + ((flets.max + 1) * 10)
    last_string = 5 + ((STRINGS.length - 1) * 12)
    canvas = Magick::Image.new(width, height)
    gc = Magick::Draw.new
    gc.stroke('gray25')
    (0..(STRINGS.length - 1)).each do |string|
      gc.line(5 + 12 * string, 15, 5 + 12 * string, last_fret)
    end
    (0..(flets.max + 1)).each do |fret|
      if fret == 0
        gc.stroke_width(3)
      else
        gc.stroke_width(1)
      end 
      gc.line(5, 15 + 10 * fret, last_string, 15 + 10 * fret)
    end
    gc.stroke('transparent')
    i = 0
    flets.each { |f|
      if f > 0 then
        gc.circle(
          5 + 12 * i,
          15 + 10 * f,
          8 + 12 * i,
          18 + 10 * f
          )
      end
      a = NOTES.index(STRINGS[i]) + f
      n = a % NOTES.length
      gc.font_family = "arial"
      gc.pointsize = 6
      gc.text(1 + 13 * i, last_fret + 14, NOTES[n])
      i = i + 1
    }
    gc.font_weight = 100
    gc.pointsize = 11
    gc.text(0, 10, chord.gsub("x", "#"))
    gc.draw(canvas)
    canvas.write('static/chords/'+chord+".png")
  end
end
