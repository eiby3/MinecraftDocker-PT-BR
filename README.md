# Minecraft Docker PT-BR
Tutorial de como fazer um servidor de Minecraft utilizando DOCKER e o AZURE.

Configurações da VM do Azure:
  - Terraform (Abrir pasta do Terraform). 
  
##  Main.tf 
  ```terraform
  terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "suasubscriptionId"
}

resource "azurerm_virtual_machine" "main" {
  name                  = "primeira-vm"
  location              = azurerm_resource_group.grupo.location
  resource_group_name   = azurerm_resource_group.grupo.name
  network_interface_ids = [azurerm_network_interface.main.id]
  vm_size               = "Standard_DS1_v2"

  storage_image_reference {
    offer     = "UbuntuServer"
    publisher = "Canonical"
    sku       = "18_04-lts-gen2"
    version   = "latest"
  }
  storage_os_disk {
    name              = "meudisco1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "vm-azure"
    admin_username = "abe"
    admin_password = "Testando1234!"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}

resource "azurerm_resource_group" "grupo" {
  name     = "recursos"
  location = "brazilsouth"
}

  ```
>*Verifique a pasta do terraform para a configuração completa.*

>No arquivo Main.tf digite sua subscriptionId, na seção "provider".

Para se conectar no linux:<br>
  ssh nomeAdmin@ip
  
Dentro do linux, utilizaremos o docker, lá vai os comandos:<br>
  ```
  sudo apt update
  ``` 
  ```
  sudo apt install apt-transport-https ca-certificates curl software-properties-common
  ```
  ```
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  ```
  ```
  sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
  ```
  ```
  sudo apt update
  ```
  ```
  apt-cache policy docker-ce
  ```
  ```
  sudo apt install docker-ce
  ```
  ```
  sudo systemctl status docker
  ```
  
Agora com o DOCKER instalado, vamos para o minecraft-server:<br>
   ```
   sudo docker run -d -it -p 25565:25565 --name NomeDoContainer -v /data:/data -e "EULA=TRUE"  itzg/minecraft-server 
  ```
  
  -p (Porta:Porta, simplificando, a porta 25565 do container vai refletir na porta 25565 da VM do Azure.)<br><br>
  -it (Para ser um container iterativo)<br><br>
  --name (Nome do Container)<br><br>
  -v (Onde ficará as pastas de configuração do servidor, ela é importante para mudar o ONLINE-MODE e deixar o servidor para piratas! /data é o local que vai ser criado as pastas de world, server.properties e etc, caso queira outra pasta, apenas digite por exemplo "/home/abe/minecraftdata:/data", o ":/data" vai apontar que você deseja que a pasta data vai ser criada no local da sua escolha.))<br><br>
  -e (São configurações gerais do servidor, mais detalhes acesse o github oficial da imagem)<br><br>
  Por último, é o nome da imagem que o DOCKER irá utilizar para criação do container.<br><br>
  
  Confirmando o container:
  ```
  sudo docker ps -a 
  ```
  
Vamos modificar o server.properties para piratas poderem acessar também<br>
  ```
  cd /data/
  ``` 
  ```
  ls -a 
  ```
  ```
  nano server.properties
  ```
  ```
  Altere o online-mode para false.
  Ctrl + O
  Enter
  Ctrl + X
  ```
Reinicie o container para aplicar as configurações
  ```
  sudo docker restart NomeDoContainer
  ```
  ```
  sudo docker ps -a
  ```
  
Pronto! Para se conectar basta usar o ip publico da máquina virtual. <br>

*Lembrando, a versão do servidor, se não especificar, irá ser a mais recente.

<h1>Para mais configurações como VERSÃO E MODS, acesse: </h1>

https://hub.docker.com/r/itzg/minecraft-server

https://github.com/itzg/docker-minecraft-server/blob/master/README.md
