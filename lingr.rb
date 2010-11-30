post '/' do
  parser = Yajl::Parser.new
  hash = parser.parse(params[:json])
  hash["events"].map do |event|
    if event["message"]["text"] =~ /^!ruby (.+)$/
      begin
        eval $1
      rescue => e
        e.message
      end
    else
      nil
    end
  end.join("\n")
end
