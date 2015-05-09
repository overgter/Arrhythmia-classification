import bluetooth as bt
server_UUID = "00001101-0000-1000-8000-00805F9B34FA"
result = bt.find_service(uuid=server_UUID)
result = result[0]

host = result.get("host")
port = result.get("port")

print(host)
print(port)

sock = bt.BluetoothSocket(bt.RFCOMM)

try:
   sock.connect((host, port))
except Exception as e:
   print e
print("se conecto")

#f=open("200.txt", 'r')
#a=f.readline()
#b=a.split(',')

for c in range(1,10):
   sock.send(c)
   sock.send('\n')
   
