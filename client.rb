require 'socket'
SIZE = 1024 * 1024 * 10

server = TCPSocket.open('6.tcp.ngrok.io', 19128)
server_port = server.peeraddr[1]
server_addr = server.peeraddr[2]
puts "Connected to server: #{server_addr}, port: #{server_port}"

# Input treatment
input = ARGV
input_verb = ARGV[0]
input_path = ARGV[1]
input_protocol = "HarryPotter/1.0"
input.push input_protocol

input = input.join " "
# Sends input to the server with the protocol format
server.write "#{input}\n\n"

# Analyzes server status
server_response = server.gets.split

server_status = "#{server_response[1]}"
if server_status == "404"
  puts "404 Not Found"
  server.close
else
  puts "202 OK"
  ################ GET ################
  if input_path.match /\/$/ # Queries a directory to the server
    received = server.read
    puts received
  else # Queries a file to the server
    file_path = input_path
    puts "File requested => #{file_path}"
    File.open("./files/#{file_path}", 'wb') do |file|
      while chunk = server.read(SIZE)
        file.write(chunk)
      end
      file.close
    end
    # server.close
    puts "Download finished"
  end
  ################ GET ################
end