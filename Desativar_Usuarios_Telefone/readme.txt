Função: Utilizando o campo de telefone do AD, procura se existe um usuario com um telefone correspondente aos telefones inseridos no arquivo "users.txt" criado dentro do diretorio ao lado do script.
Se existir um usuario com aquele telefone correspondente o usuario será desativado e movido para um grupo configurado no script.

Uso: Para utilizar o script, basta prencher os campos do OU e DC demarcados nos comentarios com a sua unidade organizacional, e seus componentes do dominio de acordo com o exemplo:
Se voce estiver usando um AD chamado empresa.corp, e contem 3 OUs (USUARIOS, DESATIVADOS e ACL) do qual voce queira utilizar o DESATIVADOS para armazenar os usuarios desativados a linha 54 do script ficara como: "OU=DESATIVADOS,DC=empresa,DC=corp"
