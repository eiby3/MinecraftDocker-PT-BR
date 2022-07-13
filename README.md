# Minecraft Docker PT-BR
Tutorial de como fazer um servidor de Minecraft utilizando DOCKER e o AZURE.

Configurações da VM do Azure:
  - Terraform (Abrir pasta do Terraform).  
  
Para se conectar no linux:<br>
  ssh nomeAdmin@ip
  
Dentro do linux, utilizaremos o docker, lá vai os comandos:<br>
  ```sudo apt update```<br>
  ```sudo apt install apt-transport-https ca-certificates curl software-properties-common```<br>
  ```curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -```<br>
  ```sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"```<br>
  ```sudo apt update```<br>
  ```apt-cache policy docker-ce```<br>
  ```sudo apt install docker-ce```<br>
  ```sudo systemctl status docker``` (Verificar o status, se está "Active")<br>
  
Agora com o DOCKER instalado, vamos para o minecraft-server:<br>
   ```sudo docker run -d -it -p 25565:25565 --name NomeDoContainer -v /data:/data -e "EULA=TRUE"  itzg/minecraft-server ```<br><br>
  
  -p (Porta:Porta, simplificando, a porta 25565 do container vai refletir na porta 25565 da VM do Azure.)<br><br>
  -it (Para ser um container iterativo)<br><br>
  --name (Nome do Container)<br><br>
  -v (Onde ficará as pastas de configuração do servidor, ela é importante para mudar o ONLINE-MODE e deixar o servidor para piratas! /data é o local que vai ser criado as pastas de world, server.properties e etc, caso queira outra pasta, apenas digite por exemplo "/home/abe/minecraftdata:/data", o ":/data" vai apontar que você deseja que a pasta data vai ser criada no local da sua escolha.))<br><br>
  -e (São configurações gerais do servidor, mais detalhes acesse o github oficial da imagem)<br><br>
  Por último, é o nome da imagem que o DOCKER irá utilizar para criação do container.<br><br>
  
  Confirmando o container:<br>
   ``` sudo docker ps -a ```<br>
    
Vamos modificar o server.properties para piratas poderem acessar também<br>
  ```cd /data/``` <br>
  ```ls -a ```<br>
  ```nano server.properties``` <br>
  ```
  Altere o online-mode para false.
  Ctrl + O
  Enter
  Ctrl + X
  ```
Reinicie o container para aplicar as configurações <br>
  sudo docker restart NomeDoContainer <br>
  sudo docker ps -a <br>
  
Pronto! Para se conectar basta usar o ip publico da máquina virtual. <br>

*Lembrando, a versão do servidor, se não especificar, irá ser a mais recente.

<h1>Para mais configurações como VERSÃO E MODS, acesse: </h1>

https://hub.docker.com/r/itzg/minecraft-server

https://github.com/itzg/docker-minecraft-server/blob/master/README.md
