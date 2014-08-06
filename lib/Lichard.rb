class Lichard

  def self.inherited(subclass)
    @@router = Router.new()
  end

  def router
    @@router
  end

  def self.method_missing(method, *args, &block)
    if [:get, :post, :put, :delete, :put, :patch].include? method
      @@router.define_route(method, args[0], &block)
    else
      super
    end
  end

end

class Lichard::Router
  def initialize
    @routes = {}
  end
  def define_route(verb, path, &block)
    @routes[verb] = @routes[verb] || []
    @routes[verb] << Route.new(path, &block)
  end
  def process(verb, path)
    @routes[verb].each do |route|
      if response = route.process(path)
        return response
      end
    end
  end
end

class Lichard::Router::Route
  def initialize(path, &block)
    @path = path
    @params_keys = @path.scan(/:(\w+)/).flatten.map(&:to_sym)
    @regex = Regexp.new(@path.gsub(/:[a-z\d$]+/, '([a-z\d]+)'))
    @nblock = Proc.new(&block)
  end
  def process(path)
    scan = path.scan(@regex)
    if scan.length > 0
      @params = Hash[@params_keys.zip(path.scan(@regex).flatten)]
      instance_eval &@nblock
    else
      false
    end
  end
  def params
    @params
  end
end
