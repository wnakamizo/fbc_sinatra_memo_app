#!/usr/bin/env ruby
# frozen_string_literal: true

require 'json'
require 'sinatra'
require 'rack/utils'

require_relative 'memo_repository'

enable :method_override

helpers do
  def h(value)
    Rack::Utils.escape_html(value)
  end
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
  @memos = MemoRepository.load_memos
  erb :index
end

get '/memos/new' do
  erb :new
end

get '/memos/:id/edit' do
  @memo = MemoRepository.find(params['id'].to_i)
  halt 404 unless @memo

  erb :edit
end

get '/memos/:id' do
  @memo = MemoRepository.find(params['id'].to_i)
  halt 404 unless @memo

  erb :show
end

not_found do
  erb :not_found
end

post '/memos' do
  id = MemoRepository.create(memo_params)

  redirect "/memos/#{id}"
end

patch '/memos/:id' do
  id = params['id'].to_i
  edited = MemoRepository.edit(id, memo_params)
  halt 404 unless edited

  redirect "/memos/#{id}"
end

delete '/memos/:id' do
  MemoRepository.delete(params['id'].to_i)

  redirect '/memos'
end
