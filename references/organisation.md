# Rangement du coffre

Ce rangement est celui du premier coffre partagé, celui de la SAÉ VV3 d'IUT. On l'adapte au projet, mais on garde la logique. Il se lit dans l'ordre des numéros, et chaque note a un seul rôle.

## L'arborescence

```text
<Nom du projet>/
├── 00 - Accueil.md
├── 01 - Le projet en clair.md
├── 02 - Les N questions.md          (ou « Les tâches » s'il n'y a pas de questions numérotées)
├── 03 - Mes données.md
├── 04 - Premiers pas.md
├── 05 - Mon brouillon.md
├── 06 - Formulaire du sujet.md      (ou « Références » selon le projet)
├── 07 - Pièges et questions au prof.md
├── 08 - Repères dans le poly.md     (ou « Repères dans les cours »)
├── 09 - Travailler à deux.md        (copie de modele/, avec les {{…}} remplacés)
├── Documents/                       sources reçues : sujet, poly, tableur, datasheets…
├── Animation/                       facultatif : explication animée en HTML + captures/
├── SYNC.bat
├── sync-obsidian.ps1
├── .gitignore                       copie de modele/gitignore.txt
└── .gitattributes                   copie de modele/gitattributes.txt
```

Les noms des fichiers de `Documents/` sont courts et lisibles, par exemple `Sujet SAÉ VV3.pdf`, `Poly VV3.pdf` ou `Feuille de calcul étudiants.xlsx`. Les liens des notes s'appuient sur ces noms.

## Les conventions communes à toutes les notes

- Le titre `# …` reprend le nom de la note, sans le numéro.
- La 2e ligne est `Retour à [[00 - Accueil]]`, éventuellement suivie de ` · ` et d'un lien vers la source.
- La dernière ligne est `Suite : [[note suivante]]`, sauf pour les notes 05 et 09.
- Les liens vers une page de PDF s'écrivent `[[Sujet.pdf#page=3|ouvrir la page 3]]`, et une page s'intègre avec `![[Sujet.pdf#page=1]]`. Attention : le numéro imprimé sur la page est souvent différent du numéro de page du PDF. Vérifie le décalage.
- Callouts Obsidian :
  - `> [!abstract]` pour le résumé ;
  - `> [!warning]` pour les pièges et les règles ;
  - `> [!todo]` pour une case à remplir ;
  - `> [!info]` et `> [!note]` pour les explications ;
  - `> [!question] À toi` pour une question de réflexion ;
  - `> [!question]- Coup de pouce` pour un indice replié (le `-` replie le callout).
- Les schémas sont en mermaid (`flowchart LR` pour une chaîne, `flowchart TD` pour l'ordre des blocs).
- Les formules sont en LaTeX : `$…$` dans le texte, `$$…$$` en bloc.
- Les phrases sont courtes, en français simple, avec des listes et des tableaux plutôt que des pavés.

## Note par note

### 00 - Accueil
- `> [!abstract] Le projet en une phrase`
- `> [!warning] La règle de ce coffre`. En mode guidé, elle dit : « Il n'y a aucune réponse ici. Les notes montrent le système, le chemin et les pièges. Les calculs et les choix restent à toi. »
- **Par où commencer** : 3 ou 4 étapes numérotées (animation si elle existe, puis données, premiers pas, brouillon).
- **Toutes les notes** : un tableau `| Note | À quoi elle sert |` avec un lien `[[…]]` par note.
- **Documents** : un lien vers chaque fichier de `Documents/`, en précisant le nombre de pages.
- S'il y a une animation, ses captures sont intégrées en bas de la note (`![[scene1-….png]]`).

### 01 - Le projet en clair
- Le contexte en quelques phrases, avec la 1re page du sujet intégrée.
- Le déroulement (le cycle, le processus) en liste numérotée.
- La chaîne technique en `flowchart LR`.
- **Ce que tu dois produire** : la liste des livrables ou des choix à faire.
- **Les blocs** de travail en `flowchart TD`, avec les questions de chaque bloc et l'ordre imposé (« tu ne peux pas commencer par… »).
- Un `[!question] À toi` sur un point subtil du sujet.

### 02 - Les N questions
- Des cases à cocher `- [ ] **Q1** intitulé résumé`, regroupées par bloc (`## Bloc 1 — …`).
- Le lien vers les pages du sujet où se trouvent les énoncés complets.
- Le binôme coche au fur et à mesure : c'est le suivi d'avancement commun.

### 03 - Mes données
- `> [!todo] Ma feuille` (ou mon jeu de données), à compléter.
- Si le tableur contient plusieurs jeux de données, toutes les feuilles sont recopiées dans un tableau.
- Les données qui sont seulement dans le sujet (pas dans le tableur).
- Le tableau à remplir : quelles lignes du tableur appartiennent à quel bloc.
- Des `[!warning]` sur les incohérences entre le tableur et le sujet.

### 04 - Premiers pas
- Environ 7 étapes. Pour chacune : un titre, une case à cocher, puis un `> [!question]- Coup de pouce` replié qui pose une question au lieu de donner la réponse.
- Une étape de contrôle, avant d'avancer, sur les ordres de grandeur et la cohérence.
- **Quand tu bloques** : écrire ce qu'on a essayé, vérifier les unités puis les signes, montrer sa démarche à Claude.

### 05 - Mon brouillon
- « Cette note est à toi : rien n'y est pré-rempli. »
- **Mes hypothèses** : `| Sujet | Mon choix | Pourquoi | Validé par le prof ? |`, avec les questions ouvertes déjà listées.
- Une section par question ou par groupe de questions, avec des intitulés vides (« En lettres : », « En nombres : », « Unité : »).
- **Mes choix de matériel** : `| Composant | Référence | Fournisseur | Critères vérifiés |`, s'il y a des choix de matériel.
- **Journal** : une liste datée.

### 06 - Formulaire du sujet
- Toutes les formules du sujet en LaTeX, regroupées par thème, avec leur repère d'origine ([M1], p.9…).
- **Sans application numérique.** « À toi de décider laquelle s'applique. En cas de doute, le PDF fait foi. »

### 07 - Pièges et questions au prof
- **À demander au prof** : des cases à cocher, dont la date et le format du rendu s'ils ne sont pas donnés, et chaque ambiguïté du sujet.
- **Pièges pour la suite** : un `> [!warning]` par piège, écrit comme une question.

### 08 - Repères dans le poly
- Un tableau `| Pour | Où | Lien |`, avec des liens vers la bonne page du PDF.
- Préciser le décalage entre la page imprimée et la page du PDF.
- Un `[!question] À toi` qui relie un TD ou un TP au projet.

### 09 - Travailler à deux
- Copie de `modele/09 - Travailler à deux.md`, avec `{{DEPOT_URL}}` (ex. `https://github.com/pseudo/depot`, sans `.git`) et `{{NOM_DOSSIER}}` remplacés.

## Mode guidé ou mode normal

- **Guidé** (le choix par défaut pour un projet noté) : le coffre ne contient aucun résultat. Les notes 04 et 06 posent des questions. Quand on demande de l'aide à Claude, il relance par des questions sans donner le résultat, sauf si l'utilisateur demande explicitement la réponse.
- **Normal** : les notes peuvent contenir des réponses et des résultats. On retire la phrase « aucune réponse ici » de l'accueil, et on supprime les coups de pouce qui n'ont plus de sens.
