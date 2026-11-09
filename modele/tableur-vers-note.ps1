# Recopie le tableur d'une personne dans une note Obsidian, en lecture seule.
# Obsidian ne sait pas afficher un .xlsx : cette note permet de le lire sans quitter le coffre.
# Un .xlsx est un ZIP de fichiers XML : on le lit directement, sans avoir besoin d'Excel.
# -Etiquette : l'étiquette Obsidian de la personne (#etiquette, classe espace-etiquette).
# -Origine : le tableur d'origine, relatif au coffre, pour n'afficher que les feuilles modifiées.
param(
    [Parameter(Mandatory = $true)][string]$Espace,
    [string]$Etiquette = '',
    [string]$Origine = ''
)
if (-not $Etiquette) { $Etiquette = $Espace.ToLower() }

$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem
$racine = $PSScriptRoot
$ns = 'http://schemas.openxmlformats.org/officeDocument/2006/relationships'

function LireEntree($zip, $nom) {
    $e = $zip.GetEntry($nom)
    if (-not $e) { return $null }
    $r = New-Object IO.StreamReader($e.Open(), [Text.Encoding]::UTF8)
    try { return [xml]$r.ReadToEnd() } finally { $r.Dispose() }
}

# Renvoie les feuilles dans l'ordre : nom -> { cellule -> valeur }
function LireClasseur($chemin) {
    # Partage en lecture et écriture : le tableur reste lisible s'il est ouvert ailleurs
    $flux = New-Object IO.FileStream($chemin, [IO.FileMode]::Open, [IO.FileAccess]::Read, [IO.FileShare]::ReadWrite)
    $zip = New-Object IO.Compression.ZipArchive($flux, [IO.Compression.ZipArchiveMode]::Read)
    try {
        $textes = @()
        $sst = LireEntree $zip 'xl/sharedStrings.xml'
        if ($sst) { foreach ($si in $sst.DocumentElement.ChildNodes) { if ($si.LocalName -eq 'si') { $textes += $si.InnerText } } }

        $cibles = @{}
        foreach ($rel in (LireEntree $zip 'xl/_rels/workbook.xml.rels').DocumentElement.ChildNodes) {
            $cibles[$rel.GetAttribute('Id')] = $rel.GetAttribute('Target')
        }
        $feuilles = [ordered]@{}
        $wb = LireEntree $zip 'xl/workbook.xml'
        foreach ($noeud in $wb.DocumentElement.ChildNodes) {
            if ($noeud.LocalName -ne 'sheets') { continue }
            foreach ($s in $noeud.ChildNodes) {
                $cible = $cibles[$s.GetAttribute('id', $ns)]
                $entree = if ($cible.StartsWith('/')) { $cible.TrimStart('/') } else { "xl/$cible" }
                $cellules = @{}
                foreach ($c in (LireEntree $zip $entree).GetElementsByTagName('c')) {
                    $v = $c.GetElementsByTagName('v')
                    $f = $c.GetElementsByTagName('f')
                    $type = $c.GetAttribute('t')
                    $brut = if ($v.Count -gt 0) { $v[0].InnerText } else { '' }
                    if ($type -eq 'inlineStr') { $val = $c.InnerText }
                    elseif ($brut -ne '') { $val = if ($type -eq 's') { $textes[[int]$brut] } else { $brut } }
                    # Formule jamais calculée : on le dit plutôt que d'afficher une case vide
                    elseif ($f.Count -gt 0) { $val = '(à recalculer)' }
                    else { continue }
                    if ($null -ne $val -and "$val" -ne '') { $cellules[$c.GetAttribute('r')] = "$val" }
                }
                $feuilles[$s.GetAttribute('name')] = $cellules
            }
        }
        return $feuilles
    } finally { $zip.Dispose(); $flux.Dispose() }
}

