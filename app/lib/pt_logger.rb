class PTLogFormatter < Logger::Formatter
  def call(severity, time, programName, message)
    "#{time}, #{severity}: #{message} from #{programName}\n"
  end
end