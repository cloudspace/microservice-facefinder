require 'ropencv'
require 'net/http'
require 'tempfile'
require 'pry'

include OpenCV

#depends on openCV installation so copied into the directory for easier access
#face_cascade_name = File.join(Dir.getwd,'data',"haarcascade_frontalface_alt.xml")
face_cascade_name = '/usr/share/opencv/haarcascades/haarcascade_frontalface_alt.xml'

## unpack file
if !File.exist?(face_cascade_name)
  Zlib::GzipReader.open("#{face_cascade_name}.gz") do |gz|
    f = File.open(face_cascade_name,"w")
    f.write gz.read
    f.close
  end
end

data = Net::HTTP.get(URI(ARGV[0]))

file = Tempfile.new('face')
file.write(data)
file.close

frame_gray =  cv::Mat.new
face_cascade = cv::CascadeClassifier.new
puts face_cascade.load(face_cascade_name) ? ' loaded' : 'not loaded'

frame = cv::imread(file.path)
faces = Std::Vector.new(cv::Rect)

cv::cvt_color(frame,frame_gray, cv::COLOR_BGR2GRAY)
cv::equalizeHist( frame_gray, frame_gray );

face_cascade.detect_multi_scale( frame_gray, faces, 1.1, 2, );

faces.each do |face|
  puts "{ #{ face.x }, #{ face.y }, #{ face.width }, #{ face.height } }"
  center = cv::Point.new(face.x + face.width*0.5, face.y + face.height*0.5)

  cv::ellipse( frame, center, cv::Size.new( face.width*0.5, face.height*0.5), 0, 0, 360, cv::Scalar.new( 255, 0, 255 ), 4, 8, 0 );
end
cv::imwrite("happy-people-found.jpg", frame)
#cv::imshow("key_points",frame)
#cv::wait_key(-1)
