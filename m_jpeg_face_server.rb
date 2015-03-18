require 'sinatra'

class MJpegFaceServer < Sinatra::Base

  set :server, :thin

  output_dir = 'output_images'
  source_dir = 'input_images'

  boundary = "\xff\xd8||"

  get '/' do |dir|
    headers \
        "Cache-Control" => "no-cache, private",
        "Pragma"        => "no-cache",
        "Content-type"  => "multipart/x-mixed-replace; boundary=#{boundary}"

        stream(:keep_open) do |out| 
      while true
        sleep 1
        content = latest_file(output_dir)
        out << "Content-type image/jpeg\n\n"
        out << content
        out << "\n\n\--#{boundary}\n\n"
      end
        end
  end

  post '/get_latest_file' do
    headers \
        "Cache-Control" => "no-cache, private",
        "Pragma"        => "no-cache",
        "Content-type"  => "image/jpeg"
        fname = latest_file(source_dir)
    contents = File.read(fname)
    File.delete fname
    contents
  end

  post '/write_result' do
    binding.pry
  end

  def latest_file(dir)
    files = Dir.entries(dir).collect { |file| file }.sort { |file2,file1| File.mtime(dir+file1) <=> File.mtime(dir+file2) } 
    files -= ['.', '..']
    files[1] if files.count > 0
  end

end
