class PTLogFormatter < Logger::Formatter
  def call(severity, time, progname, msg)
    %Q | {time: "#{datetime}\n", severity: "#{severity}\n", message: "#{msg} from #{progname}"}\n |
  end
end