post '/' do
  parser = Yajl::Parser.new
  hash = parser.parse(params[:json])
  hash["events"].map do |event|
    if event["message"]["text"] =~ /^!ruby (.+)$/
      eval $1
    else
      nil
    end
  end.join("\n")
end
