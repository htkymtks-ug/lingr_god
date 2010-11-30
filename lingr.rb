post '/' do
  "Hello Lingr!"
  parser = Yajl::Parser.new
  pp parser.parse(params[:json])
end
