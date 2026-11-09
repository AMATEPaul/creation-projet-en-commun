---
name: creation-projet-en-commun
description: Créer, ou rejoindre, un projet en commun à deux sous forme de coffre Obsidian synchronisé par GitHub. Le dépôt est privé, et un SYNC.bat en double-clic enregistre, récupère et envoie les modifs, avec des garde-fous contre les conflits. Les notes sont rangées de 00 à 09 (accueil, projet en clair, questions, données, premiers pas, brouillon, formulaire, pièges, repères, travailler à deux), à côté des dossiers Documents/ et Animation/. À utiliser quand l'utilisateur veut monter un projet partagé avec un binôme (SAE, TP, projet de groupe), créer un coffre Obsidian commun, travailler à deux sur Obsidian, ou rejoindre et installer le coffre qu'un binôme a créé.
metadata:
  categorie: iut/projet
  resume: Créer ou rejoindre un coffre Obsidian partagé à deux via GitHub (SYNC.bat, notes 00-09).
---

# Créer un projet en commun (Obsidian + GitHub)

Ce skill monte un **coffre Obsidian partagé entre deux personnes**. Le coffre est un dépôt GitHub **privé**. Chacun travaille dans Obsidian sur son PC, puis double-clique sur `SYNC.bat` pour envoyer ses modifs et récupérer celles de l'autre. La méthode vient de Raphaël, le binôme de l'auteur à l'IUT, qui l'a mise au point pour la SAÉ VV3.

Deux cas :
- **A. Créer** le coffre d'un nouveau projet. L'utilisateur est le propriétaire du dépôt.
- **B. Rejoindre** le coffre qu'un binôme a déjà créé. L'utilisateur a reçu une invitation.

Si ce n'est pas clair, demande lequel des deux avant de commencer.

Fichiers du skill :
- `modele/SYNC.bat` et `modele/sync-obsidian.ps1` : le script de synchro. **Copie-les tels quels** avec `cp` : le `.ps1` doit garder son BOM UTF-8 et ses fins de ligne CRLF, sinon les accents s'affichent mal sous PowerShell 5.1. Ne les réécris jamais avec l'outil Write.
- `modele/gitignore.txt` devient `.gitignore`, et `modele/gitattributes.txt` devient `.gitattributes`.
- `modele/09 - Travailler à deux.md` : la note de routine, avec des `{{…}}` à remplacer.
- `references/organisation.md` : **le rangement des notes 00 à 09, à lire avant d'écrire la moindre note.**

## Règles

- **Le dépôt est toujours privé.** Les sujets et les polys appartiennent aux profs. Ne crée jamais le dépôt d'un projet en public, et ne le rends jamais public.
- Pas de mots de passe, de jetons, ni de données personnelles dans les notes.
- Ne lance jamais une copie isolée de `SYNC.bat` : le `.bat` appelle le `.ps1` qui est **dans le même dossier**.
- Avant de lancer `SYNC.bat` ou le script, vérifie qu'aucun Excel ou Word n'a un fichier du coffre ouvert.
- Pour lancer la synchro depuis Claude, utilise la version sans pause, sinon le script attend une touche :
  `powershell -NoProfile -ExecutionPolicy Bypass -File "<coffre>\sync-obsidian.ps1" -NoPause`

## A. Créer le coffre d'un projet

### 1. Cadrer (une seule question groupée)
Demande avec AskUserQuestion, en ne posant que ce que tu ne sais pas déjà :
- le **nom du projet**, qui sera le nom du dossier (par exemple `SAE VV3`) ;
- le **pseudo GitHub du binôme** (il doit avoir un compte) ;
- le **dossier des documents sources** (sujet, poly, tableur…) ;
- le **mode** :
  - **guidé (recommandé pour un projet noté)** : aucune réponse dans le coffre, des coups de pouce sous forme de questions ;
  - **normal** : le coffre peut contenir des réponses.

Le dossier du coffre se met par défaut dans `%USERPROFILE%\Documents\<Nom du projet>`. Le nom du dépôt GitHub reprend le nom du projet en minuscules, avec des tirets à la place des espaces (`sae-vv3`).

### 2. Vérifier les outils
```bash
git --version
gh auth status            # sinon : faire taper `! gh auth login` à l'utilisateur
ls "$LOCALAPPDATA/Programs/Obsidian/Obsidian.exe"   # sinon : https://obsidian.md/download
gh repo view <proprio>/<depot>   # doit échouer : le nom doit être libre
```

### 3. Lire toutes les sources
Lis **en entier** chaque document du projet : le sujet, le tableur (toutes les feuilles), et la table des matières du poly. Repère les questions numérotées, les données, les formules, les ambiguïtés et les pages utiles du poly. Pour les PDF, le texte seul perd les figures et les formules : affiche les pages importantes en images.

