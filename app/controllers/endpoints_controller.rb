require 'tidy'
require 'oauth/request_proxy/typhoeus_request'

class EndpointsController < ApplicationController
  def show
    @groups = Group.includes(:endpoints).order("name")
    redirect_to(setup_path, :alert => 'No groups yet.') and return if @groups.first.nil?
    
    @endpoint = params[:id].blank? ? @groups.first.endpoints.first : Endpoint.find(params[:id])
    redirect_to(setup_path, :alert => 'Invalid Endpoint.') and return if @endpoint.nil?
    
    @authentications = Authentication.all
    @auth_default = Authentication.find_by_auth_default(true)
    @global_standard_params = GlobalParameter.where(:p_type => Parameter::TYPES[:parameter])
    @global_header_params = GlobalParameter.where(:p_type => Parameter::TYPES[:header])
    @global_url_params = GlobalParameter.where(:p_type => Parameter::TYPES[:url])
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
      #redirect_to @endpoint, :notice => "Endpoint updated"
      redirect_to groups_path, :notice => "Endpoint updated"
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
    # ActiveRecord objects
    authentication = Authentication.find(params[:authentication_id])
    endpoint = Endpoint.find(params[:endpoint_id])
    parameter_set = ParameterSet.find(params[:parameter_set_id])
    
    # Relevant parameters
    url = endpoint.url
    method = parameter_set.http_method
    auth = authentication.auth_method
    
    # arbitrary url params
    add_url_params_from_arrays(url, params["url-param-keys"], params["url-param-vals"])
    
    if auth == 'basic'

      curl = curl_client(url, method, params)

      sent_headers = []
      curl.on_debug do |type, data|
        # track request headers
        sent_headers << data if type == Curl::CURLINFO_HEADER_OUT
      end

      # update auth
      add_basic_auth(curl, authentication.username, authentication.password)

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
      
    elsif auth == 'oauth'
      # Build OAuth Consumer
      consumer = OAuth::Consumer.new(authentication.consumer_key, authentication.consumer_secret)
      
      # Build AccessToken
      access_token = OAuth::AccessToken.new(consumer, authentication.oauth_token, authentication.oauth_token_secret)
      
      # Convert param/header arrays into hashes
      params_hash = params_to_hash(params["param-keys"], params["param-vals"])
      headers_hash = headers_to_hash(params["header-keys"], params["header-vals"])
      
      # Hack to get around OAuth and Typhoeus not playing nicely with HTTP POST requests
      #  When the request method is POST, not sure what Typhoeus is doing with :params
      #  exactly but they don't seem to be handled correctly with regards to OAuth. The
      #  signature is invalid with POST but not GET requests. To solve this, I am moving
      #  the POST parameters to the URL query string (which is an option according
      #  to the OAuth 1.0a spec).

      # Build request w/ Typhoeus      
      oauth_params = { :consumer => consumer, :token => access_token, :request_uri => url }
      
      if method == 'POST'
        # Forcing params onto URL
        p = to_params(Array(params["param-keys"]), Array(params["param-vals"]))
        url = "#{url}?#{URI.encode(p)}"
        
        req = Typhoeus::Request.new(url, { :method => method.downcase.to_sym,
                                           :headers => headers_hash })
      else
        # GET/PUT/DELETE - Typhoeus will take care of params
        req = Typhoeus::Request.new(url, { :method => method.downcase.to_sym,
                                           :headers => headers_hash,
                                           :params => params_hash })
      end
              
      oauth_helper = OAuth::Client::Helper.new(req, oauth_params)
      
      req.headers.merge!({"Authorization" => oauth_helper.header}) # Signs the request
      
      hydra = Typhoeus::Hydra.new
      hydra.queue(req)
      hydra.run
      
      response = req.response

      # p req.inspect
      # p '* * * * * * * * *'
      # p response.inspect

      header  = pretty_print_headers(response.headers)
      body    = pretty_print(response.headers_hash[:content_type], response.body)
      request = pretty_print_headers_from_hash(req.headers, req.params.nil? ? {} : req.params)
      #request = pretty_print_requests(req.headers, [])

      render :json => json(:header    => header,
                           :body      => body,
                           :request   => request)
    end
  end
  
  private
  
  # build curl client based on http method
  def curl_client(url, method, params)
    if method == 'GET' && !Array(params["param-keys"]).empty?
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
  
  # update auth
  def add_basic_auth(curl, username, password)
    encoded = Base64.encode64("#{username}:#{password}").gsub("\n",'')
    curl.headers['Authorization'] = "Basic #{encoded}"
  end
  
  # url parameters from non-empty keys and values
  def add_url_params_from_arrays(url, keys, values)
    keys, values = Array(keys), Array(values)

    keys.each_with_index do |key, i|
      next if values[i].to_s.empty?
      
      # magic goes here
      url_param = ":#{key.to_s}"
      url.gsub!(/#{url_param}/, values[i].to_s)
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
  # def add_headers_from_arrays(curl, keys, values)
  #   keys, values = Array(keys), Array(values)
  # 
  #   keys.each_with_index do |key, i|
  #     next if values[i].to_s.empty?
  #     curl.headers[key] = values[i]
  #   end
  # end

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
  
  # todo
  def params_to_hash(keys, values)
    keys, values = Array(keys), Array(values)

    params_hash = {}
    keys.each_with_index do |key, i|
      next if values[i].to_s.empty?
      params_hash[key] = values[i]
    end
    
    params_hash
  end
  
  # todo2
  def headers_to_hash(keys, values)
    keys, values = Array(keys), Array(values)

    headers_hash = {}
    keys.each_with_index do |key, i|
      next if values[i].to_s.empty?
      headers_hash[key] = values[i]
    end
    
    headers_hash
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
    colorize :js => shell("python -msimplejson.tool", :stdin => content)
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
  
  def pretty_print_headers_from_hash(headers, params)
    lines = ''
    headers.each do |key, value|
      lines << "<span class='nt'>#{key}</span>: <span class='s'>#{value}</span><br />"
    end

    "<div class='highlight'><pre>#{lines}</pre></div>" << "<span style='font-family: courier; font-size: 13px;'>#{params.to_query}</span>"
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
