# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/content_for'
require 'rack/utils'
require 'pg'

configure do
  conn = PG.connect(
    host: 'localhost',
    port: 5432,
    dbname: 'postgres',
    user: 'postgres',
    password: 'postgres'
  )
  set :conn, conn
end

get '/' do
  conn = settings.conn
  result = conn.exec('SELECT * FROM memos')
  @memos = result.to_a
  erb :index
end

get '/new' do
  erb :new
end

post '/new' do
  conn = settings.conn
  conn.exec_params('INSERT INTO memos (title, content) VALUES ($1, $2)', [params[:title], params[:content]])
  redirect '/'
end

get '/memos/:id' do
  conn = settings.conn
  result = conn.exec_params('SELECT * FROM memos WHERE id = $1', [params[:id].to_i])
  @memo = result.to_a[0]
  erb :show
end

get '/memos/:id/edit' do
  conn = settings.conn
  result = conn.exec_params('SELECT * FROM memos WHERE id = $1', [params[:id].to_i])
  @memo = result.to_a[0]
  erb :edit
end

patch '/memos/:id' do
  conn = settings.conn
  result = conn.exec_params(
    'UPDATE memos SET title = $1, content = $2 WHERE id = $3',
    [params[:title], params[:content], params[:id].to_i]
  )
  @memo = result.to_a[0]
  redirect "/memos/#{params[:id]}"
end

delete '/memos/:id' do
  conn = settings.conn
  conn.exec_params('DELETE FROM memos WHERE id = $1', [params[:id].to_i])
  redirect '/'
end

not_found do
  status 404
  erb :not_found
end
