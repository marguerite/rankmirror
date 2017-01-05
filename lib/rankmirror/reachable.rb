require 'curb'

module RankMirror
	class Reachable
		def initialize(uri,timeout)
			@uri = uri
			@timeout = timeout
		end

		def reachable?
			begin
				r = Curl::Easy.new(@uri)
				r.timeout_ms = @timeout
				r.perform
				if r.response_code == 404
					false
				else
					true
				end
			rescue
				return false
			end
		end
	end
end
