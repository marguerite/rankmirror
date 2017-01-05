require 'ostruct'

module RankMirror
	class Status
		def initialize(uri,distro)
			uri << "/" unless /^.*\/$/.match(uri)
			@uri = uri
			@distro = distro
		end

		def get
			if RankMirror::Reachable.new(@uri,500).reachable?
				case @distro
				when "opensuse"
					tumbleweed = "tumbleweed/repo/oss/suse/repodata/"
					leap4220 = "distribution/leap/42.2/repo/oss/suse/repodata/"
					leap4210 = "distribution/leap/42.1/repo/oss/suse/repodata/"
					leap4230 = "distribution/leap/42.3/repo/oss/suse/repodata/"
					
					checklist = {"tumbleweed"=>tumbleweed,"leap4220"=>leap4220,"leap4210"=>leap4210,"leap4230"=>leap4230}
					mirror = OpenStruct.new
					mirror.http = @uri
					
					checklist.each do |k,v|
						if RankMirror::Reachable.new(@uri + v,500).reachable?
							mirror[k] = true
						else
							mirror[k] = false
						end
					end
					return mirror
				when "packman"
					tumbleweed = "Tumbleweed"
					leap4220 = "Leap_42.2"
					leap4210 = "Leap_42.1"
					leap4230 = "Leap_42.3"
					checklist = {"tumbleweed"=>tumbleweed,"leap4220"=>leap4220,"leap4210"=>leap4210,"leap4230"=>leap4230}

					mirror = OpenStruct.new
					mirror.http = @uri

					checklist.each do |k,v|
						if RankMirror::Reachable.new(@uri + "openSUSE_" + v + "/Essentials/repodata/",500).reachable?
							mirror[k] = true
						else
							mirror[k] = false
						end
					end
					return mirror
				else
				end
			else
				return nil
			end
		end
	end
end
