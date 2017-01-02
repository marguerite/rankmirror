require 'net/http'
require 'uri'
require 'timeout'

module RankMirror
	class Reachable
		def initialize(uri)
			@uri = URI.parse uri
		end

		def self.reachable?(uri)
			r = RankMirror::Reachable.new(uri)
			return r.reachable?
		end

		def reachable?
			begin 
				Timeout::timeout(5) do
					r = Net::HTTP.get_response(@uri)
					if r.code == "404"
						return false
					else
						return true
					end
				end
			rescue
				return false
			end
		end
	end
end

