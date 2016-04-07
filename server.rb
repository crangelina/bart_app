require 'rest-client'
require 'sinatra'
require 'json'
require 'nokogiri'

require_relative "stations"

API_KEY = "MW9S-E7SL-26DU-VV8V"

get '/' do 
  @stations = STATIONS
  erb :index
end

post '/search' do 
  @stations = STATIONS
  # set @origin and @destination
  @originAbbr = params[:origin]
  @destAbbr = params[:destination]
  @stations.each do |key, value|
    if key == params[:origin]
      @originName = value
    end
    if key == params[:destination]
      @destName = value
    end
    @originName && @destName
  end

  response = RestClient.get "http://api.bart.gov/api/sched.aspx?cmd=depart&orig=#{@originAbbr}&dest=#{@destAbbr}&key=#{API_KEY}"

  @bart = Nokogiri::XML(response)
  erb :index
end

