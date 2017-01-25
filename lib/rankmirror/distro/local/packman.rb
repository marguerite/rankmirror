module RankMirror
	class LocalPackman
		def initialize(mirrorlist,options)
			@options = options
			args = ["name","continent","country","http","tumbleweed","leap4220","leap4210","leap4230"]
			@mirrorlist = RankMirror::SUSEConfig.new(@options).parse(mirrorlist,args)
		end

		def sort
			sorted = @mirrorlist.map!{|m|
					m.http if @options.continent == m.continent && m[@options.flavor] == "true"
			}.compact!
			return sorted
		end
	end
end

