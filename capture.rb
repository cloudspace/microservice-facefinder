require 'net/http'
require 'pry'
require 'fileutils'
#include OpenCV

uri = URI('http://212.42.54.136:8008/mjpg/video.mjpg')

output_dir = 'source_images' 
Net::HTTP.start(uri.host, uri.port) do |http|
  request = Net::HTTP::Get.new uri.request_uri
  fullchunk = ''.force_encoding('BINARY')
  frame_divider = "\xff\xd8".force_encoding('BINARY')
  i = 0

  http.request request do |response|
    response.read_body do |chunk|
      fullchunk+=chunk.force_encoding('BINARY')
      a = fullchunk.index(frame_divider)
      b = fullchunk.index(frame_divider, a+1) if a
      if a && b
        jpg = fullchunk[a..(b+2)]
        fullchunk = fullchunk[b..(fullchunk.length-1)]
        p = i
        i=i+1
        i=i%10
        File.open("#{output_dir}/input#{i}.jpg", 'wb') { |file| file.write(jpg) }
        if File.exists? "#{output_dir}/input#{p}.jpg"
          if FileUtils.compare_file("#{output_dir}/input#{p}.jpg", "#{output_dir}/input#{i}.jpg")
            File.delete( "#{output_dir}/input#{p}.jpg" )
            i=p
          end
        end
      end
    end
  end
end