### 4. Construire le coffre
1. Crée le dossier, puis `Documents/`. Copie-y les sources sous des noms courts et lisibles.
2. Copie les fichiers du modèle :
   ```bash
   M=~/.claude/skills/creation-projet-en-commun/modele; C="$USERPROFILE/Documents/<Nom>"
   cp "$M/SYNC.bat" "$M/sync-obsidian.ps1" "$C/"
   cp "$M/gitignore.txt" "$C/.gitignore"; cp "$M/gitattributes.txt" "$C/.gitattributes"
   ```
3. Copie `modele/09 - Travailler à deux.md` et remplace `{{DEPOT_URL}}` (`https://github.com/<proprio>/<depot>`) et `{{NOM_DOSSIER}}`.
4. Écris les notes 00 à 08 en suivant **exactement** `references/organisation.md`, avec le contenu réel du projet. Ce sont les vraies questions, les vraies données et les vrais numéros de page, pas des modèles vides. En mode guidé, aucun résultat chiffré, aucune réponse.
5. `Animation/` est facultatif : propose-la seulement si une explication visuelle aide vraiment.

### 5. Publier sur GitHub en privé et inviter le binôme
```bash
cd "$USERPROFILE/Documents/<Nom>"
git init -b main
git config core.quotepath false
git add -A
git commit -m "Met le coffre Obsidian de <Nom> en commun"
gh repo create <depot> --private --source . --push
gh api -X PUT "repos/<proprio>/<depot>/collaborators/<pseudo-binome>" -f permission=push
```
Vérifie ensuite que le dépôt est bien privé : `gh repo view --json visibility`.

### 6. Ouvrir dans Obsidian et faire la 1re synchro
- L'utilisateur ouvre le coffre lui-même : *Gérer les coffres* → *Ouvrir un dossier en tant que coffre* → `Documents\<Nom>`, sélectionné **sans entrer dedans**.
- **Vérifie** dans `%APPDATA%\obsidian\obsidian.json` que le coffre marqué `"open": true` pointe bien vers ce dossier. Une erreur fréquente : Obsidian a ouvert un autre dossier, ou le sous-dossier `.obsidian`.
- Lance une synchro (`-NoPause`) : elle doit afficher `Tout est à jour sur GitHub`.

### 7. Donner le message pour le binôme
Termine avec un bloc à copier-coller pour le binôme : accepter l'invitation (`https://github.com/<proprio>/<depot>/invitations`), installer Git et Obsidian, la ligne `git clone`, l'ouverture du coffre, le premier `SYNC.bat`. Ce sont les étapes de la note 09.

## B. Rejoindre le coffre d'un binôme

1. **Invitation** : si elle n'est pas encore acceptée, `gh api user/repository_invitations` liste les invitations, et `gh api -X PATCH user/repository_invitations/<id>` en accepte une. Demande d'abord à l'utilisateur, puisque l'acceptation agit sur son compte.
2. **Outils** : Git, `gh auth status`, Obsidian (voir A.2).
3. **Cloner** dans Documents :
   ```bash
   git clone https://github.com/<proprio>/<depot>.git "$USERPROFILE/Documents/<Nom>"
   ```
4. **Lire `sync-obsidian.ps1` avant de le lancer** : il vient de quelqu'un d'autre. Vérifie qu'il ne fait que des commandes git dans son propre dossier.
5. **Identité Git** : `git config user.name`. Si elle est vide, le script demande un prénom de façon interactive. Demande-le à l'utilisateur et fais `git config user.name "<Prénom>"` dans le dépôt avant de lancer le script avec `-NoPause`.
6. **Ouvrir dans Obsidian** et vérifier dans `obsidian.json`, comme en A.6.
7. **Première synchro** (`-NoPause`), puis montre l'état : `git status -sb` doit afficher `main...origin/main` sans `behind` ni `ahead`.

## Vérifier que « c'est synchro »

```bash
cd "<coffre>"; git fetch -q origin; git status -sb
git log -3 --format="%h %ad %an : %s" --date=format:"%d/%m %H:%M"
```
- `[behind N]` : le binôme a envoyé N modifs. Lance SYNC pour les récupérer, et montre ce qui change avec `git diff HEAD origin/main --stat`.
- `[ahead N]` ou des fichiers modifiés : il reste des modifs locales. Lance SYNC pour les envoyer.
- Si l'utilisateur dit avoir lancé SYNC et que rien n'a changé : cherche une autre copie de `SYNC.bat` (`find "$USERPROFILE" -maxdepth 3 -name SYNC.bat`). C'est souvent une copie dans Téléchargements, qui n'a pas son `.ps1` à côté.

## Après l'installation

Pendant le projet, respecte le mode choisi. En mode guidé, quand l'utilisateur travaille une question, guide-le par des étapes et des questions de contrôle, sans donner le résultat, sauf s'il le demande explicitement. Ses réponses vont dans `05 - Mon brouillon`, et il coche l'avancement dans `02`.
