# Rankmirror

RankMirror is a ruby implementation of `rankmirrors` in ArchLinux but for all modern Linux distributions.

## Installation

    $ gem install rankmirror

## Usage

    $ rankmirror --help

eg. `rankmirror -o opensuse --flavor tumbleweed --continent asia`, the fastest openSUSE Tumbleweed mirror in Asia.

`rankmirror -o fedora --flavor 25 --country cn`, the fastest Fedora 25 mirror in China.

`rankmirror -o epel --flavor 7 --country cn`, the fastest EPEL 7 mirror in China.

`rankmirror -o packman -s` will get you: the fastest Packman mirror from the World. And save that to a packman.mirrorlist in your `~/.rankmirror`.
Next time, just `rankmirror -l -o packman -s`, which is faster^2. Because most of the times, there're only a few mirrors that are fast to you.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

