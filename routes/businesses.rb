include Math

class App < Sinatra::Base

  namespace '/api/v1' do

    get '/businesses' do
      businesses =  business_access.fetch_all
      running_list = params[:type] ? businesses.select{|k,_| k['type'] == params[:type]} : businesses

      if params[:latitude] && params[:longitude]
        running_list.each do |hsh|
          input_location = [params[:latitude].to_f, params[:longitude].to_f]
          business_location = [hsh['latitude'].to_f, hsh['longitude'].to_f]
          hsh.store('distance', distance(input_location, business_location))
        end
      end

      json running_list
    end

    get '/businesses/:id' do
      json business_access.fetch params[:id]
    end

    post '/businesses' do
      content_type :json
      status 201
      message = JSON.parse(request.body.read)
      if message.is_a? Array
        response_ids = []
        message.map do |msg|
          business_access.add(msg)
          response_ids << msg['id']
        end

        {ids: response_ids}.to_json
      else
        business_access.add(msg)
        {id: message['id']}.to_json
      end

    end

    delete '/businesses/:id' do
      content_type :json
      status 204
      business_access.delete(params[:id])
      body ''
    end

  end

  private

  def business_access
    @business_access ||= BusinessAccess.new(redis_client)
  end

  # distance [46.3625, 15.114444], [46.055556, 14.508333]
  def distance loc1, loc2
    rad_per_deg = Math::PI/180  # PI / 180
    rkm = 6371                  # Earth radius in kilometers
    rm = rkm * 1000             # Radius in meters

    dlat_rad = (loc2[0] - loc1[0]) * rad_per_deg  # Delta, converted to rad
    dlon_rad = (loc2[1] - loc1[1]) * rad_per_deg

    lat1_rad, lon1_rad = loc1.map {|i| i * rad_per_deg }
    lat2_rad, lon2_rad = loc2.map {|i| i * rad_per_deg }

    a = Math.sin(dlat_rad/2)**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * Math.sin(dlon_rad/2)**2
    c = 2 * Math::atan2(Math::sqrt(a), Math::sqrt(1-a))

    meters = rm * c # Delta in meters
    convert_meters_to_miles meters
  end

  def convert_meters_to_miles(m)
    return (m * 0.00062137).round(2)
  end

end
