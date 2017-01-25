module RankMirror
	class LocalFedora
		def initialize(mirrorlist,options)
			@options = options
			args = ["name","country","http","fedora25","fedora24","fedora23","fedora22","fedora21","fedora20"]
			@mirrorlist = RankMirror::Config.new(@options).parse(mirrorlist,args)
		end

		def sort
			sorted = @mirrorlist.map!{|m|
				m.http if @options.country = m.country && m[@options.flavor] == "true"
				}.compact
			return sorted
		end
	end
end
