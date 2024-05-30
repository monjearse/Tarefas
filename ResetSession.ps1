# Check if running scripts is disabled
$scriptExecutionPolicy = Get-ExecutionPolicy

if ($scriptExecutionPolicy -eq "Restricted") {
    Write-Host "Script execution is currently disabled."

    # Provide instructions to the user on changing the execution policy
    Write-Host "To run this script, you can set the execution policy to RemoteSigned."
    Write-Host "Run the following command in an elevated (Run as Administrator) PowerShell session:"
    Write-Host "Set-ExecutionPolicy RemoteSigned"
    Write-Host "Note: Changing the execution policy may have security implications."

    # Exit the script
    Exit
}

# Function to reset a session
function Reset-Session {
    param (
        [string]$sessionId
    )

    # Check if the entered session ID is numeric
    if ($sessionId -match '^\d+$') {
        # Reset the specified session
        logoff $sessionId
        Write-Host "Sessão $sessionId foi resetada."
    } else {
        Write-Host "ID de Sessão Inválido. Por favor, insira um ID de Sessão numérico."
    }
}

# Function to prompt user for language selection
function Prompt-LanguageSelection {
    $languageChoice = Read-Host "Escolha o idioma (Choose the language): PT (Português) or EN (English)"

    switch ($languageChoice.ToLower()) {
        'pt' { return 'pt' }
        'en' { return 'en' }
        default { return 'en' } # Default to English if an invalid choice is entered
    }
}

# Function to prompt user if they want to reset another session
function Prompt-ResetAnotherSession {
    $response = Read-Host "Deseja resetar outra sessão? (Y/N)"
    return $response.ToLower() -eq 'y'
}

# Prompt user for language selection
$selectedLanguage = Prompt-LanguageSelection

do {
    # Get the list of active sessions
    $sessions = query session | ConvertFrom-Csv

    # Display the list of sessions in a table format
    switch ($selectedLanguage) {
        'pt' { $sessions | Format-Table -AutoSize }
        'en' { $sessions | Format-Table -AutoSize }
    }

    # Prompt user to enter the session ID to reset
    $sessionId = Read-Host "Insira o ID da sessão para resetar"

    # Reset the specified session
    Reset-Session -sessionId $sessionId

} while (Prompt-ResetAnotherSession)

Write-Host "Obrigado por usar o script de reset de sessão. Tenha um ótimo dia! (Thank you for using the session reset script. Have a great day!)"
