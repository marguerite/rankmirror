require 'fileutils'
require 'uri'
require 'ostruct'

module RankMirror
	class Config

		def initialize(options)
			@options = options
			@name = @options.os
			@file = @name + ".mirrorlist"
			@systempath = File.expand_path(File.join(File.dirname(__FILE__),"mirrorlists"))
			@localpath = ENV['HOME'] + "/.rankmirror/"
		end

		def path
			if File.exist?(systemconfig) && File.readable?(systemconfig)
				if File.exist?(localconfig)
					m = merge(systemconfig,localconfig)
					write(m,localconfig,@options.keys)
					localconfig
				else
					systemconfig
				end
			else
				if File.exist?(localconfig)
					localconfig
				else
					nil
				end
			end
		end
        
		def save(array,header)
			FileUtils.mkdir_p @localpath unless File.directory?(@localpath)
			mirrors_array = array.map! do |uri|
				mirror = RankMirror::Status.new(uri,@name).get
				mirror.name = URI.parse(uri).host if mirror.name.nil?
				mirror.continent = "world" if ["opensuse","packman"].include?(@name)
				mirror.country = "world"
				mirror.http = uri
				mirror
			end
			write(mirrors_array,localconfig,header)
		end

		def parse(config,args)
			f = open(config)
			mirrors = f.readlines.map!{|l|
				unless l.start_with?("#")
					elements = l.strip.split("\t")
					mirror = OpenStruct.new
					args.each_with_index {|arg,index| mirror[arg] = elements[index] }
					mirror
				end
			}.compact
			f.close
			return mirrors
		end

		private

		def localconfig
			File.join(@localpath,@file)
		end

		def systemconfig
			File.join(@systempath,@file)
		end
        
		def merge(systemconfig,localconfig)
			system_mirrors = parse(systemconfig,@options.keys)
			local_mirrors = parse(localconfig,@options.keys)
			system_mirrors.each do |system_mirror|
				http_match = false
				local_mirrors.each do |local_mirror|
					if system_mirror.http == local_mirror.http
						http_match = true
						local_mirror.continent = system_mirror.continent if ["opensuse","packman"].include?(@name)
						local_mirror.country = system_mirror.country
					end
				end
				if http_match == false
					local_mirrors << system_mirror
				end
			end
			return local_mirrors
		end

		def write(mirrors_array,file,header)
			f = open(file,'w')
			f.write process_header(header)
			mirrors_array.each do |m|
				str = String.new
				header.each do |item|
					if header.index(item) == header.size - 1
						str << m[item].to_s + "\n"
					else
						str << m[item].to_s + "\t"
					end
				end
				f.write str
			end
			f.close
		end

		def process_header(header)
			str = "#"
			header.each do |title|
				if title == header[header.size - 1]
					str << title + "\n"
				else
					str << title + "\t"
				end
			end
			return str
		end

	end

end
