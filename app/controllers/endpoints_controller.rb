class EndpointsController < ApplicationController
  def show
    @groups = Group.order("name")
    redirect_to(setup_path, :alert => 'No groups yet.') and return if @groups.first.nil?
    
    @endpoint = params[:id].blank? ? @groups.first.endpoints.first : Endpoint.find(params[:id])
    redirect_to(setup_path, :alert => 'Invalid Endpoint.') and return if @endpoint.nil?
    
    @authentications = Authentication.all
    @auth_default = Authentication.find_by_auth_default(true)
    @global_params = GlobalParameter.all
  end

  def new
    @group = Group.find(params[:group_id])
    @endpoint = @group.endpoints.build
  end
  
  def create
    @group = Group.find(params[:group_id])
    @endpoint = @group.endpoints.build(params[:endpoint])
    
    if @endpoint.save
      #redirect_to @endpoint, :notice => "Endpoint created"
      redirect_to new_endpoint_parameter_set_path(@endpoint), :notice => "Endpoint created"
    else
      render :action => :new
    end
  end

  def edit
    @endpoint = Endpoint.find(params[:id])
  end

  def update
    @endpoint = Endpoint.find(params[:id])
    
    if @endpoint.update_attributes(params[:endpoint])
      redirect_to @endpoint, :notice => "Endpoint updated"
    else
      render :action => :edit
    end
  end
  
  def destroy
    @endpoint = Endpoint.find(params[:id])
    @endpoint.destroy
    redirect_to endpoints_path
  end
  
  # The following code is based on the hurl.it project (http://github.com/defunkt/hurl)
  #  by Chris Wanstrath and Leah Culver.
  
  def explore
    #render :json => json(:error => "Calm down and try my margarita!")
    
    url, method, auth = params.values_at(:url, :method, :auth)
    
    curl = curl_client(url, method, params)
    
    sent_headers = []
    curl.on_debug do |type, data|
      # track request headers
      sent_headers << data if type == Curl::CURLINFO_HEADER_OUT
    end
    
    # update auth
    add_auth(auth, curl, params)
    
    # arbitrary headers
    add_headers_from_arrays(curl, params["header-keys"], params["header-vals"])

    # arbitrary params
    fields = make_fields(method, params["param-keys"], params["param-vals"])
    
    begin
      curl.send("http_#{method.downcase}", *fields)

      header  = pretty_print_headers(curl.header_str)
      body    = pretty_print(curl.content_type, curl.body_str)
      request = pretty_print_requests(sent_headers, fields)

      render :json => json(:header    => header,
                           :body      => body,
                           :request   => request)
    rescue => e
      render :json => json(:error => e.to_s)
    end
  end
  
  private
  
  # build curl client based on http method
  def curl_client(url, method, params)
    if method == 'GET'
      params = to_params(Array(params["param-keys"]), Array(params["param-vals"]))
      Curl::Easy.new("#{url}?#{params}")
    else
      Curl::Easy.new(url)
    end
  end
  
  # build GET query string from params
  def to_params(keys, values)
    p = ''
    keys.each_with_index do |key, i|
      next if values[i].to_s.empty?
      p << "#{key}=#{values[i]}&"
    end
    p.chop
  end
  
  # update auth based on auth type
  def add_auth(auth, curl, params)
    if auth == 'basic'
      username, password = params.values_at(:username, :password)
      encoded = Base64.encode64("#{username}:#{password}").gsub("\n",'')
      curl.headers['Authorization'] = "Basic #{encoded}"
    end
  end

  # headers from non-empty keys and values
  def add_headers_from_arrays(curl, keys, values)
    keys, values = Array(keys), Array(values)

    keys.each_with_index do |key, i|
      next if values[i].to_s.empty?
      curl.headers[key] = values[i]
    end
  end
  
  # headers from non-empty keys and values
  def add_headers_from_arrays(curl, keys, values)
    keys, values = Array(keys), Array(values)

    keys.each_with_index do |key, i|
      next if values[i].to_s.empty?
      curl.headers[key] = values[i]
    end
  end

  # post params from non-empty keys and values
  def make_fields(method, keys, values)
    return [] unless method == 'POST'

    fields = []
    keys, values = Array(keys), Array(values)
    keys.each_with_index do |name, i|
      value = values[i]
      next if name.to_s.empty? || value.to_s.empty?
      fields << Curl::PostField.content(name, value)
    end
    fields
  end
  
  # render a json response
  def json(hash = {})
    #content_type 'application/json'
    Yajl::Encoder.encode(hash).to_json
  end
  
  # shell "cat", :stdin => "file.rb"
  def shell(cmd, options = {})
    ret = ''
    Open3.popen3(cmd) do |stdin, stdout, stderr|
      if options[:stdin]
        stdin.puts options[:stdin].to_s
        stdin.close
      end
      ret = stdout.read.strip
    end
    ret
  end
  
  def colorize(hash = {})
    Albino.colorize(hash.values.first, hash.keys.first)
  end
  
  def pretty_print(type, content)
    type = type.to_s

    if type =~ /json|javascript/
      pretty_print_json(content)
    elsif type.include? 'xml'
      pretty_print_xml(content)
    elsif type.include? 'html'
      colorize :html => content
    else
      content.inspect
    end
  end

  def pretty_print_json(content)
    #colorize :js => shell("python -msimplejson.tool", :stdin => content)
    
    jason = Yajl::Parser.parse(content)
    colorize :js => Yajl::Encoder.encode(jason, :pretty => true)
  end

  def pretty_print_xml(content)
    temp = Tempfile.new(['xmlcontent', '.xml'])
    temp.print content
    temp.flush
    colorize :xml => shell("xmllint --format #{temp.path}")
  ensure
    temp.close!
  end
  
  def pretty_print_headers(content)
    lines = content.split("\n").map do |line|
      if line =~ /^(.+?):(.+)$/
        "<span class='nt'>#{$1}</span>:<span class='s'>#{$2}</span>"
      else
        "<span class='nf'>#{line}</span>"
      end
    end

    "<div class='highlight'><pre>#{lines.join}</pre></div>"
  end

  # accepts an array of request headers and formats them
  def pretty_print_requests(requests = [], fields = [])
    headers = requests.map do |request|
      pretty_print_headers request
    end

    #headers.join + "<pre>#{CGI::unescape(fields.join('&'))}</pre>"
    headers.join + "<span style='font-family: courier; font-size: 13px;'>#{CGI::unescape(fields.join('&'))}</span>"
  end
end
