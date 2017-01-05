require 'curb'

module RankMirror
	class Speed
		def initialize(uri)
			@uri = uri
		end

		def get
			if RankMirror::Reachable.new(@uri).reachable?
				r = Curl::Easy.new(@uri)
				r.perform
				return r.download_speed / 1024.0
			#else
				# usually in this case, the mirror is online but:
				# 1. has bad repodata. eg. not fully rsync the origin, or even empty. 
				# 2. volatile. sometimes at good speed, sometimes unreachable.
				# 3. too slow. takes more than 5 seconds to start a download.
				# not break here because we're about to find out the good mirrors, not the bad ones.
			end
		end
	end
end
