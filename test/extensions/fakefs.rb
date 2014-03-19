module FakeFS
  class File < StringIO
    def ioctl(integer_cmd, arg)
      # do nothing
    end
  end
end
