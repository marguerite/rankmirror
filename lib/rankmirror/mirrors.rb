module RankMirror
	class Mirrors

		def initialize(mirrors)
			@mirrors = mirrors.map!{|mirror| mirror if RankMirror::Reachable.reachable?(mirror)}.compact!
		end

		def sort_by_speed(options)
			speed_matrix,sorted = Hash.new,Hash.new
			size = @mirrors.length
			jobs = Queue.new
			@mirrors.each {|i| jobs.push i}

			workers = size.times.map do
				Thread.new do 
					begin
						while x = jobs.pop(true)
							x << "/" unless x.index(/\/$/)
							uri = x + options.path + options.file
							speed = RankMirror::Speed.get(uri)
							speed_matrix[x] = speed
						end
					rescue ThreadError
					end
				end
			end

			workers.map(&:join)

			speed_sorted = speed_matrix.values.sort.reverse
			speed_sorted.each {|v| sorted[speed_matrix.key(v)] = v}
			
			return sorted
		end

		def self.sort_by_speed(mirrors,options)
			m = RankMirror::Mirrors.new(mirrors)
			return m.sort_by_speed(options)
		end
	end
end
