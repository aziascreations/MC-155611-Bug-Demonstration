import random
import socket
import time

BROADCAST_IP = "224.0.2.60"
BROADCAST_PORT = 4445
BROADCAST_TEMPLATE = "[MOTD]E6oj4On1If5BMw5VC840E1XjitgzDWoHdagV1GFEH8mQvCqgrcPnJJnwjDFfIA8wOuIxzVt3KZjPFCzO8Z1h9rIjVQ5pbKWQaSbbVzClBaxAf2TJgXJLVMTn77UDPa2PHPMGt3ZwFtUM4kbQtZZzRnmoBoedAsi9HhQnM0RZKqg1usRGRUwhZOpPumiGZptrEKT2MI1reRDGbGGZP5NrMchOWqIAnlfyjB7ycMbfaS7nLdZZCN8sN3eKmG8AhLMZXrocUZPMInTWGGVM7gpTf6SVW8MHSa1FwtZLDI0wuNSaTel6o0FWykol6Y04p445RDRbgeYQ4QNR08iTb1bRyoAly8A5KFP73lOcvIjtYNQquXM5satuCxSbUaUBakqvIDQk5czla8c87az6gx1rsABECWIGlDBs6J8h7jQfMLImFryGPugJmTKAnkjJXYvRQr7AKZjNiizrsKBD4HL4ZGkTn5pXf4cPJNTJcBDQxNXKtqJwCqO7HaoEu1M1Km3kiIBcgpoJhxdWXYp8CMi9BrwfrsBSUDIoixlxNb4uTpTRdLmTbTLG8bkMRD3WRnoZ9unm9kSXNqd7Ny8lAtLMhiITOlHTYiE2qCalIJdy5ovmeShO5HjlrTXl3hd0a56tEmyf28Z3KjMJqVISjrW3HYcVmQDEtpTlq91wshhXcuCfOVudQLUtFThJ0lcIgDyqTHumwxqPDeuN1ePT4aE15cOaeSL3kIMRIuHJuinpP6bqEbn3JVsC8aeZbbScgbEYG213HXuu9PnZIMAArPkYAkswdg9o3is4tdcDI6qIYNsMwIL0LUXLf6RI9nuiJuE9x4IqRhMgNkcVlv4R6MzX0W9UJzdKEyW4tYgoWKEWKG7ywWTbcqatJYBGsnbLqnpiqSr7r4A5QiagK1sxCaq3YeYkJRWv8nDgRkVAVXlDqmGb9aopT0axJgS3BLgTXTRaqbawdklMT0DrccgDYNAph6bdPBcUmeYO[/MOTD][AD]%d[/AD]"

sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
sock.setsockopt(socket.SOL_SOCKET, socket.SO_BROADCAST, 1)

while 1:
	msg = BROADCAST_TEMPLATE % (random.randint(1000000000,10000000000))
	sock.sendto(msg, (BROADCAST_IP, BROADCAST_PORT))
	time.sleep(0.01)
