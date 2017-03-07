require 'curb'
require 'nokogiri'
module RankMirror
  class Cache
    def initialize(uri)
      @uri = uri
      @host = @uri.gsub(%r{^http(s)://}, '').tr('/', '_')
      @filename = File.join('/tmp', @host)
    end

    def fetch
      unless recent?
        buffer = open(@filename, 'w')
        r = Curl::Easy.new(@uri)
        r.on_body do |b|
          buffer.write b
        end
        r.perform
        buffer.close
        to_xml
      end
      @filename + '.xml'
    end

    def to_xml
      buffer = open(@filename, &:read)
      doc = Nokogiri::XML(buffer)
      f = open(@filename + '.xml', 'w')
      doc.write_xml_to(f)
      f.close
    end

    def recent?
      return false unless File.exist?(@filename + '.xml')
      last_time = File.mtime(@filename + '.xml')
      # one week
      Time.now - last_time < 60 * 60 * 24 * 7 ? true : false
    end
  end
end
