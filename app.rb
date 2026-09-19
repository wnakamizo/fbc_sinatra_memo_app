#!/usr/bin/env ruby
# frozen_string_literal: true

require 'json'
require 'securerandom'
require 'sinatra'
require 'rack/utils'
require 'pg'

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
  @memos = MemoRepository.load_memos.entries
  erb :index
end

get '/memos/new' do
  erb :new
end

get '/memos/:id/edit' do
  @id = params['id']
  begin
    @memo = MemoRepository.find(@id).entries.first
  rescue PG::Error
    halt 404
  end
  halt 404 if @memo.nil?

  erb :edit
end

get '/memos/:id' do
  @id = params['id']
  begin
    @memo = MemoRepository.find(@id).entries.first
  rescue PG::Error
    halt 404
  end
  halt 404 if @memo.nil?

  erb :show
end

not_found do
  erb :not_found
end

post '/memos' do
  id = SecureRandom.uuid
  MemoRepository.create(id, memo_params)

  redirect "/memos/#{id}"
end

patch '/memos/:id' do
  id = params['id']
  begin
    edited = MemoRepository.edit(id, memo_params)
  rescue PG::Error
    halt 404
  end
  halt 404 unless edited

  redirect "/memos/#{id}"
end

delete '/memos/:id' do
  id = params['id']
  MemoRepository.delete(id)

  redirect '/memos'
end
