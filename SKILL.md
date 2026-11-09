---
name: creation-projet-en-commun
description: Créer, ou rejoindre, un projet en commun à deux (ou plus) sous forme de coffre Obsidian synchronisé par GitHub. Le dépôt est privé, et un SYNC.bat en double-clic enregistre, récupère et envoie les modifs, avec des garde-fous contre les conflits et contre les modifs dans l'espace d'un autre. Le coffre a trois zones : Guide/ pour la méthode, Équipe/ pour la répartition, les décisions, les résultats validés et l'avancement, Espaces/<pseudo>/ pour le brouillon, le journal et le tableur de chacun. Il a aussi un skill de séance propre au projet, en mode prof ou en mode normal. À utiliser quand l'utilisateur veut monter un projet partagé avec un binôme (SAE, TP, projet de groupe), créer un coffre Obsidian commun, travailler à deux sur Obsidian, ou rejoindre et installer le coffre qu'un binôme a créé.
metadata:
  categorie: iut/projet
  resume: Créer ou rejoindre un coffre Obsidian partagé à deux via GitHub (SYNC.bat, Guide / Équipe / Espaces).
---

# Créer un projet en commun (Obsidian + GitHub)

Ce skill monte un **coffre Obsidian partagé**. Le coffre est un dépôt GitHub **privé**. Chacun travaille dans Obsidian sur son PC, puis double-clique sur `SYNC.bat` pour envoyer ses modifs et récupérer celles des autres. La méthode et le rangement viennent de Raphaël, le binôme de l'auteur à l'IUT, qui les a mis au point pour la SAÉ VV3.

Deux cas :
- **A. Créer** le coffre d'un nouveau projet. L'utilisateur est le propriétaire du dépôt.
- **B. Rejoindre** le coffre qu'un binôme a déjà créé. L'utilisateur a reçu une invitation.

Si ce n'est pas clair, demande lequel des deux avant de commencer.

## Les fichiers du skill

- **`references/organisation.md` : le rangement complet (zones, notes, conventions). Lis-le avant d'écrire la moindre note.**
- `modele/SYNC.bat` et `modele/sync-obsidian.ps1` : le script de synchro.
  - **Copie-les tels quels** avec `cp` : le `.ps1` doit garder son BOM UTF-8 et ses fins de ligne CRLF, sinon les accents s'affichent mal sous PowerShell 5.1. Ne les réécris jamais avec l'outil Write.
  - Le script lit les espaces dans les sous-dossiers de `Espaces/`, retient celui du poste dans `git config coffre.espace`, et bloque l'envoi d'une modif faite dans l'espace d'un autre.
- `modele/gitignore.txt` devient `.gitignore`, et `modele/gitattributes.txt` devient `.gitattributes`.
- `modele/CLAUDE.md` et `modele/skill-projet/SKILL.md` : le skill de séance du projet, avec des `{{…}}` à remplacer.
- `modele/Guide/09 - Travailler à deux.md`, `modele/Équipe/*.md` et `modele/Espaces/Journal.md` : les notes génériques, avec des `{{…}}` à remplacer.

## Règles

- **Le dépôt est toujours privé.** Les sujets et les polys appartiennent aux profs. Ne crée jamais le dépôt d'un projet en public, et ne le rends jamais public.
- Pas de mots de passe, de jetons, ni de données personnelles dans les notes.
- Le coffre vit dans `Documents`, **hors de Google Drive et de OneDrive**, dont la synchronisation abîme `.git`.
- Ne lance jamais une copie isolée de `SYNC.bat` : le `.bat` appelle le `.ps1` qui est **dans le même dossier**.
- Avant une synchro, vérifie qu'aucun Excel ou Word n'a un fichier du coffre ouvert.
- Pour lancer la synchro depuis Claude, utilise la version sans pause. Elle ne pose aucune question, donc `user.name` et l'espace doivent déjà être réglés :
  `powershell -NoProfile -ExecutionPolicy Bypass -File "<coffre>\sync-obsidian.ps1" -NoPause`
- Une fois remplacés, il ne doit plus rester aucun `{{…}}` : vérifie avec `grep -rn "{{" .` avant le premier commit.

## A. Créer le coffre d'un projet

### 1. Cadrer (une seule question groupée)
Demande avec AskUserQuestion, en ne posant que ce que tu ne sais pas déjà :
- le **nom du projet**, qui sera le nom du dossier (par exemple `SAE VV3`) ;
- les **pseudos GitHub de tous les membres**, utilisateur compris. Ils serviront de noms d'espaces ;
- le **dossier des documents sources** (sujet, poly, tableur…) ;
- le **mode** :
  - **guidé, ou mode prof (recommandé pour un projet noté)** : aucune réponse dans le coffre, des aides par paliers sur des cas inventés ;
  - **normal** : le coffre et Claude peuvent donner des résultats.

