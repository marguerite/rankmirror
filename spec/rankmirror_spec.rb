require 'spec_helper'
require 'ostruct'

describe RankMirror do
  it 'has a version number' do
    expect(RankMirror::VERSION).not_to be nil
  end

  it 'can reach bing.com' do
    expect(RankMirror::Reachable.new('http://bing.com', 5000).reachable?).to eq(true)
  end

  it "can't reach download.opensuse.or.id due to timeout" do
    expect(RankMirror::Reachable.new('http://download.opensuse.or.id', 500).reachable?).to eq(false)
  end

  it 'can get speed from Aliyun' do
    expect(RankMirror::Speed.new('http://mirrors.aliyun.com/opensuse/tumbleweed/repo/oss/suse/repodata/repomd.xml').get).not_to be nil
  end

  it 'can initialize options' do
    expect(RankMirror::Options.new.os).to eq('opensuse')
  end

  it 'can set option' do
    expect(RankMirror::Options.new.os = 'packman').to eq('packman')
  end

  it 'can fetch mirrorlist from mirrors.opensuse.org' do
    options = OpenStruct.new
    options.continent = 'asia'
    options.flavor = 'tumbleweed'
    expect(RankMirror::RemoteOSS.new(options).fetch.size).not_to eq(0)
  end

  it 'can fetch mirrorlist from packman.links2linux.de' do
    expect(RankMirror::RemotePackman.new.fetch.size).not_to eq(0)
  end

  it 'can get mirror status of Aliyun' do
    expect(RankMirror::Status.new('http://mirrors.aliyun.com/opensuse', 'opensuse').get).not_to be nil
  end

  it 'can detect if local config exists and is within 2 weeks' do
    expect(RankMirror::Cache.new('http://bing.com').is_recent?).not_to eq(true)
  end

  it 'can write valid local config' do
    file = RankMirror::Cache.new('http://bing.com').fetch
    expect(File.exist?(file) && File.size(file).zero?).to eq(false)
  end
end
