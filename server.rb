require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/namespace'
require 'dotenv'
require 'json'
require_relative './lib/docker_container'

Dotenv.load
set :show_exceptions, :after_handler

before do
  message = {
    status: 'HTTP 403: Access Denied.'
  }
  halt 403, message.to_json if  ENV['ALLOW_HOST'] != '0.0.0.0' && ENV['ALLOW_HOST'] != request.ip
end

error do
  message = {
    status: 'request error.'
  }
  return message.to_json
end

not_found do
  message = {
    status: 'not found.'
  }
  return message.to_json
end

namespace '/api/v1' do
  get '/whitelist' do
    File.open("./minecraft/whitelist.json") do |f|
      @whitelist_json = JSON.load(f)
    end
    return @whitelist_json.to_json
  end

  get '/ops' do
    File.open("./minecraft/ops.json") do |f|
      @ops_json = JSON.load(f)
    end
    return @ops_json.to_json
  end

  get '/status' do
    container_status = DockerContainer.get_status(__dir__)
    # container_status = DockerContainer.load_docker_compose_yml(__dir__)
    status = {
      minecraft_version: ENV['MINECRAFT_VERSION'],
      host: request.host,
      container_status: container_status
    }
    return status.to_json
  end
end
