require 'ostruct'

module RankMirror
	class LocalOSS
		def initialize(mirrorlist,options)
			@options = options
			@mirrorlist = RankMirror::Config.new(@options).parse(mirrorlist)
		end

		def sort
			sorted = @mirrorlist.map! { |m|
				m.http if @options.continent == m.continent && m[@options.flavor] == "true"
			}.compact!
			return sorted
		end
	end
end

