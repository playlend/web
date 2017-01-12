require 'socket'
require 'json'
 
host = 'localhost'     # The web server
port = 2000                          # Default HTTP port
path = "/index.html"                 # The file we want 

print "Enter 1 for GET request, enter 2 for POST request: "
answer = gets.chomp
answer = answer.to_i
# This is the HTTP request we send to fetch a file
if answer == 1
	request = "GET #{path} HTTP/1.0\r\n\r\n"
elsif answer == 2
	data = Hash.new()
	print "Please, enter your name: "
	data["name"] = gets.chomp
	print "Please, enter your email: "
	data["email"] = gets.chomp
	request = data.to_json
end	




socket = TCPSocket.open(host,port)  # Connect to server
socket.print(request)               # Send request
response = socket.read              # Read complete response
# Split response at first blank line into headers and body
headers,body = response.split("\r\n\r\n", 2) 
print body                          # And display it