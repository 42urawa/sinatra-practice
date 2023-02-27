# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/content_for'
require 'rack/utils'
require 'json'

def read_memos_file
  json_memos_data = File.read('db/data.json')
  JSON.parse(json_memos_data)
end

def write_memos_file(memos)
  memos['memos'] << params
  File.write('db/data.json', JSON.generate(memos))
end

get '/' do
  @memos = read_memos_file['memos']
  erb :index
end

get '/new' do
  erb :new
end

post '/new' do
  hash_memos = read_memos_file
  write_memos_file(hash_memos)
  redirect '/'
  erb :index
end

get '/memos/:id' do
  memos = read_memos_file['memos']
  @memo = memos[params[:id].to_i]
  @id = params[:id]
  erb :show
end

get '/memos/:id/edit' do
  memos = read_memos_file['memos']
  @memo = memos[params[:id].to_i]
  @id = params[:id]
  erb :edit
end

patch '/memos/:id' do
  hash_memos = read_memos_file

  hash_memos['memos'][params[:id].to_i]['title'] = params[:title]
  hash_memos['memos'][params[:id].to_i]['content'] = params[:content]
  File.write('db/data.json', JSON.generate(hash_memos))

  redirect "/memos/#{params[:id]}"
  erb :show
end

delete '/memos/:id' do
  hash_memos = read_memos_file
  hash_memos['memos'].delete_at(params[:id].to_i)
  File.write('db/data.json', JSON.generate(hash_memos))
  redirect '/'
  erb :index
end

not_found do
  status 404
  erb :not_found
end
