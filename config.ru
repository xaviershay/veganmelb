class DefaultPage < Rack::File
  def call(env)
    path = env['PATH_INFO']

    if path =~ /\/$/ || !(path =~ /\..+$/)
      env['PATH_INFO'] = File.join(path, 'index.html')
    end

    super
  end
end
run DefaultPage.new("public")
