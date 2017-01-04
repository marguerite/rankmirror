require 'ostruct'

module RankMirror
	class Options
		def initialize
			@options = OpenStruct.new
			@options.local = false
			@options.os = "opensuse"
			@options.continent = "asia"
			@options.flavor = "leap4220"
			@options.quick = true
			@options.path = nil
			@options.file = "repomd.xml"
		end

		def show
			return @options
		end

		def add(k,v)
			@options[k] = v
			return @options
		end

		def delete_by_key(key)
			@options.delete_field(key)
			return @options
		end

		def delete_by_value(value)
			h = @options.to_h
			@options.delete_field(h.key(value))
			return @options
		end

		def local=(v)
			@options.local = v
		end

		def local
			@local ||= @options.local
		end

		def os=(v)
			@options.os = v
		end

		def os
			@os ||= @options.os
		end

		def continent=(v)
			@options.continent = v
		end

		def continent
			@continent ||= @options.continent
		end

		def flavor=(v)
			@options.flavor = v
		end

		def flavor
			@flavor ||= @options.flavor
		end

		def quick=(v)
			@options.quick = v
		end

		def quick
			@quick ||= @options.quick
		end

		def path=(v)
			@options.path = v
		end

		def path
			@path ||= @options.path
		end

		def file=(v)
			@options.file = v
		end

		def file
			@file ||= @options.file
		end

		def save=(v)
			@options.save = v
		end

		def save
			@save ||= @options.save
		end
	end
end
