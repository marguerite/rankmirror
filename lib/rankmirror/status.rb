require 'ostruct'

module RankMirror
  class Status
    def initialize(uri, distro)
      uri << '/' unless uri =~ %r{^.*/$}
      @uri = uri
      @distro = distro
    end

    def get
      return unless RankMirror::Reachable.new(@uri, 500).reachable?
      case @distro
      when 'opensuse'
        tumbleweed = 'tumbleweed/repo/oss/suse/repodata/'
        leap4220 = 'distribution/leap/42.2/repo/oss/suse/repodata/'
        leap4210 = 'distribution/leap/42.1/repo/oss/suse/repodata/'
        leap4230 = 'distribution/leap/42.3/repo/oss/suse/repodata/'

        checklist = { 'tumbleweed' => tumbleweed, 'leap4220' => leap4220, 'leap4210' => leap4210, 'leap4230' => leap4230 }
        mirror = OpenStruct.new

        checklist.each do |k, v|
          mirror[k] = if RankMirror::Reachable.new(@uri + v, 500).reachable?
                        true
                      else
                        false
                      end
        end
        mirror
      when 'packman'
        tumbleweed = 'Tumbleweed'
        leap4220 = 'Leap_42.2'
        leap4210 = 'Leap_42.1'
        leap4230 = 'Leap_42.3'
        checklist = { 'tumbleweed' => tumbleweed, 'leap4220' => leap4220, 'leap4210' => leap4210, 'leap4230' => leap4230 }

        mirror = OpenStruct.new

        checklist.each do |k, v|
          if RankMirror::Reachable.new(@uri + 'openSUSE_' + v + '/Essentials/repodata/', 500).reachable?
            mirror[k] = true
          else
            mirror[k] = false
          end
        end
        mirror
      when 'fedora'
        mirror = OpenStruct.new
        check = %w(20 21 22 23 24 25)
        check.each do |k|
          if RankMirror::Reachable.new(@uri + 'releases/' + k + '/Everything/x86_64/os/repodata/repomd.xml', 500).reachable?
            mirror['fedora' + k] = true
          else
            mirror['fedora' + k] = false
          end
        end
        mirror
      when 'epel'
        mirror = OpenStruct.new
        check = %w(4 5 6 7)
        check.each do |k|
          if RankMirror::Reachable.new(@uri + '/' + k + '/x86_64/repodata/repomd.xml', 500).reachable?
            mirror['epel' + k] = true
          else
            mirror['epel' + k] = false
          end
        end
        mirror
      end
    end
  end
end
