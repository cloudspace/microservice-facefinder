require 'ropencv'
require 'net/http'
require 'tempfile'
require 'json'
require './lib/face_find'

class FaceFinder 
  include FaceFind
end

data = Net::HTTP.get(URI(ARGV[0]))

file = Tempfile.new('face')
file.write(data)
file.close

ff = FaceFinder.new

ff.find_faces(ff.filename)
