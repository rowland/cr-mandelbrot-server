require "http/server"
require "cr-mandelbrot"

module Mandelbrot::Server
  VERSION = "0.1.0"

  extend self

  def run
    server = HTTP::Server.new do |context|
      params = context.request.query_params
      w = params.fetch("w", 800).to_i
      h = params.fetch("h", 800).to_i
      cx = params.fetch("x", 0.0).to_f
      cy = params.fetch("y", 0.0).to_f
      mag = params.fetch("mag", 1.0).to_f
      limit = params.fetch("limit", 1000).to_i

      context.response.content_type = "image/png"

      canvas = Mandelbrot.draw_png(w, h, cx, cy, mag, limit)
      io = IO::Memory.new
      StumpyPNG.write(canvas, io)
      context.response << io
    end

    address = server.bind_tcp 8080
    puts "Listening on http://#{address}"
    server.listen
  end
end

Mandelbrot::Server.run
