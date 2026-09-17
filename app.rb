#!/usr/bin/env ruby
# frozen_string_literal: true

require 'json'
require 'securerandom'
require 'sinatra'
require 'rack/utils'

enable :method_override

MEMOS_FILE = File.join(__dir__, 'data', 'memos.json')

helpers do
  def h(value)
    Rack::Utils.escape_html(value)
  end
end

def load_memos
  return {} unless File.exist?(MEMOS_FILE)

  JSON.parse(File.read(MEMOS_FILE), symbolize_names: true)
end

def save_memos(memos)
  File.write(MEMOS_FILE, JSON.pretty_generate(memos))
end

def memo_params
  {
    title: params['title'].to_s,
    description: params['description'].to_s
  }
end

get '/' do
  redirect '/memos'
end

get '/memos' do
  @memos = load_memos
  erb :index
end

get '/memos/new' do
  erb :new
end

get '/memos/:id/edit' do
  @id = params['id']
  memos = load_memos
  @memo = memos[@id.to_sym]
  halt 404 if @memo.nil?

  erb :edit
end

get '/memos/:id' do
  @id = params['id']
  memos = load_memos
  @memo = memos[@id.to_sym]
  halt 404 if @memo.nil?

  erb :show
end

not_found do
  erb :not_found
end

post '/memos' do
  id = SecureRandom.uuid
  memos = load_memos
  memos[id.to_sym] = memo_params
  save_memos(memos)

  redirect "/memos/#{id}"
end

patch '/memos/:id' do
  id = params['id'].to_sym
  memos = load_memos
  halt 404 if memos[id].nil?
  memos[id] = memo_params
  save_memos(memos)

  redirect "/memos/#{id}"
end

delete '/memos/:id' do
  id = params['id'].to_sym
  memos = load_memos
  halt 404 if memos[id].nil?
  memos.delete(id)
  save_memos(memos)

  redirect '/memos'
end
