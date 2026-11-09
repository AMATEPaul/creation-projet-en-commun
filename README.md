# creation-projet-en-commun

Un skill [Claude Code](https://code.claude.com/docs/en/skills) qui monte un **projet en commun à deux (ou plus)** : un coffre [Obsidian](https://obsidian.md) synchronisé par un dépôt GitHub privé, avec un simple double-clic sur `SYNC.bat`.

L'idée, le rangement et le script de synchro viennent de **Raphaël** ([@glm02](https://github.com/glm02)), mon binôme à l'IUT, qui les a mis au point pour notre SAÉ. Ce skill les rend réutilisables pour n'importe quel projet.

## Le rangement : trois zones

```text
<Projet>/
├── 00 - Accueil.md            chaque séance, l'équipe, les espaces, le guide, les documents
├── CLAUDE.md + .claude/skills/<projet>/   le skill de séance du projet
├── Guide/                     la méthode : projet en clair, données, premiers pas,
│                              formulaire, repères dans le poly, travailler à deux,
│                              aide aux calculs par paliers
├── Équipe/                    le commun : questions à cocher, pièges et questions au prof,
│                              répartition, décisions communes, résultats validés,
│                              « ce qu'on a fait » (qui rassemble les journaux)
├── Espaces/<pseudo>/          à chacun : brouillon, journal, tableur
├── Documents/                 les sources (sujet, poly, tableur d'origine)
├── Animation/                 facultatif
└── SYNC.bat + sync-obsidian.ps1
```

| Zone | Qui écrit |
|---|---|
| `Guide/` | Personne sans prévenir les autres |
| `Équipe/` | Tout le monde, selon la table de `Répartition` |
| `Espaces/<pseudo>/` | Seulement le propriétaire, et `SYNC.bat` y veille |

## Ce qu'il fait

**Créer un coffre** (`/creation-projet-en-commun`) :
- lit les documents du projet (sujet, poly, tableur…) ;
- écrit toutes les notes avec le vrai contenu du projet ;
- crée un espace par membre, avec sa copie du tableur ;
- ajoute un **skill de séance** propre au projet. Il fait le point en début de séance, écrit seulement dans l'espace de la personne, tient son journal et synchronise en fin de séance ;
- crée le dépôt GitHub **privé**, invite les membres et vérifie la première synchro.

Il y a deux modes :
- **guidé (mode prof)** : le coffre ne contient aucune réponse. L'aide aux calculs se déplie par paliers, sur un cas inventé, et Claude relance par des questions ;
- **normal** : Claude peut calculer et proposer.

**Rejoindre un coffre** : accepter l'invitation, cloner, régler son espace, ouvrir le bon dossier dans Obsidian, faire la première synchro.

## Le script de synchro

`SYNC.bat` lance `sync-obsidian.ps1`, qui :
1. demande une seule fois le prénom et l'espace du poste (les espaces sont les dossiers de `Espaces/`) ;
2. enregistre tes modifs (commit). Il s'arrête si tu as modifié l'espace d'un autre, ou si plus de 5 fichiers ont disparu d'un coup ;
3. récupère celles des autres (fetch + rebase). Les notes `.md` se fusionnent seules (`merge=union`). Pour un fichier binaire modifié des deux côtés, ta version est sauvegardée sur une branche GitHub et tu reçois celle de l'autre ;
4. envoie le tout (push), avec un 2e essai si quelqu'un vient d'envoyer.

## Installation

```bash
git clone https://github.com/AMATEPaul/creation-projet-en-commun.git ~/.claude/skills/creation-projet-en-commun
```

Puis, dans Claude Code, `/reload-skills` (ou redémarrer la session) et lancer `/creation-projet-en-commun`.

## Prérequis

- Windows (le script de synchro est en PowerShell)
- [Git](https://git-scm.com/download/win), [GitHub CLI](https://cli.github.com) connecté (`gh auth login`) et [Obsidian](https://obsidian.md/download)
- un compte GitHub par membre

## Contenu

| Fichier | Rôle |
|---|---|
| `SKILL.md` | La méthode que suit Claude (créer ou rejoindre) |
| `references/organisation.md` | Le rangement du coffre, zone par zone et note par note |
| `modele/SYNC.bat`, `modele/sync-obsidian.ps1` | Le script de synchro |
| `modele/gitignore.txt`, `modele/gitattributes.txt` | Copiés en `.gitignore` et `.gitattributes` dans le coffre |
| `modele/CLAUDE.md`, `modele/skill-projet/SKILL.md` | Le skill de séance du projet |
| `modele/Guide/`, `modele/Équipe/`, `modele/Espaces/` | Les notes génériques à compléter |
