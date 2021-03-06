module RankMirror
  class Mirrors
    def initialize(mirrors)
      @mirrors = mirrors
    end

    def sort_by_speed(options)
      speed_matrix = {}
      size = @mirrors.length
      jobs = Queue.new
      @mirrors.each { |i| jobs.push i }

      workers = Array.new(size) do
        Thread.new do
          begin
            while x = jobs.pop(true)
              x << '/' unless x.index(/\/$/)
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
      sorted = {}
      speed_sorted.each { |v| sorted[speed_matrix.key(v)] = v }

      sorted
    end
  end
end