function Colonne($ref) {
    $n = 0
    foreach ($ch in ($ref -replace '\d', '').ToCharArray()) { $n = $n * 26 + [int][char]$ch - 64 }
    return $n
}
function Lettre($n) {
    $s = ''
    while ($n -gt 0) { $r = ($n - 1) % 26; $s = [char](65 + $r) + $s; $n = [int][math]::Floor(($n - 1) / 26) }
    return $s
}
$fr = [Globalization.CultureInfo]::GetCultureInfo('fr-FR')
function Afficher($v) {
    $d = 0.0
    if ([double]::TryParse($v, [Globalization.NumberStyles]::Float, [Globalization.CultureInfo]::InvariantCulture, [ref]$d)) {
        return ([math]::Round($d, 4)).ToString('0.####', $fr)
    }
    return ($v -replace '\|', '\|' -replace '\r?\n', ' ')
}

function TableMarkdown($cellules) {
    $lignes = $cellules.Keys | ForEach-Object { [int]($_ -replace '[A-Z]', '') } | Sort-Object -Unique
    $cols = $cellules.Keys | ForEach-Object { Colonne $_ }
    $min = ($cols | Measure-Object -Minimum).Minimum
    $max = ($cols | Measure-Object -Maximum).Maximum
    $plage = $min..$max
    $t = New-Object System.Collections.ArrayList
    [void]$t.Add('| ' + (($plage | ForEach-Object { ' ' }) -join ' | ') + ' |')
    [void]$t.Add('|' + (($plage | ForEach-Object { '---' }) -join '|') + '|')
    foreach ($l in $lignes) {
        $cases = $plage | ForEach-Object {
            $ref = "$(Lettre $_)$l"
            if ($cellules.ContainsKey($ref)) { Afficher $cellules[$ref] } else { '' }
        }
        [void]$t.Add('| ' + ($cases -join ' | ') + ' |')
    }
    return ($t -join "`n")
}

$tableur = Join-Path $racine "Espaces/$Espace/Tableur $Espace.xlsx"
$origine = if ($Origine) { Join-Path $racine $Origine } else { '' }
$note = Join-Path $racine "Espaces/$Espace/Tableur $Espace - aperçu.md"
if (-not (Test-Path -LiteralPath $tableur)) { return }

$a = LireClasseur $tableur
$o = if ($origine -and (Test-Path -LiteralPath $origine)) { LireClasseur $origine } else { @{} }

# Seules les feuilles travaillées s'affichent : le tableur d'origine peut en contenir beaucoup
$morceaux = New-Object System.Collections.ArrayList
foreach ($nom in $a.Keys) {
    $c = $a[$nom]
    $ref = $o[$nom]
    $change = ($null -eq $ref) -or ($c.Count -ne $ref.Count)
    if (-not $change) { foreach ($k in $c.Keys) { if ($c[$k] -ne $ref[$k]) { $change = $true; break } } }
    if ($change -and $c.Count -gt 0) { [void]$morceaux.Add("## $nom`n`n$(TableMarkdown $c)`n") }
}
$classe = "espace-$Etiquette"
$tag = "#$Etiquette"
$lien = "Tableur%20$Espace.xlsx"
$corps = if ($morceaux.Count -gt 0) { $morceaux -join "`n" } else { "Rien de saisi pour l'instant.`n" }
$texte = "---`ncssclasses:`n  - $classe`n---`n`n# Tableur de $Espace $tag`n`n[Ouvrir le tableur]($lien)`n`nCopie automatique, refaite par ``SYNC.bat`` : écris dans le tableur, pas ici. Pense à l'enregistrer avant de synchroniser.`n`n$corps"

# Pas de date dans la note : sans changement réel, la synchro n'a rien à envoyer
$ancien = if (Test-Path -LiteralPath $note) { [IO.File]::ReadAllText($note) } else { '' }
if ($ancien -ne $texte) { [IO.File]::WriteAllText($note, $texte, (New-Object Text.UTF8Encoding($false))) }
