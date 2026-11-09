# Synchronise le coffre Obsidian avec GitHub, pour travailler à plusieurs.
# Ordre : 1) on enregistre ses modifs localement, 2) on récupère celles des
# autres, 3) on envoie le tout. Obsidian peut rester ouvert : il recharge
# tout seul les fichiers que git vient de changer.
# L'équipe (espaces, étiquettes, couleurs) est décrite dans equipe.json.
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
function Info($msg)   { Write-Host "  ..  $msg" -ForegroundColor Gray }
function Erreur($msg) { Write-Host "  !!  $msg" -ForegroundColor Red }

# --- L'équipe -------------------------------------------------------------------
# equipe.json donne pour chaque membre : son espace (pseudo GitHub = dossier de
# Espaces/), son étiquette Obsidian (#etiquette), sa couleur et sa couleur console.
# Sans ce fichier, on prend les dossiers de Espaces/ avec des couleurs par défaut.
$palette = @(
    @{ couleur = 'bleu';   console = 'Cyan' },
    @{ couleur = 'orange'; console = 'DarkYellow' },
    @{ couleur = 'vert';   console = 'Green' },
    @{ couleur = 'rose';   console = 'Magenta' }
)
$membres = @()
$tableurOrigine = ''
try {
    if (Test-Path -LiteralPath 'equipe.json') {
        $cfgEquipe = [IO.File]::ReadAllText((Join-Path $PSScriptRoot 'equipe.json')) | ConvertFrom-Json
        $membres = @($cfgEquipe.membres)
        $tableurOrigine = "$($cfgEquipe.tableurOrigine)"
    }
} catch { Info "equipe.json illisible : couleurs par défaut." }
if ($membres.Count -eq 0) {
    $i = 0
    foreach ($d in @(Get-ChildItem -LiteralPath (Join-Path $PSScriptRoot 'Espaces') -Directory -ErrorAction SilentlyContinue)) {
        $p = $palette[$i % $palette.Count]; $i++
        $membres += [pscustomobject]@{ espace = $d.Name; etiquette = $d.Name.ToLower(); couleur = $p.couleur; console = $p.console }
    }
}
$espaces = @($membres | ForEach-Object { $_.espace })
function Membre($esp) { $membres | Where-Object { $_.espace -eq $esp } | Select-Object -First 1 }
function EtiquetteDe($esp) { $m = Membre $esp; if ($m) { return $m.etiquette } else { return $esp.ToLower() } }
function CouleurDe($esp) { $m = Membre $esp; if ($m -and $m.console) { return $m.console } else { return 'White' } }
$legende = (@($membres | ForEach-Object { "$($_.couleur) pour $($_.espace)" }) -join ', ')
if ($legende) { $legende = $legende.Substring(0, 1).ToUpper() + $legende.Substring(1) + '.' }

# Le nom de l'historique peut différer du pseudo : on le rattache à un espace.
function EspaceDe($auteur) {
    if ($auteur -in $espaces) { return $auteur }
    if ($auteur -eq (git config user.name)) { return $espace }
    if ($autres.Count -eq 1) { return $autres[0] }
    return $auteur
}

# Active la feuille de couleurs partagée. Le réglage reste local : Obsidian le relit à son redémarrage.
function ActiverCouleurs {
    if (-not (Test-Path -LiteralPath '.obsidian/snippets/couleurs-equipe.css')) { return }
    $p = '.obsidian/appearance.json'
    try {
        $cfg = if (Test-Path -LiteralPath $p) { [IO.File]::ReadAllText((Resolve-Path -LiteralPath $p).Path) | ConvertFrom-Json } else { New-Object PSObject }
        if ($null -eq $cfg) { $cfg = New-Object PSObject }
        $liste = @($cfg.enabledCssSnippets | Where-Object { $_ })
        if ($liste -contains 'couleurs-equipe') { return }
        $cfg | Add-Member -NotePropertyName enabledCssSnippets -NotePropertyValue @($liste + 'couleurs-equipe') -Force
        $complet = Join-Path (Get-Location).Path $p
        [IO.File]::WriteAllText($complet, ($cfg | ConvertTo-Json -Depth 10), (New-Object System.Text.UTF8Encoding($false)))
        Ok "Couleurs activées : ferme et rouvre Obsidian pour les voir."
    } catch {
        Info "Couleurs à activer à la main : Réglages, Apparence, Extraits CSS."
    }
}

