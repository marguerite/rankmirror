require 'fileutils'
require 'uri'
require 'ostruct'

module RankMirror
	class Config

		def initialize(options)
			@options = options
			@name = @options.os
			@file = @name + ".mirrorlist"
			@systempath = File.expand_path(File.dirname(__FILE__))
			@localpath = ENV['HOME'] + "/.rankmirror/"
		end

		def localconfig
			File.join(@localpath,@file)
		end

		def systemconfig
			File.join(@systempath,@file)
		end

		def path
			if File.exist?(systemconfig) && File.readable?(systemconfig)
				if File.exist?(localconfig)
					m = merge(systemconfig,localconfig)
					write(m,localconfig)
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

		def merge(systemconfig,localconfig)
			system_mirrors = parse(systemconfig)
			local_mirrors = parse(localconfig)
			system_mirrors.each do |system_mirror|
				http_match = false
				local_mirrors.each do |local_mirror|
					if system_mirror.http == local_mirror.http
						http_match = true
						local_mirror.continent = system_mirror.continent
						local_mirror.country = system_mirror.country
					end
				end
				if http_match == false
					local_mirrors << system_mirror
				end
			end
			return local_mirrors
		end

		def parse(config)
			f = open(config)
			mirrors = f.readlines.map!{|l|
				unless l.start_with?("#")
					elements = l.strip.split("\t")
					mirror = OpenStruct.new
					mirror.name = elements[0]
					mirror.continent = elements[1]
					mirror.country = elements[2]
					mirror.http = elements[3]
					mirror.tumbleweed = elements[4]
					mirror.leap4220 = elements[5]
					mirror.leap4210 = elements[6]
					mirror.leap4230 = elements[7]
					mirror
				end
				}.compact!
			f.close
			return mirrors
		end

		def write(mirrors_array,file)
			f = open(file,'w')
			f.write "#sitename\tcontinent\tcountry\thttp\ttumbleweed\tleap4220\tleap4210\tleap4230\n"
			mirrors_array.each do |mirror_struct|
				str = String.new
				m = mirror_struct
				str = m.name + "\t" + m.continent + "\t" + m.country + "\t" + m.http + "\t" + m.tumbleweed.to_s + "\t" + m.leap4220.to_s + "\t" + m.leap4210.to_s + "\t" + m.leap4230.to_s + "\n"
				f.write str
			end
			f.close
		end
        
		def save(array)
			FileUtils.mkdir_p @localpath unless File.directory?(@localpath)
			mirrors_array = array.map! do |uri|
				status = RankMirror::Status.new(uri)
				mirror = status.get(@options)
				mirror.name = URI.parse(uri).host if mirror.name.nil?
				mirror.continent,mirror.country = "world","world"
				mirror
			end
			write(mirrors_array,localconfig)
		end
	end
end

