# Rangement du coffre

Ce rangement est celui du coffre de la SAÉ VV3 d'IUT, monté par Raphaël et réorganisé pour le travail à deux. On l'adapte à chaque projet, mais on garde la logique : **trois zones**, chacune avec ses règles d'écriture.

| Zone | Contenu | Qui écrit |
|---|---|---|
| `Guide/` | La méthode : comprendre le projet, les données, les formules, l'aide | Personne sans prévenir les autres |
| `Équipe/` | Ce qui est commun : avancement, décisions, résultats validés, répartition | Tout le monde, selon la table de `Répartition` |
| `Espaces/<pseudo>/` | Le travail perso : brouillon, journal, tableur | Seulement le propriétaire. `SYNC.bat` bloque les modifs dans l'espace d'un autre |

## L'arborescence

```text
<Nom du projet>/
├── 00 - Accueil.md                     la seule note à la racine
├── CLAUDE.md                           renvoie vers le skill du projet (modele/CLAUDE.md)
├── .claude/skills/<slug>/SKILL.md      le skill de séance du projet (modele/skill-projet/SKILL.md)
├── Guide/
│   ├── 01 - Le projet en clair.md
│   ├── 03 - Mes données.md
│   ├── 04 - Premiers pas.md
│   ├── 06 - Formulaire du sujet.md     (ou « Références »)
│   ├── 08 - Repères dans le poly.md    (ou « Repères dans les cours »)
│   ├── 09 - Travailler à deux.md       (modele/Guide/, avec les {{…}} remplacés)
│   └── 10 - Aide aux calculs.md        des indices par paliers sur un exemple inventé
├── Équipe/
│   ├── 02 - Les N questions.md         (ou « Les tâches »)
│   ├── 07 - Pièges et questions au prof.md
│   ├── Répartition.md                  (modele/Équipe/)
│   ├── Décisions communes.md           (modele/Équipe/)
│   ├── Résultats validés.md            (modele/Équipe/)
│   └── Ce qu'on a fait.md              (modele/Équipe/) : intègre les journaux
├── Espaces/
│   ├── <pseudo1>/  Brouillon <pseudo1>.md · Journal <pseudo1>.md · Tableur <pseudo1>.xlsx
│   └── <pseudo2>/  Brouillon <pseudo2>.md · Journal <pseudo2>.md · Tableur <pseudo2>.xlsx
├── Documents/                          les sources reçues, à garder intactes
├── Animation/                          facultatif : explication animée en HTML + captures/
├── SYNC.bat · sync-obsidian.ps1
└── .gitignore · .gitattributes         (modele/gitignore.txt, modele/gitattributes.txt)
```

- **Les pseudos** sont les pseudos GitHub, écrits exactement pareil partout : le nom du dossier, le nom des fichiers et la table de `Répartition`. Le script retrouve les espaces à partir des noms de dossiers de `Espaces/`.
- Les notes gardent leur numéro d'origine, même rangées dans des zones différentes : 02 et 07 sont dans `Équipe/`, les autres dans `Guide/`. Obsidian trouve un lien `[[02 - Les N questions]]` quel que soit le dossier, à condition que les noms de notes soient **uniques** dans tout le coffre.
- `Documents/` contient des noms courts et lisibles, comme `Sujet SAÉ VV3.pdf`, `Poly VV3.pdf` ou `Feuille de calcul étudiants.xlsx`. Le tableur d'origine reste intact, et chaque espace a sa copie.

## Les conventions communes

- Le titre `# …` reprend le nom de la note, sans le numéro. Il est **en début de ligne**, sans espace ni tabulation devant, sinon Obsidian ne le traite pas comme un titre.
- La 2e ligne est `Retour à [[00 - Accueil]]`, éventuellement suivie de ` · [[Répartition]]` ou d'un lien vers la source.
- Dans le `Guide/`, la dernière ligne est `Suite : [[note suivante]]`.
- Les liens vers une page de PDF s'écrivent `[[Sujet.pdf#page=3|ouvrir la page 3]]`, et une page s'intègre avec `![[Sujet.pdf#page=1]]`. Attention : le numéro imprimé sur la page est souvent différent du numéro de page du PDF. Vérifie le décalage et note-le dans la note 08 et dans le skill du projet.
- Callouts Obsidian :
  - `[!abstract]` pour le résumé ;
  - `[!warning]` pour les pièges et les règles ;
  - `[!todo]` pour une case à remplir ;
  - `[!tip]` pour un conseil ;
  - `[!info]` et `[!note]` pour les explications ;
  - `[!question] À toi` pour une question de réflexion ;
  - `[!question]- Palier N` ou `Coup de pouce` pour un indice replié ;
  - `[!example]-` pour un exemple replié ;
  - `[!check]-` pour une vérification repliée.
