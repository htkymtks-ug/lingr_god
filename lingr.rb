post '/' do
  parser = Yajl::Parser.new
  parser.parse(params[:json]).tapp.inspect
end
