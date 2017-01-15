require 'socket' 
require 'uri'
require 'json'
require 'erb'


host = "localhost"
port = 2000


server = TCPServer.new(host, port)

loop do

  client = server.accept

  # Read the first line of the request (the Request-Line)
  request = client.gets
  puts request 
 
  if request.split(" ")[0] == "POST"
    params = Hash.new()
    params = JSON.parse(request.split(" ")[1])
    data = "<li>Name: #{params['person']['name']}</li><li>Email: #{params['person']['email']}</li>"
    File.open("thanks.html", "r") do |file|
      client.print("HTTP/1.0 200 OK\r\n" +
                       "Date: #{Time.now.ctime}\r\n" +
                       "Content-Type: text-html\r\n" +
                       "Content-Length: #{file.size}\r\n")
      client.print("\r\n")
    end
    temp = File.read("thanks.html")

    client.puts(temp.gsub('<%= yield %>',data))

  
  else 

    

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
  end
  client.close
end