# Refait la page Activité d'après l'historique. Elle n'est pas envoyée : chacun a la sienne, sans conflit possible.
function EcrireActivite {
    $sortie = New-Object System.Collections.ArrayList
    [void]$sortie.Add("# Activité`n`nRetour à [[00 - Accueil]] · [[Ce qu'on a fait]]`n`nCette page est refaite à chaque ``SYNC.bat`` : n'écris rien ici. $legende`n")
    $fichiers = New-Object System.Collections.ArrayList
    $entete = $null
    $vider = {
        if ($entete) {
            [void]$sortie.Add($entete)
            $fichiers | Select-Object -First 8 | ForEach-Object { [void]$sortie.Add("> - ``$_``") }
            if ($fichiers.Count -gt 8) { [void]$sortie.Add("> - et $($fichiers.Count - 8) autre(s)") }
            [void]$sortie.Add('')
        }
    }
    foreach ($l in (git log -20 --no-merges --format="@@%an%x09%ad" --date=format:"%d/%m à %H:%M" --name-only)) {
        if ($l -like '@@*') {
            & $vider
            $champs = $l.Substring(2) -split "`t"
            $esp = EspaceDe $champs[0]
            $entete = "> [!$(EtiquetteDe $esp)] $esp, le $($champs[1])"
            $fichiers.Clear()
        } elseif ($l) { [void]$fichiers.Add($l) }
    }
    & $vider
    $dossier = Join-Path (Get-Location).Path 'Équipe'
    # Cette page n'est qu'un confort : un problème ici ne doit jamais faire échouer la synchro.
    try {
        [void][IO.Directory]::CreateDirectory($dossier)
        [IO.File]::WriteAllText((Join-Path $dossier 'Activité.md'), (($sortie -join "`n") + "`n"), (New-Object System.Text.UTF8Encoding($false)))
    } catch { Info "Page Activité non mise à jour." }
}

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

# Aperçu du tableur dans Obsidian : seulement le sien, pour ne jamais écrire dans le fichier d'un autre.
# Un confort : s'il échoue, la synchro continue.
try {
    if ($espace -and (Test-Path -LiteralPath 'tableur-vers-note.ps1')) {
        & (Join-Path $PSScriptRoot 'tableur-vers-note.ps1') -Espace $espace -Etiquette (EtiquetteDe $espace) -Origine $tableurOrigine
    }
} catch { Info "Aperçu du tableur non mis à jour : ferme-le s'il est ouvert, puis relance." }

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

# --- 2) Récupérer celles des autres, 3) envoyer ------------------------------
# Deux essais : si quelqu'un envoie pile entre notre récupération et notre
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
        $base = git merge-base HEAD "origin/$branche"
        git rebase -q "origin/$branche" *> $null
        if ($LASTEXITCODE -ne 0) {
            # Les notes se fusionnent seules (voir .gitattributes). On n'arrive donc
            # ici que pour un fichier binaire modifié des deux côtés, comme un tableur.
            # On met ta version de côté sur GitHub et on prend celle des autres.
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
            Erreur "Ton dossier contient maintenant la version de GitHub."
            Erreur "La tienne est sauvegardée sur GitHub dans la branche '$secours'."
            Erreur "Mettez-vous d'accord sur quoi garder avant de continuer."
            Fin 2
        }
        $nouveautes = @(git log --no-merges --format="%an%x09%ad%x09%s" --date=format:"%d/%m %H:%M" "$base..origin/$branche")
        if ($nouveautes.Count -gt 0) {
            Ok "Modifications des autres récupérées :"
            foreach ($n in $nouveautes) {
                $c = $n -split "`t"
                $esp = EspaceDe $c[0]
                Write-Host "      $esp, $($c[1]) : $($c[2])" -ForegroundColor (CouleurDe $esp)
            }
        } else { Info "Rien de nouveau côté binôme." }
    }

    git push -q -u origin $branche *> $null
    if ($LASTEXITCODE -eq 0) {
        Ok "Tout est à jour sur GitHub."
        EcrireActivite
        ActiverCouleurs
        Write-Host ""
        Write-Host "Derniers changements :" -ForegroundColor White
        git --no-pager log -5 --format="  %ad  %s" --date=format:"%d/%m %H:%M"
        Fin 0
    }
    Info "GitHub a refusé l'envoi (quelqu'un vient d'envoyer ?), nouvel essai..."
}
Erreur "Envoi impossible. Vérifie que tu as accepté l'invitation GitHub au dépôt"
Erreur "(dans tes emails), puis relance SYNC.bat."
Fin 1
