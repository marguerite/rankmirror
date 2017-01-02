require 'uri'
require 'net/http'
require 'fileutils'
require 'colorize'

module RankMirror
	class Speed
		def initialize(uri)
			@uri = URI.parse(uri)
			@file = @uri.host + "_" + /^.*\/(.*)$/.match(@uri.path)[1]
			@path = /^.*\//.match(@uri.path)[0]
		end

		def get
			if RankMirror::Reachable.reachable?(@uri.scheme + "://" + @uri.host + @path)
				st = Time.now
				thread = Thread.new do
					f = open(@file,'w')
					Net::HTTP.start(@uri.host) do |http|
						begin 
							http.request_get(@uri.path) do |resp|
								resp.read_body {|segment| f.write segment}
							end
						ensure
							f.close
						end
					end
				end
				thread.join
				et = Time.now
				duration = et - st
				size = File.size(@file) / 1024.0
				speed = size / duration
				FileUtils.rm_rf @file
				return speed	
			else
				  puts "#{@uri.host} has bad repodata, is volatile or too slow, ignored.".red
				  # usually in this case, the mirror is online but:
				  # 1. has bad repodata. eg. not fully rsync the origin, or even empty. 
				  # 2. volatile. sometimes at good speed, sometimes unreachable.
				  # 3. too slow. takes more than 5 seconds to start a download.
				  # not break here because we're about to find out the good mirrors, not the bad ones.
				  return 0
			end

		end

		def self.get(uri)
			r = RankMirror::Speed.new(uri)
			return r.get
		end
	end
end
