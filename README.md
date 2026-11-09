# creation-projet-en-commun

Un skill [Claude Code](https://code.claude.com/docs/en/skills) qui monte un **projet en commun à deux** : un coffre [Obsidian](https://obsidian.md) synchronisé par un dépôt GitHub privé, avec un simple double-clic sur `SYNC.bat`.

L'idée et le script de synchro viennent de **Raphaël** ([@glm02](https://github.com/glm02)), mon binôme à l'IUT, qui l'a mis au point pour notre SAÉ. Ce skill la rend réutilisable pour n'importe quel projet.

## Ce qu'il fait

**Créer un coffre** (`/creation-projet-en-commun`) :
- lit les documents du projet (sujet, poly, tableur…) ;
- écrit des notes rangées de 00 à 09 :

  | Note | Rôle |
  |---|---|
  | 00 - Accueil | Le projet en une phrase, par où commencer, toutes les notes |
  | 01 - Le projet en clair | Contexte, déroulement, schémas, livrables, blocs de travail |
  | 02 - Les N questions | La liste à cocher, qui sert de suivi d'avancement |
  | 03 - Mes données | Le jeu de données et le tableau à remplir |
  | 04 - Premiers pas | Les premières étapes, avec des coups de pouce repliés |
  | 05 - Mon brouillon | L'espace de travail : hypothèses, réponses, journal |
  | 06 - Formulaire | Les formules du sujet, sans application |
  | 07 - Pièges et questions au prof | Ce qu'il faut surveiller et demander |
  | 08 - Repères dans le poly | Les liens vers les bonnes pages |
  | 09 - Travailler à deux | La routine de synchro et l'installation du binôme |

- range les sources dans `Documents/` (et une animation facultative dans `Animation/`) ;
- crée le dépôt GitHub **privé**, invite le binôme et vérifie la première synchro.

En **mode guidé**, le coffre ne contient aucune réponse : seulement le chemin, les pièges et des questions.

**Rejoindre un coffre** : accepter l'invitation, cloner, ouvrir le bon dossier dans Obsidian, faire la première synchro.

## Le script de synchro

`SYNC.bat` lance `sync-obsidian.ps1`, qui :
1. enregistre tes modifs (commit). Si plus de 5 fichiers ont disparu d'un coup, il s'arrête sans rien envoyer ;
2. récupère celles du binôme (fetch + rebase). Les notes `.md` se fusionnent seules (`merge=union`). Pour un fichier binaire modifié des deux côtés, ta version est sauvegardée sur une branche GitHub et tu reçois celle du binôme ;
3. envoie le tout (push), avec un 2e essai si le binôme vient d'envoyer.

## Installation

```bash
git clone https://github.com/AMATEPaul/creation-projet-en-commun.git ~/.claude/skills/creation-projet-en-commun
```

Puis, dans Claude Code, `/reload-skills` (ou redémarrer la session) et lancer `/creation-projet-en-commun`.

## Prérequis

- Windows (le script de synchro est en PowerShell)
- [Git](https://git-scm.com/download/win), [GitHub CLI](https://cli.github.com) connecté (`gh auth login`) et [Obsidian](https://obsidian.md/download)
- un compte GitHub pour chacun des deux

## Contenu

| Fichier | Rôle |
|---|---|
| `SKILL.md` | La méthode que suit Claude (créer ou rejoindre) |
| `references/organisation.md` | Le rangement du coffre, note par note |
| `modele/SYNC.bat`, `modele/sync-obsidian.ps1` | Le script de synchro |
| `modele/gitignore.txt`, `modele/gitattributes.txt` | Copiés en `.gitignore` et `.gitattributes` dans le coffre |
| `modele/09 - Travailler à deux.md` | La note de routine et d'installation |
