# Synchronise le coffre Obsidian avec GitHub, pour travailler à deux.
# Ordre : 1) on enregistre ses modifs localement, 2) on récupère celles du
# binôme, 3) on envoie le tout. Obsidian peut rester ouvert : il recharge
# tout seul les fichiers que git vient de changer.
param([switch]$NoPause)

$ErrorActionPreference = 'Continue'
Set-Location -LiteralPath $PSScriptRoot

# PowerShell 5.1 lit la sortie de git dans un autre encodage que l'UTF-8 :
# sans ça, les accents des noms de fichiers sont cassés dans l'historique.
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

function Fin($code) {
    Write-Host ""
    if (-not $NoPause) { Read-Host "Appuie sur Entrée pour fermer" | Out-Null }
    exit $code
}
function Ok($msg)     { Write-Host "  OK  $msg" -ForegroundColor Green }
function Info($msg)   { Write-Host "  ..  $msg" -ForegroundColor Cyan }
function Erreur($msg) { Write-Host "  !!  $msg" -ForegroundColor Red }

Write-Host ""
Write-Host "=== Synchronisation du coffre $(Split-Path -Leaf $PSScriptRoot) ===" -ForegroundColor White
Write-Host ""

# --- Vérifications de base ---------------------------------------------------
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Erreur "Git n'est pas installé. Installe-le depuis https://git-scm.com/download/win puis relance."
    Fin 1
}
git rev-parse --is-inside-work-tree *> $null
if ($LASTEXITCODE -ne 0) {
    Erreur "Ce dossier n'est pas relié à GitHub. Suis le guide pour récupérer le projet."
    Fin 1
}

# Sans ça, git écrit les noms accentués en codes illisibles dans l'historique.
git config core.quotepath false

# Nom affiché dans l'historique : demandé une seule fois par poste.
$nom = git config user.name
if (-not $nom) {
    $nom = Read-Host "  Premier lancement : ton prénom (pour l'historique)"
    git config user.name "$nom"
    git config user.email "$($nom.ToLower() -replace '[^a-z0-9]', '')@users.noreply.github.com"
}

# Espace personnel : demandé une seule fois par poste, pour repérer les
# modifications faites par erreur dans l'espace d'un autre membre.
# Les espaces sont les sous-dossiers de Espaces/ (un par pseudo GitHub).
$espaces = @(Get-ChildItem -LiteralPath (Join-Path $PSScriptRoot 'Espaces') -Directory -ErrorAction SilentlyContinue | ForEach-Object { $_.Name })
$espace = git config coffre.espace
if ($espaces.Count -gt 0 -and $espace -notin $espaces) {
    if ($nom -in $espaces) { $espace = $nom }
    elseif ($NoPause) { Erreur "Espace inconnu : lance d'abord SYNC.bat par un double-clic."; Fin 1 }
    else {
        for ($i = 0; $i -lt $espaces.Count; $i++) { Write-Host "    $($i + 1) = $($espaces[$i])" }
        $rep = Read-Host "  Quel est ton espace ? Tape son numéro"
        $n = 0
        if ([int]::TryParse($rep, [ref]$n) -and $n -ge 1 -and $n -le $espaces.Count) { $espace = $espaces[$n - 1] }
        else { Erreur "Réponds par un numéro de la liste. Relance SYNC.bat."; Fin 1 }
    }
    git config coffre.espace $espace
}
$autres = @($espaces | Where-Object { $_ -ne $espace })

$branche = git symbolic-ref --short HEAD
$date = Get-Date -Format 'yyyy-MM-dd HH:mm'

# --- 1) Enregistrer ses propres modifs --------------------------------------
git add -A 2> $null

# Garde-fou : on ne modifie pas l'espace d'un autre sans s'en rendre compte.
$chezAutre = @(git diff --cached --name-only | Where-Object {
    $f = $_
    @($autres | Where-Object { $f -like "Espaces/$_/*" }).Count -gt 0
})
if ($chezAutre.Count -gt 0) {
    $proprio = ($chezAutre[0] -split '/')[1]
    Erreur "Tu as modifié l'espace de $proprio : $(Split-Path $chezAutre[0] -Leaf)."
    $rep = if ($NoPause) { 'n' } else { Read-Host "  Envoyer quand même ? (o/N)" }
    if ($rep -notmatch '^[oOyY]') {
        git reset -q
        Erreur "Rien n'a été envoyé. Déplace cette modification dans ton espace, puis relance."
        Fin 1
    }
}

