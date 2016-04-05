require 'rubygems'
require 'sinatra'
require 'fileutils'
require 'securerandom'
require 'json'
require 'open-uri'
require 'net/http'

# Enabling session
use Rack::Session::Cookie,  :key => 'SESSION_ID',
                            :secret => '!@!00ASDFASDasdf123213'
# This for the root page							
get '/' do
  # Print out test message
  "Zikuan's Ruby id.me Test Application"
end

get '/user.id.me' do
  # send the file user.id.me as html
  send_file 'user.id.me', :type => 'text/html; charset=utf8'
end

get '/Veteran' do
  content_type :html
  "<h2> Welcome #{params[:email]}! We have idenfitied you are a Veteran.</h2>"
end


get '/Other' do
  content_type :html
  "<h2>  Welcome #{params[:email]}! We have identified you are a not Veteran.</h2>"
end

get '/id.me.callback' do
  # send the file id.me.callback as html
  send_file 'id.me.callback', :type => 'text/html; charset=utf8'
end

get '/id.me.callback2' do
  # save the access_token parameter in the URL into variable token
  token = params[:access_token]
  
  # use curl to get the payload from id.me
  ret =  %x[curl -H "Accept:application/json" https://api.id.me/api/public/v2/attributes.json?access_token=#{token}]
  
  # parse the string into a JSON object
  val = JSON.parse ret
  
  # assign status attribute as success
  val[:status] = "success";
  
  # put the payload into session variable "payload"
  session[:payload] = val
  # redirect user back to user.id.me page
  redirect "/user.id.me"
val.inspect
end

get '/session-ready' do
	content_type :json
	if session[:payload].nil? 
		{ :status => 'login' }.to_json
	else
		session[:payload].to_json
	end
end

