require 'rubygems'
require 'redcloth'

class RedCloth
  CHORDLINK = /\[\[(.*)\]\]/
  CHO = /\[([^\[\]]+)\]/x
  def refs_textile( text )
    text.gsub!( CHO ) do |m|
      @urlrefs ||= {}
      flag, url = $~[1]

      @urlrefs[flag.downcase] = [url, nil]
      "<span class='chord_link'>[#{flag}]</span>"
    end
  end
end

textile_rules = [:refs_textile, :block_textile_table, :block_textile_lists,
:block_textile_prefix, :inline_textile_image,
:inline_textile_link,
:inline_textile_code, :inline_textile_span, :glyphs_textile]
