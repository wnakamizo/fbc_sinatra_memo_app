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
  File.write(MEMOS_FILE, "#{JSON.pretty_generate(memos)}\n")
end

def memo_key(id)
  id.to_sym
end

def find_memo(id)
  load_memos[memo_key(id)]
end

def find_memo_from(memos, id)
  memos[memo_key(id)]
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
  @memo = {}
  @errors = []
  erb :new
end

get '/memos/:id/edit' do
  @id = params['id']
  @memo = find_memo(@id)
  if @memo.nil?
    status 404
    return erb :not_found
  end
  @errors = []
  erb :edit
end

get '/memos/:id' do
  @id = params['id']
  @memo = find_memo(@id)
  if @memo.nil?
    status 404
    return erb :not_found
  end
  erb :show
end

not_found do
  erb :not_found
end

post '/memos' do
  @memo = memo_params
  @errors = []

  if @memo[:title].strip.empty?
    @errors << 'タイトルを入力してください'
    status 422
    return erb :new
  end

  memos = load_memos
  id = SecureRandom.uuid
  memos[memo_key(id)] = @memo
  save_memos(memos)

  redirect "/memos/#{id}"
end

patch '/memos/:id' do
  @id = params['id']
  memos = load_memos
  memo = find_memo_from(memos, @id)
  if memo.nil?
    status 404
    return erb :not_found
  end
  @memo = memo_params
  @errors = []
  if @memo[:title].strip.empty?
    @errors << 'タイトルを入力してください'
    status 422
    return erb :edit
  end
  memos[memo_key(@id)] = @memo
  save_memos(memos)

  redirect "/memos/#{@id}"
end

delete '/memos/:id' do
  memos = load_memos
  id = params['id']
  memo = find_memo_from(memos, id)
  if memo.nil?
    status 404
    return erb :not_found
  end
  memos.delete(memo_key(id))
  save_memos(memos)

  redirect '/memos'
end