Valeurs par défaut :
- le dossier est `%USERPROFILE%\Documents\<Nom du projet>` ;
- le **slug** est le nom en minuscules, avec des tirets à la place des espaces et sans accents (`sae-vv3`). Il sert au nom du dépôt GitHub et au nom du skill de projet.

### 2. Vérifier les outils
```bash
git --version
gh auth status            # sinon : faire taper `! gh auth login` à l'utilisateur
ls "$LOCALAPPDATA/Programs/Obsidian/Obsidian.exe"   # sinon : https://obsidian.md/download
gh repo view <proprio>/<slug>   # doit échouer : le nom doit être libre
gh api users/<pseudo> --jq .login   # pour chaque membre : le pseudo existe
```

### 3. Lire toutes les sources
Lis **en entier** chaque document du projet : le sujet, le tableur (toutes les feuilles), et la table des matières du poly. Repère :
- les questions numérotées et leurs blocs ;
- les données ;
- les formules ;
- les ambiguïtés, qui vont dans `07` et dans `Décisions communes` ;
- les pages utiles du poly, avec le décalage entre page imprimée et page du PDF.

Pour les PDF, le texte seul perd les figures et les formules : affiche les pages importantes en images.

### 4. Construire le coffre
```bash
M=~/.claude/skills/creation-projet-en-commun/modele; C="$USERPROFILE/Documents/<Nom>"
mkdir -p "$C/Guide" "$C/Équipe" "$C/Documents" "$C/.claude/skills/<slug>"
cp "$M/SYNC.bat" "$M/sync-obsidian.ps1" "$C/"
cp "$M/gitignore.txt" "$C/.gitignore"; cp "$M/gitattributes.txt" "$C/.gitattributes"
cp "$M/Équipe/"*.md "$C/Équipe/"; cp "$M/Guide/09 - Travailler à deux.md" "$C/Guide/"
cp "$M/CLAUDE.md" "$C/"; cp "$M/skill-projet/SKILL.md" "$C/.claude/skills/<slug>/"
# pour chaque membre :
mkdir -p "$C/Espaces/<pseudo>"; cp "$M/Espaces/Journal.md" "$C/Espaces/<pseudo>/Journal <pseudo>.md"
```
1. Copie les sources dans `Documents/` sous des noms courts et lisibles. Copie le tableur dans chaque espace sous le nom `Tableur <pseudo>.xlsx`.
2. Remplace tous les `{{…}}` des fichiers copiés. Le détail de chaque bloc est dans `references/organisation.md`. Pour le skill de projet :
   - `{{MEMBRES_PHRASE}}` : « Deux étudiants, `a` et `b`, » ;
   - `{{SUJET_COURT}}` : quelques mots-clés du sujet ;
   - `{{DOCUMENTS_LISTE}}` : les chemins des PDF de `Documents/` ;
   - `{{DECALAGE_POLY}}` : une phrase sur le décalage de pages, ou rien.
   - **En mode guidé :**
     - `{{MODE_COURT}}` = « mode prof, pas de résultat donné » ;
     - `{{TITRE_MODE}}` = « le mode prof » ;
     - `{{ROLE_CLAUDE}}` = « Tu es leur prof : ils doivent raisonner eux-mêmes. » ;
     - `{{REGLES_MODE}}` = les 4 puces suivantes :
       - Réponds par des questions et des renvois précis : page du sujet, formule, note du `Guide`.
       - Pour vérifier un calcul, demande d'abord sa démarche. Indique l'étape où ça coince (unité, signe, relation), sans donner la valeur juste.
       - Pour une démonstration, utilise un cas inventé, dont les valeurs ne figurent dans aucun jeu de données (voir `Guide/10 - Aide aux calculs.md`).
       - Les choix de matériel restent les leurs : aide à vérifier les critères du sujet sur une référence qu'ils ont trouvée.
   - **En mode normal :**
     - `{{MODE_COURT}}` = « mode coéquipier » ;
     - `{{TITRE_MODE}}` = « le mode coéquipier » ;
     - `{{ROLE_CLAUDE}}` = « Tu es leur coéquipier : tu peux calculer et proposer, en expliquant chaque étape pour qu'ils puissent la refaire. » ;
     - `{{REGLES_MODE}}` = des puces qui disent de montrer la démarche, de signaler les hypothèses et de faire valider chaque résultat par le relecteur du bloc.
3. Écris les notes propres au projet en suivant **exactement** `references/organisation.md`, avec le vrai contenu : vraies questions, vraies données, vrais numéros de page.
   - `00 - Accueil` ;
   - `Guide/` 01, 03, 04, 06, 08, 10 ;
   - `Équipe/` 02 et 07 ;
   - un `Brouillon <pseudo>.md` par membre.
   En mode guidé, aucun résultat chiffré, et les exemples de la note 10 portent sur un cas inventé.
