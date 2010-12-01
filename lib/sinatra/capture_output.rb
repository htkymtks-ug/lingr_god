require 'sinatra/base'
require 'tempfile'

module Sinatra
  module CaputureOutputHelper
    def capture_output(&block)
      fds = [STDOUT, STDERR]
      orig_fds = fds.map(&:dup)

      buf = Tempfile.new('output')

      begin
        fds.each do |fd|
          fd.reopen(buf)
        end

        begin
          block.call
          fds.each(&:flush)
          buf.tap(&:rewind).read
        ensure
          fds.zip(orig_fds).each do |fd, orig|
            fd.reopen(orig)
          end
        end
      ensure
        buf.close
      end
    end
  end

  helpers CaputureOutputHelper
end