# Garde-fou : beaucoup de fichiers disparus d'un coup, c'est presque toujours
# un accident (dossier déplacé, récupération incomplète), pas un vrai ménage.
$supprimes = @(git diff --cached --name-only --diff-filter=D)
if ($supprimes.Count -gt 5) {
    git reset -q
    Erreur "$($supprimes.Count) fichiers ont disparu du dossier (ex. : $(Split-Path $supprimes[0] -Leaf))."
    Erreur "Par sécurité, rien n'a été envoyé. Vérifie le dossier avec ton binôme."
    Fin 1
}

git diff --cached --quiet
if ($LASTEXITCODE -ne 0) {
    $resume = (git diff --cached --name-only | ForEach-Object { Split-Path $_ -Leaf }) -join ', '
    if ($resume.Length -gt 60) { $resume = $resume.Substring(0, 57) + '...' }
    git commit -q -m "Modifs de $nom le $date : $resume"
    Ok "Tes modifications sont enregistrées."
} else {
    Info "Aucune modification de ton côté."
}

# --- 2) Récupérer celles du binôme, 3) envoyer -------------------------------
# Deux essais : si le binôme envoie pile entre notre récupération et notre
# envoi, GitHub refuse et il suffit de recommencer.
for ($essai = 1; $essai -le 2; $essai++) {
    Info "Récupération de la dernière version sur GitHub..."
    git fetch -q origin
    if ($LASTEXITCODE -ne 0) {
        Erreur "Impossible de joindre GitHub (connexion internet ? invitation acceptée ?)."
        Fin 1
    }

    git rev-parse --verify -q "origin/$branche" *> $null
    if ($LASTEXITCODE -eq 0) {
        $avant = git rev-parse HEAD
        git rebase -q "origin/$branche" *> $null
        if ($LASTEXITCODE -ne 0) {
            # Les notes se fusionnent seules (voir .gitattributes). On n'arrive donc
            # ici que pour un fichier binaire modifié des deux côtés, comme le tableur.
            # On met ta version de côté sur GitHub et on prend celle du binôme.
            git rebase --abort *> $null
            $secours = "sauvegarde-$($nom -replace '[^A-Za-z0-9]', '')-$(Get-Date -Format 'yyyyMMdd-HHmm')"
            git branch $secours
            git push -q origin $secours *> $null
            if ($LASTEXITCODE -ne 0) {
                # Sans copie sur GitHub, on ne touche à rien : ton travail reste ici.
                Erreur "CONFLIT, et la sauvegarde sur GitHub a échoué. Rien n'a été modifié."
                Erreur "Ta version reste dans ce dossier. Vérifie ta connexion et relance."
                Fin 1
            }
            git reset -q --hard "origin/$branche"
            Erreur "CONFLIT : vous avez modifié le même fichier non fusionnable."
            Erreur "Ton dossier contient maintenant SA version."
            Erreur "La tienne est sauvegardée sur GitHub dans la branche '$secours'."
            Erreur "Mettez-vous d'accord sur quoi garder avant de continuer."
            Fin 2
        }
        if ($avant -ne (git rev-parse HEAD)) { Ok "Modifications du binôme récupérées." }
        else { Info "Rien de nouveau côté binôme." }
    }

    git push -q -u origin $branche *> $null
    if ($LASTEXITCODE -eq 0) {
        Ok "Tout est à jour sur GitHub."
        Write-Host ""
        Write-Host "Derniers changements :" -ForegroundColor White
        git --no-pager log -5 --format="  %ad  %s" --date=format:"%d/%m %H:%M"
        Fin 0
    }
    Info "GitHub a refusé l'envoi (le binôme vient d'envoyer ?), nouvel essai..."
}
Erreur "Envoi impossible. Vérifie que tu as accepté l'invitation GitHub au dépôt"
Erreur "(dans tes emails), puis relance SYNC.bat."
Fin 1
