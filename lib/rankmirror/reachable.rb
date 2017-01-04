require 'curb'

module RankMirror
	class Reachable
		def initialize(uri)
			@uri = uri
			@ping = -> (x) {
				r = Curl::Easy.new(x)
				r.timeout_ms = 1000
				r.perform
				if r.response_code == 404
					false
				else
					true
				end
				}
		end

		def reachable?
			begin 
				@ping.call(@uri)
			rescue
				return false
			end
		end
	end
end         
