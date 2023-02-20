# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/content_for'
require 'rack/utils'
require 'json'

get '/' do
  json_memos_data = File.read('db/data.json')
  @memos = JSON.parse(json_memos_data)['memos']
  erb :index
end

get '/new' do
  erb :new
end

post '/new' do
  title = Rack::Utils.escape_html(params[:title])
  content = Rack::Utils.escape_html(params[:content])
  json_memos_data = File.read('db/data.json')
  hash_memos_data = JSON.parse(json_memos_data)
  new_memo = { 'title' => title, 'content' => content }
  hash_memos_data['memos'] << new_memo
  File.write('db/data.json', JSON.generate(hash_memos_data))
  redirect '/'
  erb :index
end

get '/memos/:id' do
  id = Rack::Utils.escape_html(params[:id])
  json_memos_data = File.read('db/data.json')
  @memos = JSON.parse(json_memos_data)['memos']
  @memo = @memos[id.to_i]
  @id = id
  erb :show
end

get '/edit/:id' do
  id = Rack::Utils.escape_html(params[:id])
  json_memos_data = File.read('db/data.json')
  @memos = JSON.parse(json_memos_data)['memos']
  @memo = @memos[id.to_i]
  @id = id
  erb :edit
end

patch '/memos/:id' do
  id = Rack::Utils.escape_html(params[:id])
  title = Rack::Utils.escape_html(params[:title])
  content = Rack::Utils.escape_html(params[:content])
  json_memos_data = File.read('db/data.json')
  hash_memos_data = JSON.parse(json_memos_data)
  hash_memos_data['memos'][id.to_i]['title'] = title
  hash_memos_data['memos'][id.to_i]['content'] = content
  File.write('db/data.json', JSON.generate(hash_memos_data))
  redirect "/memos/#{id}"
  erb :show
end

delete '/memos/:id' do
  id = Rack::Utils.escape_html(params[:id])
  json_memos_data = File.read('db/data.json')
  hash_memos_data = JSON.parse(json_memos_data)
  hash_memos_data['memos'].delete_at(id.to_i)
  File.write('db/data.json', JSON.generate(hash_memos_data))
  redirect '/'
  erb :index
end

not_found do
  status 404
  erb :not_found
end
