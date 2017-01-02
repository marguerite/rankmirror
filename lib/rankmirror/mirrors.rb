module RankMirror
	class Mirrors

		def initialize(mirrors)
			@mirrors = mirrors
		end

		def validate
			mirrors = Array.new
			@mirrors.each do |mirror|
				if RankMirror::Reachable.reachable?(mirror)
					mirrors << mirror
				end
			end
			return mirrors
		end

		def self.validate(mirrors)
			m = RankMirror::Mirrors.new(mirrors)
			return m.validate
		end

		def sort_by_speed(options)
			speed_matrix,sorted = Hash.new,Hash.new
			validated = RankMirror::Mirrors.validate(@mirrors)

			size = validated.length
			jobs = Queue.new
			validated.each {|i| jobs.push i}

			workers = size.times.map do
				Thread.new do 
					begin
						while x = jobs.pop(true)
							x += "/" unless x.index(/\/$/)
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
