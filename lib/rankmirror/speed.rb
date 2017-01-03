require 'curb'
require 'colorize'

module RankMirror
	class Speed
		def initialize(uri)
			@uri = uri
			@download_speed = -> (x) {
				r = Curl::Easy.new(x)
				r.perform
				return r.download_speed / 1024.0
			}
		end

		def get
			if RankMirror::Reachable.reachable?(@uri)
				@download_speed.call(@uri)
			else
				puts "#{/\/.*\//.match(@uri)[0].split("/")[2]} has bad repodata, is volatile or too slow, ignored.".red
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
