require 'sinatra/base'
require './lib/face_find'
require 'pry'

class MJpegFaceServer < Sinatra::Application

  # Seems to be completely ignoring this.
  set :port, 5000
  set :server, :thin
  set :bind, '0.0.0.0'

  include FaceFind

  @@output_dir = 'output_images/'
  @@source_dir = 'source_images/'
  @@boundary = "||mjpeg||"
  @@distributed = false
  @@last_mtime = nil
  @@last_result = nil

  get '/' do
    headers \
        "Cache-Control" => "no-cache, private",
        "Pragma"        => "no-cache",
        "Content-type"  => "multipart/x-mixed-replace; boundary=#{@@boundary}"
    stream(:keep_open) do |out| 
      while true
        if(@@distributed)
          changed = distributed_task
        else
          changed = nondestributed_task
        end
        if(changed)
          puts changed + "\n"
          out << "Content-type image/jpeg\n\n"
          out << File.read(changed)
          out << "\n\n\--#{@@boundary}\n\n"
        end
        sleep(1.0/24.0)
      end
    end
  end

  post '/get_latest_file' do
    headers \
        "Cache-Control" => "no-cache, private",
        "Pragma"        => "no-cache",
        "Content-type"  => "image/jpeg"
        fname = latest_file(@@source_dir)
    contents = File.read(fname)
    File.delete fname
    contents
  end

  post '/write_result' do |result|
    show_faces(result)
  end

  def distributed_task
    fname = latest_file(@@output_dir)
    if( @@last_mtime==nil || File.mtime(fname)>@@last_mtime)
      @@last_mtime = File.mtime(fname)
      fname
    end
    false
  end


  def nondestributed_task
    fname = latest_file(@@source_dir) 
    if(@@last_result==nil || JSON.parse(@@last_result)["digest"] != Digest::SHA256.file(@@source_dir+fname))
      @@last_result = find_faces( File.basename( fname ) )
      return show_faces(@@last_result)
    end
    false
  end

  def latest_file(dir)
    files = Dir.entries(dir).collect { |file| file }.sort { |file2,file1| File.mtime(dir+file1) <=> File.mtime(dir+file2) } 
    files -= ['.', '..']
    files[1] if files.count > 0
  end

  run!
end