- Les schémas sont en mermaid, les formules en LaTeX (`$…$`, `$$…$$`).
- Les phrases sont courtes, avec des listes et des tableaux plutôt que des pavés.
- Le texte s'adresse à « vous » dans `Équipe/` et l'accueil, et à « tu » dans le `Guide/` et les espaces.

## Note par note

### 00 - Accueil (racine)
1. `> [!abstract] Le projet en une phrase`
2. `> [!warning] La règle de ce coffre`. En mode guidé : « Il n'y a aucune réponse ici. Les notes montrent le système, le chemin et les pièges. Les calculs et les choix restent à vous. »
3. **Chaque séance** : en arrivant `SYNC.bat` puis [[Ce qu'on a fait]] ; pendant, travailler dans son espace ; en partant, une entrée dans son journal puis `SYNC.bat`.
4. **L'équipe** : un tableau `| Note | À quoi elle sert |` avec Répartition, Ce qu'on a fait, Décisions communes, Résultats validés, 02, 07.
5. **Les espaces personnels** : un tableau `| | Brouillon | Journal | Tableur |` avec une ligne par pseudo, et des liens `[[Brouillon pseudo]]`, `[[Journal pseudo]]`, `[[Tableur pseudo.xlsx]]`.
6. **Le guide** : le lien vers l'animation s'il y en a une, puis un tableau des notes du `Guide/`.
7. **Documents** : un lien vers chaque fichier, en précisant le nombre de pages, et la mention « à garder intacte » pour le tableur d'origine.
8. Les captures de l'animation, intégrées en bas, s'il y en a.

### Guide/01 - Le projet en clair
- Le contexte, avec la 1re page du sujet intégrée.
- Le déroulement en liste numérotée.
- La chaîne technique en `flowchart LR`.
- **Ce que tu dois produire** : les livrables et les choix à faire.
- **Les blocs** en `flowchart TD`, avec les questions de chaque bloc et l'ordre imposé.
- Un `[!question] À toi`.

### Guide/03 - Mes données
- `> [!todo] Ma feuille` : « Note ta feuille en haut de ton brouillon, dans ton espace. Avez-vous la même feuille ? Écrivez-le dans [[Décisions communes]]. »
- Tous les jeux de données du tableur recopiés dans un tableau, plus les données qui sont seulement dans le sujet.
- Le tableau à remplir : quelles lignes du tableur appartiennent à quel bloc.
- Des `[!warning]` sur les incohérences, et des `[!question] À toi` qui renvoient vers [[Décisions communes]].

### Guide/04 - Premiers pas
- Environ 7 étapes. Pour chacune : une case à cocher, puis `> [!question]- Coup de pouce`, qui est une question et non une réponse.
- L'étape « préparer ton fichier » : ouvrir le tableur de son espace, l'original restant intact dans `Documents`.
- Une étape de contrôle avant d'avancer.
- **Quand tu bloques** : ouvrir [[10 - Aide aux calculs]], écrire ce qu'on a essayé, vérifier les unités puis les signes, montrer sa démarche à Claude.

### Guide/06 - Formulaire du sujet
- Toutes les formules du sujet en LaTeX, regroupées par thème, avec leur repère ([M1], p.9…), **sans application**.

### Guide/08 - Repères dans le poly
- Un tableau `| Pour | Où | Lien |`, avec le décalage entre page imprimée et page du PDF.

### Guide/09 - Travailler à deux
- Copie de `modele/Guide/09 - Travailler à deux.md`, avec `{{DEPOT_URL}}` (sans `.git`), `{{NOM_DOSSIER}}` et `{{SLUG}}` remplacés.

### Guide/10 - Aide aux calculs
- `> [!warning] Comment utiliser cette note` : déplier un palier seulement si le précédent ne suffit pas. Les exemples portent sur un **cas inventé**, dont les valeurs ne figurent dans aucun jeu de données du projet.
- **La méthode pour chaque calcul** : écrire ce qu'on cherche avec son unité, chercher la relation, faire le calcul en lettres, remplacer par les nombres et contrôler l'unité et l'ordre de grandeur.
- Pour chaque question de calcul : ce qu'on cherche, ce que le sujet donne, puis des paliers repliés, du plus léger au plus complet :
  - `[!question]- Palier 1 : comprendre l'image`
  - `Palier 2 : repérer…`
  - `Palier 3 : le faire en lettres`
  - `[!example]- Palier 4 : exemple complet sur un autre cas`, qui se termine par « À toi : … »
- Puis `[!check]- Ton résultat est-il plausible ?`, avec l'unité, des variations (« si k double… ») et un ordre de grandeur réaliste.
- **Dans le tableur** : taper `=`, cliquer sur les cases de données, bloquer avec F4, vérifier une colonne à la calculatrice.
- Elle couvre au moins les premiers blocs. On l'étend au fil du projet, toujours sur des cas inventés.

### Équipe/02 - Les N questions
- Des cases à cocher `- [ ] **Q1** intitulé résumé`, regroupées par bloc. C'est le responsable du bloc qui coche.

### Équipe/07 - Pièges et questions au prof
- **À demander au prof** : des cases à cocher, dont la date et le format du rendu, et chaque ambiguïté. Tout le monde ajoute des lignes.
- **Pièges pour la suite** : un `> [!warning]` par piège, écrit comme une question.

### Équipe/Répartition, Décisions communes, Résultats validés, Ce qu'on a fait
Elles partent des modèles de `modele/Équipe/`.
- `{{LIGNES_BLOCS}}` : une ligne `| 1. Nom du bloc | Q1 à Q6 | | | |` par bloc.
- `{{LIGNES_ESPACES}}` : une ligne ``| `Espaces/<pseudo>` | <pseudo> seulement |`` par membre.
- `[[02 - Les N questions]]` : à remplacer par le vrai nom de la note.
- `{{LIGNES_DECISIONS}}` : une ligne `| <hypothèse ouverte> | | | | |` par choix commun. On y met : quel jeu de données, les hypothèses ambiguës du sujet, les constantes non données, les fournisseurs.
- `{{SECTIONS_BLOCS}}` : un `## Bloc N — Nom` par bloc.
- `{{JOURNAUX_INTEGRES}}` : `![[Journal <pseudo>]]` pour chaque membre, séparés par `---`.

### Espaces/<pseudo>/
- **Journal <pseudo>.md** : `modele/Espaces/Journal.md`, avec `{{PSEUDO}}` remplacé. Il commence par un titre `###`, pour s'intégrer proprement dans « Ce qu'on a fait ». L'entrée la plus récente est en haut : **Fait**, **À vérifier par l'autre**, **Prochaine étape**.
- **Brouillon <pseudo>.md** : écrit pour le projet.
  - En tête : `Retour à [[00 - Accueil]]`, puis « Cet espace est à <pseudo> : seul <pseudo> y écrit. Les choix à partager vont dans [[Décisions communes]], et ce qui est fait dans le journal. »
  - **Mes valeurs** : une ligne avec des `___` pour chaque donnée du jeu.
  - Une section par question ou groupe de questions, avec des intitulés vides (« En lettres : », « En nombres : », « Unité : »).
  - **Mes choix de matériel** si le projet en a.
  - Les deux brouillons sont identiques au départ.
- **Tableur <pseudo>.xlsx** : une copie du tableur d'origine.

## Mode guidé ou mode normal

- **Guidé** (le choix par défaut pour un projet noté) : aucun résultat dans le coffre. Le skill du projet met Claude en « mode prof » :
  - il répond par des questions et des renvois précis ;
  - pour vérifier un calcul, il demande la démarche et indique l'étape où ça coince, sans donner la valeur juste ;
  - ses démonstrations portent sur un cas inventé ;
  - les choix de matériel restent les leurs.
- **Normal** : le coffre peut contenir des réponses. On retire « aucune réponse ici » de l'accueil, on garde l'aide aux calculs sur les vraies données si c'est demandé, et le skill du projet aide directement.
