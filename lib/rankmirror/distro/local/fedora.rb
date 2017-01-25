module RankMirror
	class LocalFedora
		def initialize(mirrorlist,options)
			@options = options
			@mirrorlist = RankMirror::Config.new(@options).parse(mirrorlist,@options.keys)
		end

		def sort
			sorted = @mirrorlist.map!{|m|
				m.http if @options.country == m.country && m[@options.flavor] == "true"
				}.compact
			return sorted
		end
	end
end
