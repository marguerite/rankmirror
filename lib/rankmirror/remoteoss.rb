require 'nokogiri'
require 'open-uri'
require 'ostruct'

module RankMirror
	class RemoteOSS
        
		def initialize(options)
			oss = Nokogiri::HTML(open("http://mirrors.opensuse.org"))
			@mirrors, continent = Array.new, String.new

			oss.xpath("//table/tbody/tr").each do |tr|
                    		# <tr>
                    		#   <td colspan="31" class="newregion">Africa:</td>
                    		# </tr>
                    		unless tr.xpath("td").attribute("class").nil?
                            		continent = tr.xpath("td").text.gsub(":","")
					case continent
					when "Africa"
						continent = "africa"
					when "Europe"
						continent = "euro"
					when "North America"
						continent = "na"
					when "South America"
						continent = "sa"
					when "Oceania"
						continent = "ocean"
					else
						continent = "asia"
					end
                    		else
                            		# 0 <td>Ecuador</td>
                            		# 1 <td><a href="http://www.cedia.org.ec">Consorcio Ecuatoriano para el Desarrollo de Internet Avanzado</a></td>
                            		# 2 <td><a href="http://mirror.cedia.org.ec/opensuse">HTTP</a></td>
                            		# 3 <td><a href="ftp://mirror.cedia.org.ec/opensuse/">FTP</a></td>
                            		# 4 <td><a href="rsync://mirror.cedia.org.ec/opensuse/">rsync</a></td>
                            		# 5 <td>***</td>
                            		# 6 <td class="a"></td>
                            		# 7 <td class="b"></td> TW
                            		# 8 <td class="a">√</td>
                            		# 9 <td class="b">√</td> 422
                            		# 10 <td class="a"></td>
                            		# 11 <td class="b"></td>
                            		# 12 <td class="a">√</td> 422 update 
                            		# 13 <td class="b">√</td>
                            		# 14 <td class="a">√</td> 421
                            		# 15 <td class="b"></td>
                            		# 16 <td class="a"></td>
                            		# 17 <td class="b">√</td> 421 update
                            		td0 = tr.at_xpath("td[1]").text
                            		if td0.length > 0 # ignore the placeholders
                                    		td1,td2,td3 = tr.at_xpath("td[2]/a").text,nil,nil
                                    		td2 = tr.at_xpath("td[3]/a/@href").value unless tr.at_xpath("td[3]/a").nil?
                                    		td3 = tr.at_xpath("td[4]/a/@href").value unless tr.at_xpath("td[4]/a").nil? 
                                    		td5 = tr.at_xpath("td[6]").text.length
                                    		td7 = tr.at_xpath("td[8]").text.length
                                    		td9 = tr.at_xpath("td[10]").text.length
                                    		td14 = tr.at_xpath("td[15]").text.length

						if options.continent == "world" || options.continent == continent
							mirror = OpenStruct.new
							mirror.continent = continent
							mirror.country = tr.at_xpath("td[1]").text.strip!
                                    			if td1.length != 0
								mirror.name = td1
                                    			else
								mirror.name = td2
                                    			end
							if td2.nil?
								mirror.http = td3
							else
								mirror.http = td2
							end
							mirror.ftp = td3
							mirror.priority = td5
                                    			if td7 == 0
								mirror.tumbleweed = false
							else
								mirror.tumbleweed = true
							end
							if td9 == 0
								mirror.leap4220 = false
							else
								mirror.leap4220 = true
							end
							if td14 == 0
                                    				mirror.leap4210 = false
							else
								mirror.leap4210 = true
							end

							if mirror.tumbleweed == false && mirror.leap4220 == false && mirror.leap4210 == false
								status = RankMirror::Status.new(mirror.http).get(options)
								["tumbleweed","leap4420","leap4210","leap4230"].each {|i| mirror[i] = status[i]} unless status.nil?
							end

							@mirrors << mirror
						end
                            		end
                    		end
            		end
			@mirrors = @mirrors.compact
        	end

		def sort(options)
			sorted = @mirrors.map!{|mirror| mirror.http if mirror[options.flavor]}.compact!
		end

    end
end