4. `Animation/` est facultatif : propose-la seulement si une explication visuelle aide vraiment.
5. Contrôle :
   - `grep -rn "{{" .` doit être vide ;
   - les noms de notes doivent être uniques ;
   - aucun titre `#` ne doit commencer par un espace ou une tabulation.

### 5. Publier sur GitHub en privé et inviter les membres
```bash
cd "$USERPROFILE/Documents/<Nom>"
git init -b main
git config core.quotepath false
git config coffre.espace <pseudo-utilisateur>
git add -A
git commit -m "Met le coffre Obsidian de <Nom> en commun"
gh repo create <slug> --private --source . --push
gh api -X PUT "repos/<proprio>/<slug>/collaborators/<pseudo>" -f permission=push   # pour chaque autre membre
```
Vérifie ensuite que le dépôt est bien privé : `gh repo view --json visibility`.

### 6. Ouvrir dans Obsidian et faire la 1re synchro
- L'utilisateur ouvre le coffre lui-même : *Gérer les coffres* → *Ouvrir un dossier en tant que coffre* → `Documents\<Nom>`, sélectionné **sans entrer dedans**.
- **Vérifie** dans `%APPDATA%\obsidian\obsidian.json` que le coffre marqué `"open": true` pointe bien vers ce dossier. Une erreur fréquente : Obsidian a ouvert un autre dossier, ou le sous-dossier `.obsidian`.
- Lance une synchro (`-NoPause`) : elle doit afficher `Tout est à jour sur GitHub`.

### 7. Donner le message pour le binôme
Termine avec un bloc à copier-coller pour le binôme : accepter l'invitation (`https://github.com/<proprio>/<slug>/invitations`), installer Git et Obsidian, la ligne `git clone`, l'ouverture du coffre, le premier `SYNC.bat` (qui lui demande son espace) et `/<slug>` dans Claude Code. Ce sont les étapes de `Guide/09`.

## B. Rejoindre le coffre d'un binôme

1. **Invitation** : si elle n'est pas encore acceptée, `gh api user/repository_invitations` liste les invitations, et `gh api -X PATCH user/repository_invitations/<id>` en accepte une. Demande d'abord à l'utilisateur, puisque l'acceptation agit sur son compte.
2. **Outils** : Git, `gh auth status`, Obsidian (voir A.2).
3. **Cloner** dans Documents :
   ```bash
   git clone https://github.com/<proprio>/<depot>.git "$USERPROFILE/Documents/<Nom>"
   ```
4. **Lire `sync-obsidian.ps1` avant de le lancer** : il vient de quelqu'un d'autre. Vérifie qu'il ne fait que des commandes git dans son propre dossier. Repère aussi **la clé de config de l'espace** : `coffre.espace` pour un coffre créé par ce skill, mais un coffre plus ancien peut utiliser une autre clé, comme `saevv3.espace`.
5. **Identité et espace** : vérifie `git config user.name`, puis la clé d'espace. Comme `-NoPause` ne pose aucune question :
   - si le nom est vide, demande le prénom ou le pseudo et fais `git config user.name "<…>"` ;
   - si l'espace n'est pas réglé et que `user.name` ne correspond pas exactement à un dossier de `Espaces/`, fais `git config <clé> <pseudo>`.
6. **Ouvrir dans Obsidian** et vérifier dans `obsidian.json`, comme en A.6.
7. **Première synchro** (`-NoPause`), puis montre l'état : `git status -sb` doit afficher `main...origin/main` sans `behind` ni `ahead`.
8. S'il existe un `CLAUDE.md` ou un `.claude/skills/<slug>/` dans le coffre, signale-le : pour les séances, l'utilisateur ouvrira Claude Code **dans le coffre** et utilisera `/<slug>`.

## Vérifier que « c'est synchro »

```bash
cd "<coffre>"; git fetch -q origin; git status -sb
git log -3 --format="%h %ad %an : %s" --date=format:"%d/%m %H:%M"
```
- `[behind N]` : le binôme a envoyé N modifs. Lance SYNC pour les récupérer, et montre ce qui change avec `git diff --stat HEAD origin/main`.
- `[ahead N]` ou des fichiers modifiés : il reste des modifs locales. Lance SYNC pour les envoyer.
- Si l'utilisateur dit avoir lancé SYNC et que rien n'a changé : cherche une autre copie de `SYNC.bat` (`find "$USERPROFILE" -maxdepth 3 -name SYNC.bat`). C'est souvent une copie dans Téléchargements, qui n'a pas son `.ps1` à côté.

## Après l'installation

Les séances se passent avec le skill du projet (`/<slug>`), dans Claude Code ouvert **dans le coffre**. Il fait le point en début de séance, applique le mode choisi, écrit seulement dans l'espace de la personne, tient son journal et synchronise en fin de séance.
