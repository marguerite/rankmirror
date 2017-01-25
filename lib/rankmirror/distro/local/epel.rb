module RankMirror
	class LocalEPEL
		def initialize(mirrorlist,options)
			@options = options
			args = ["name","country","http","epel7","epel6","epel5","epel4"]
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
