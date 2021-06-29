# receiver
require 'socket'
SIZE = 1024 * 1024 * 10
server = TCPServer.new("0.0.0.0", 3333)

loop do
  puts "Waiting Client..."
  # Accepts the client connection
  client = server.accept 
  puts "Client Connected!"
  # Reads the input sent by the client
  #client_input_str = client.gets
  client_input = client.gets.gsub("\"", "").gsub(",", "").gsub("[", "").gsub("]","").split
  

  loop do
    client_header = client.gets.strip
    puts client_header
    break if client_header.empty?
  end

  
  client_verb = client_input[0]
  client_path = client_input[1]
  client_protocol = client_input[2]
  

  puts client_path
  # If client input ends with /
  #HarryPotter/1.0
  #HTTP/1.1
  if client_verb == "GET" && client_protocol == "HarryPotter/1.0"
    
    if client_path.match(/\/$/)
      client.puts client_protocol + " " + "200 OK" + "\n"
      puts "MATCH"
      # Returns directory list to the client
      client.puts Dir["arq/*"].join("\n").gsub("arq/", "")
      #client.close
    else

      
      # If file exists, returns it to the client
      if File.exists?("arq#{client_path}")
        client.puts client_protocol + " " + "200 OK" + "\n"
        File.open("arq#{client_path}", 'rb') do |file|
          while chunk = file.read(SIZE)
            client.write(chunk)
          end
          puts "File sent"
          file.close
          
        end
      else
        client.puts client_protocol + " " + "404 Not Found" + "\n"
      end
    end
    
    client.close
  else
    client.puts client_protocol + " " + "404 Not Found" + "\n"
    client.close
  end
end