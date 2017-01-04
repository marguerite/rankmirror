module RankMirror
	class Mirrors

		def initialize(mirrors)
			@mirrors = mirrors.map!{|mirror| mirror if RankMirror::Reachable.new(mirror).reachable?}.compact!
		end

		def sort_by_speed(options)
			speed_matrix = Hash.new
			size = @mirrors.length
			jobs = Queue.new
			@mirrors.each {|i| jobs.push i}

			workers = size.times.map do
				Thread.new do 
					begin
						while x = jobs.pop(true)
							x << "/" unless x.index(/\/$/)
							uri = x + options.path + options.file
							speed = RankMirror::Speed.new(uri).get
							speed_matrix[x] = speed
						end
					rescue ThreadError
					end
				end
			end

			workers.map(&:join)

			speed_sorted = speed_matrix.values.sort.reverse
			sorted = Hash.new
			speed_sorted.each {|v| sorted[speed_matrix.key(v)] = v}
			
			return sorted
		end
	end
end
