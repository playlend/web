require 'socket' 
require 'uri'


host = "localhost"
port = 2000


server = TCPServer.new(host, port)

loop do

  client = server.accept

  # Read the first line of the request (the Request-Line)
  request = client.gets

  puts request

  page_url = request.split(" ")[1]
  page_url = page_url[1..page_url.length-1]


  if File.exist?(page_url)
    File.open(page_url) do |page|
      client.print("HTTP/1.0 200 OK\r\n" +
                     "Date: #{Time.now.ctime}\r\n" +
                     "Content-Type: text-html\r\n" +
                     "Content-Length: #{page.size}\r\n")
      client.print("\r\n")
      IO.copy_stream(page, client)
    end
  else
    response = "Page doesn't exist!\r\n"
    client.print("HTTP/1.0 404 Not Found\r\n" +
                     "Date: #{Time.now.ctime}\r\n" +
                     "Content-Type: text-html\r\n" +
                     "Content-Length: #{response.size}\r\n")
    client.print("\r\n")
    client.print(response)


  end

  client.close
end