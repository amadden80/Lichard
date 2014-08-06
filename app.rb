
require_relative 'lib/Lichard'



class Application < Lichard

  get '/resources/:id' do
    puts 'get resources   ' + params[:id]
  end

  post '/resources/:id' do
    puts 'post resources   ' + params[:id]
  end

  patch '/resources/:id' do
    puts 'post resources   ' + params[:id]
  end

end






app = Application.new

app.router.process(:get, '/resources/3')
app.router.process(:post, '/resources/4')
app.router.process(:patch, '/resources/45')

