require 'json'

module Serverspec::Type
  class Zabbixapi < Base
    def initialize(host, user, pass, method, params)
      @name   = 'zabbixapi'
      @host   = host
      @user   = user
      @pass   = pass
      @method = method
      @params = params
      @runner = Specinfra::Runner
      @curl_base = "curl -s http://#{host}/api_jsonrpc.php -H \"Content-Type: application/json-rpc\" -d"

      @response = query(@method, @params)
    end

    def result
      @response['result']
    end

    private

    def token
      @token ||= retrieve_token
    end

    def retrieve_token
      data = {
        jsonrpc: '2.0',
        method: 'user.login',
        params: {
          user: @user,
          password: @pass
        },
        auth: nil,
        id: 0
      }.to_json
      do_request(data)['result']
    end

    def query(method, params)
      data = {
        jsonrpc: '2.0',
        method: method,
        params: params,
        auth: token,
        id: 0
      }.to_json
      do_request(data)
    end

    def do_request(data)
      command = "#{@curl_base} '#{data}'"
      result = @runner.run_command(command)
      JSON.parse(result.stdout.chomp)
    end
  end
  def zabbixapi(host, user, pass, method, params)
    Zabbixapi.new(host, user, pass, method, params)
  end
end
include Serverspec::Type
