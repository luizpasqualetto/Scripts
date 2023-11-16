# Script created by: Luiz Pasqualetto
# 
# Carrega o módulo Active Directory para o Windows PowerShell
Import-Module ActiveDirectory

# Obtém o caminho para o diretório onde o script está localizado
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# Combina o diretório do script com o nome do arquivo
$filePath = Join-Path $scriptDir "users.txt"

# Verifica se o arquivo existe
if (Test-Path $filePath) {
    # Lê os IDs de usuário do arquivo
    $userIDs = Get-Content $filePath

    # Obtém a data atual para incluir no nome do arquivo de saída
    $currentDate = Get-Date -Format "yyyy_MM_dd"

    # Cria um caminho de pasta para o arquivo de saída (dentro da pasta "Logs")
    $logsFolder = Join-Path $scriptDir "Logs"
    $outputFilePath = Join-Path $logsFolder "UsuariosDesativados_$currentDate.txt"

    # Garante que a pasta "Logs" exista; cria se não existir
    if (-not (Test-Path $logsFolder)) {
        New-Item -ItemType Directory -Path $logsFolder
    }

    # Inicializa um array para armazenar os usuários desativados
    $deactivatedUsers = @()

    # Inicializa a barra de progresso
    $progressParams = @{
        Activity = "Processando Usuários"
        Status = "Inicializando"
        PercentComplete = 0
    }
    $progress = Write-Progress @progressParams

    foreach ($userID in $userIDs) {
        # Atualiza a barra de progresso
        $progressParams.PercentComplete = [math]::Min([math]::Max(0, $progressParams.PercentComplete + 100 / $userIDs.Count), 100)
        $progressParams.Status = "Processando $userID"
        Write-Progress @progressParams

        # Percorre os IDs de usuário e encontra os usuários
        $user = Get-ADUser -LDAPFilter "(telephoneNumber=$userID)" -Properties SamAccountName

        if ($user) {
            # Adiciona o nome de logon do usuário ao array de usuários desativados
            $deactivatedUsers += "Usuário desativado: $($user.SamAccountName)"

            # Move o usuário para a OU determinada pelo "SEU OU AQUI" dentro do AD "DC INICIO AQUI" AD "DC FINAL AQUI", por exemplo "OU=Usuarios,DC=empresa,DC=corp".
            Move-ADObject -Identity $user.DistinguishedName -TargetPath "OU="SEU OU AQUI",DC="DC INICIO AQUI",DC="DC FINAL AQUI"" -ErrorAction SilentlyContinue

            # Desativa o usuário (você pode modificar esta parte com base no seu processo de desativação)
            # Por exemplo, você pode desabilitar a conta
            Disable-ADAccount -Identity $user.SamAccountName
        }
    }

    # Fecha a barra de progresso
    Write-Progress -Activity "Processando Usuários" -Status "Completo" -Completed

    if ($deactivatedUsers.Count -gt 0) {
        # Salva os resultados no arquivo de saída
        $deactivatedUsers | Out-File -FilePath $outputFilePath
        Write-Host "Resultados escritos para o arquivo $outputFilePath"
    } else {
        Write-Host "Nenhum usuário com IDs encontrados. Arquivo de saída não criado."
    }

    # Aguarda a entrada do usuário
    Read-Host "Pressione Enter para sair..."
} else {
    Write-Host "Arquivo não encontrado: $filePath"
}
