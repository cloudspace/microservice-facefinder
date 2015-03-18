require 'ropencv'
require 'net/http'

uri = URI('http://212.42.54.136:8008/mjpg/video.mjpg')

Net::HTTP.start(uri.host, uri.port) do |http|
  request = Net::HTTP::Get.new uri.request_uri
  fullchunk = ''.force_encoding('BINARY')
  frame_divider = "\xff\xd8".force_encoding('BINARY')

  http.request request do |response|
    response.read_body do |chunk|
      fullchunk+=chunk.force_encoding('BINARY')
      a = fullchunk.index(frame_divider)
      b = fullchunk.index(frame_divider, a+1) if a
      i = 0
      if a && b
        jpg = fullchunk[a..(b+2)]
        fullchunk = fullchunk[b..(fullchunk.length-1)]
        i++
          i=i%10
        File.open("test#{i}.jpg", 'wb') { |file| file.write(jpg) }
        #exit
        #i = Cv.imdecode(jpg, Cv::IMREAD_COLOR)
      end
    end
  end
end

