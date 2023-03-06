# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/content_for'
require 'rack/utils'
require 'json'

def read_memos_file
  JSON.parse(File.read('db/data.json'))
end

def write_memos_file(memos)
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
  memos = read_memos_file
  memos['memos'] << params
  write_memos_file(memos)
  redirect '/'
  erb :index
end

get '/memos/:id' do
  @id = params[:id]
  @memo = read_memos_file['memos'][@id.to_i]
  erb :show
end

get '/memos/:id/edit' do
  @id = params[:id]
  @memo = read_memos_file['memos'][@id.to_i]
  erb :edit
end

patch '/memos/:id' do
  memos = read_memos_file
  memos['memos'][params[:id].to_i]['title'] = params[:title]
  memos['memos'][params[:id].to_i]['content'] = params[:content]
  write_memos_file(memos)
  redirect "/memos/#{params[:id]}"
  erb :show
end

delete '/memos/:id' do
  memos = read_memos_file
  memos['memos'].delete_at(params[:id].to_i)
  write_memos_file(memos)
  redirect '/'
  erb :index
end

not_found do
  status 404
  erb :not_found
end
