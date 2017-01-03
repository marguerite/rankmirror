module RankMirror
	class MirrorLists
		def initialize
			@mirrorlist = Array.new
		end

		def join(mirrorlists)
			mirrorlists.each {|mirrorlist| @mirrorlist.concat(mirrorlist) }
			return @mirrorlist.uniq
		end

		def show
			@mirrorlist
		end
	end
end

