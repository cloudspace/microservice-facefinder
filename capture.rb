require './lib/m_jpeg_chunker'

#uri = URI('http://212.42.54.136:8008/mjpg/video.mjpg')
uri = URI('http://10.0.1.35:8080/video')

chunker = MJpegChunker.new(uri, 3)
chunker.capture
