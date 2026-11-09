# Rangement du coffre

Ce rangement vient du coffre de la SAÉ VV3 d'IUT, monté par Raphaël et affiné au fil de la première séance. On l'adapte à chaque projet, mais on garde la logique :
- **trois zones**, chacune avec ses règles d'écriture ;
- **une couleur et une étiquette par personne**, pour voir d'un coup d'œil qui a écrit quoi ;
- **des pages communes qui se remplissent seules** : on n'écrit jamais deux fois la même chose.

| Zone | Contenu | Qui écrit |
|---|---|---|
| `Guide/` | La méthode : comprendre le projet, les données, les formules, l'aide | Personne sans prévenir les autres |
| `Équipe/` | Le commun : répartition, décisions, avancement, questions au prof, et des pages qui en rassemblent d'autres | Tout le monde, selon `Répartition`. Les pages assemblées, personne |
| `Espaces/<pseudo>/` | Le travail perso : réponses, brouillon, journal, tableur | Seulement le propriétaire. `SYNC.bat` bloque les modifs dans l'espace d'un autre |

## L'arborescence

```text
<Nom du projet>/
├── 00 - Accueil.md                     la seule note à la racine, courte
├── CLAUDE.md                           renvoie vers le skill du projet           (modele/CLAUDE.md)
├── .claude/skills/<slug>/SKILL.md      le skill de séance du projet              (modele/skill-projet/)
├── equipe.json                         membres, étiquettes, couleurs, tableur    (modele/equipe.json)
├── .obsidian/snippets/couleurs-equipe.css   la seule partie de .obsidian partagée (modele/couleurs-equipe.css)
├── Guide/
│   ├── 01 - Le projet en clair.md
│   ├── 03 - Mes données.md
│   ├── 04 - Premiers pas.md
│   ├── 06 - Formulaire du sujet.md     (ou « Références »)
│   ├── 08 - Repères dans le poly.md    (ou « Repères dans les cours »)
│   ├── 09 - Travailler à deux.md       (modele/Guide/)
│   └── 10 - Aide aux calculs.md        des indices par paliers sur un cas inventé
├── Équipe/
│   ├── 02 - Les N questions.md         cases à cocher + étiquette de qui a validé
│   ├── 07 - Pièges et questions au prof.md
│   ├── Répartition.md                  (modele/Équipe/)
│   ├── Décisions communes.md           (modele/Équipe/)
│   ├── Réponses.md                     assemblée : les réponses de chacun, question par question
│   ├── Tableurs.md                     assemblée : les aperçus des tableurs
│   ├── Ce qu'on a fait.md              assemblée : les journaux
│   └── Activité.md                     refaite par SYNC.bat chez chacun, jamais envoyée (.gitignore)
├── Espaces/<pseudo>/
│   ├── Réponses <pseudo>.md            une section par question, avec son état
│   ├── Brouillon <pseudo>.md           page libre pour chercher
│   ├── Journal <pseudo>.md
│   ├── Tableur <pseudo>.xlsx           copie du tableur d'origine
│   └── Tableur <pseudo> - aperçu.md    refait par SYNC.bat à partir du .xlsx
├── Documents/                          les sources reçues, à garder intactes
├── Animation/                          facultatif : animation-<slug>.html
├── SYNC.bat · sync-obsidian.ps1 · tableur-vers-note.ps1
└── .gitignore · .gitattributes         (modele/gitignore.txt, modele/gitattributes.txt)
```

- **Les pseudos** sont les pseudos GitHub, écrits exactement pareil dans les dossiers, les noms de fichiers et `equipe.json`.
- **Les étiquettes** sont courtes et en minuscules, par exemple `#glm02` ou `#paul` (un prénom passe très bien). Elles servent à la fois de tag Obsidian, de classe CSS `espace-<etiquette>` et de callout `[!<etiquette>]`.
- Les notes gardent leur numéro d'origine, même rangées dans des zones différentes. Obsidian trouve un lien `[[…]]` quel que soit le dossier, à condition que les noms de notes soient **uniques** dans tout le coffre. C'est pour ça que les fichiers perso portent le pseudo dans leur nom.
- `Documents/` contient des noms courts et lisibles. Le tableur d'origine reste intact, et chaque espace en a sa copie.

## L'automatique (fait par SYNC.bat)

| Quoi | Comment |
|---|---|
| Aperçu du tableur | `tableur-vers-note.ps1` lit **son propre** `.xlsx`, sans avoir besoin d'Excel, et écrit `Tableur <pseudo> - aperçu.md`. Il n'affiche que les feuilles modifiées par rapport au tableur d'origine. Il ne touche jamais au tableur d'un autre |
| Page Activité | Elle est refaite d'après les 20 derniers commits : un encadré `[!etiquette]` par envoi, avec les fichiers touchés. Elle est locale et ignorée par git, donc sans conflit possible |
| Couleurs | La feuille `couleurs-equipe.css` est activée dans `.obsidian/appearance.json`. Il faut ensuite redémarrer Obsidian une fois |
| Console | Les envois des autres s'affichent dans leur couleur |

Les pages `Réponses`, `Tableurs` et `Ce qu'on a fait` ne demandent aucun script : ce sont des **intégrations** Obsidian (`![[Note#Section]]`), qui se mettent à jour toutes seules.

## Les étiquettes et les états

- **Qui** : l'étiquette de la personne (`#glm02`, `#paul`…).
- **État** : `#a-faire`, `#en-cours`, `#a-relire`, `#valide`, chacun avec sa couleur dans le CSS.
- **Valider une tâche** : on coche `- [x]` dans `Équipe/02` et on ajoute **son étiquette au bout de la ligne**, ce qui montre qui l'a validée : `- [x] **Q2** Calculer le rapport KT #glm02`.
- Dans `Répartition`, la colonne État contient un tag d'état. Les colonnes Responsable et Relecteur contiennent une étiquette.
- Dans `Décisions communes`, la colonne « Décidé par » contient une étiquette.

## Les conventions communes

- Le titre `# …` reprend le nom de la note. Il est **en début de ligne**, sans espace ni tabulation devant.
- Les notes perso commencent par un frontmatter `cssclasses: [espace-<etiquette>]`, qui colore leur titre.
- La 2e ligne est `Retour à [[00 - Accueil]]`, éventuellement suivie de ` · [[Répartition]]` ou d'un lien vers la note assemblée.
- Les pages assemblées disent « Cette page se remplit toute seule : n'écris rien ici », suivi de la légende des couleurs.
- Les liens vers une page de PDF s'écrivent `[[Sujet.pdf#page=3|…]]`. Le numéro imprimé sur la page diffère souvent du numéro de page du PDF : note le décalage.
- Callouts :
  - `[!warning]` pour les pièges et les règles ;
  - `[!tip]` pour un conseil ;
  - `[!question] À toi` pour une question de réflexion ;
  - `[!question]- Palier N` pour un indice replié ;
  - `[!example]-` pour un exemple replié ;
  - `[!check]-` pour une vérification repliée.
- Schémas en mermaid, formules en LaTeX, phrases courtes, listes et tableaux.
- « Vous » dans `Équipe/` et l'accueil, « tu » dans le `Guide/` et les espaces.

## Note par note

### 00 - Accueil (racine, courte)
```markdown
# <Projet> — <sous-titre>

<Une ou deux phrases : ce qu'il faut faire.> Ce coffre guide sans donner les réponses.   ← en mode guidé

## Chaque séance
1. **En arrivant :** `SYNC.bat`
2. **Pendant :** écris dans ton espace (`Espaces`)
3. **En partant :** une ligne dans ton journal, puis `SYNC.bat`

## L'équipe
- [[Réponses]] : vos réponses, question par question
- [[Tableurs]] : vos tableurs
- [[Répartition]] : qui fait quoi
- [[Ce qu'on a fait]] : vos journaux
- [[Activité]] : qui a modifié quoi
- [[Décisions communes]] : les choix à faire pareil
- [[02 - Les N questions]] : l'avancement
- [[07 - Pièges et questions au prof]] : à surveiller et à demander

## L'aide
- [[10 - Aide aux calculs]] : si tu bloques sur un calcul
- [[04 - Premiers pas]] : par où commencer
- [▶ Animation du projet](Animation/animation-<slug>.html)   ← s'il y en a une
- Le reste est dans `Guide` et `Documents`
```
Pas de captures d'écran ni de grands tableaux : l'accueil doit tenir sur un écran.

### Guide/01 - Le projet en clair
- Le contexte, avec la 1re page du sujet intégrée.
- Le déroulement en liste numérotée.
- La chaîne technique en `flowchart LR`.
- **Ce que tu dois produire.**
- **Les blocs** en `flowchart TD`, avec l'ordre imposé.
- Un `[!question] À toi`.

### Guide/03 - Mes données
- `> [!todo] Ma feuille` : la noter en haut de son brouillon, et dire dans [[Décisions communes]] si vous avez la même.
- Tous les jeux de données recopiés, les données qui sont seulement dans le sujet, et quelles lignes du tableur appartiennent à quel bloc.
- Des `[!warning]` sur les incohérences.

### Guide/04 - Premiers pas
- Environ 7 étapes. Pour chacune : une case à cocher, puis `[!question]- Coup de pouce`.
- L'étape « préparer ton fichier » : ouvrir le tableur de son espace.
- **Quand tu bloques** : renvoi vers [[10 - Aide aux calculs]].

### Guide/06 - Formulaire du sujet
- Toutes les formules en LaTeX, avec leur repère, **sans application**.

### Guide/08 - Repères dans le poly
- Un tableau `| Pour | Où | Lien |`, avec le décalage entre page imprimée et page du PDF.

### Guide/09 - Travailler à deux
- Copie de `modele/Guide/09 - Travailler à deux.md`, avec `{{DEPOT_URL}}`, `{{NOM_DOSSIER}}`, `{{SLUG}}`, `{{LEGENDE}}` et `{{ETIQUETTES_CODE}}` remplacés.

### Guide/10 - Aide aux calculs
- `[!warning] Comment utiliser cette note` : déplier un palier seulement si le précédent ne suffit pas. Les exemples portent sur un **cas inventé**, dont les valeurs ne figurent dans aucun jeu de données.
- **La méthode** : ce qu'on cherche avec son unité, la relation, le calcul en lettres, puis les nombres et le contrôle.
- Pour chaque question de calcul, des paliers repliés :
  - `Palier 1 : comprendre l'image` ;
  - `Palier 2 : repérer…` ;
  - `Palier 3 : le faire en lettres` ;
  - `[!example]- Palier 4 : exemple complet sur un autre cas` ;
  - puis `[!check]- Ton résultat est-il plausible ?`.
- **Dans le tableur** : taper `=`, cliquer sur les cases, bloquer avec F4, vérifier à la calculatrice.

### Équipe/02 - Les N questions
- « Coche au fur et à mesure et ajoute ton étiquette à la fin de la ligne. »
- Des cases à cocher `- [ ] **Q1** intitulé résumé`, regroupées par bloc. Ces intitulés sont les mêmes que dans `Réponses`.

### Équipe/07 - Pièges et questions au prof
- **À demander au prof** (cases à cocher) et **Pièges pour la suite** (`[!warning]`).

### Équipe/Répartition, Décisions communes, Ce qu'on a fait, Tableurs, Réponses
Elles partent des modèles de `modele/Équipe/`.
- `{{LEGENDE}}` : « Bleu pour glm02, orange pour Paul. », d'après `equipe.json`.
- `{{ETIQUETTES_CODE}}` : `` `#glm02` ou `#paul` ``.
- `{{LIGNES_BLOCS}}` : une ligne `| 1. Nom du bloc | Q1 à Q6 | | | #a-faire |` par bloc.
- `{{LIGNES_DECISIONS}}` : une ligne `| <hypothèse ouverte> | | | | |` par choix commun (jeu de données, ambiguïtés du sujet, constantes non données, fournisseurs).
- `{{JOURNAUX_INTEGRES}}` : `![[Journal <pseudo>]]` pour chaque membre, séparés par `---`.
- `{{APERCUS_INTEGRES}}` : `![[Tableur <pseudo> - aperçu]]` pour chaque membre, séparés par `---`.
- `{{LIENS_REPONSES}}` : `[[Réponses a]] ou [[Réponses b]]`.
- `{{QUESTIONS_INTEGREES}}` : pour chaque bloc, `## Bloc N — Nom`. Puis, pour chaque question, `### QN — intitulé`, suivi d'une ligne `![[Réponses <pseudo>#QN]]` par membre, séparées par une ligne vide.

### Espaces/<pseudo>/
Chaque espace part des modèles de `modele/Espaces/`, avec `{{PSEUDO}}` et `{{ETIQ}}` remplacés.
- **Réponses <pseudo>.md** : `{{QUESTIONS}}` contient, pour chaque bloc, `## Bloc N — Nom`. Puis, pour chaque question :
  ```markdown
  ### QN

  *intitulé résumé*

  État : #a-faire

  Ma réponse :
  ```
  Le titre de section est exactement `### QN`, parce que c'est la cible de `![[Réponses <pseudo>#QN]]`.
- **Brouillon <pseudo>.md** : une page libre. `{{LIGNE_VALEURS}}` contient « Ma feuille : **___** ; » suivi d'un `___` par donnée du jeu.
- **Journal <pseudo>.md** : le titre est en `###`, pour s'intégrer proprement dans « Ce qu'on a fait ».
- **Tableur <pseudo>.xlsx** : une copie du tableur d'origine. L'aperçu se crée à la première synchro de la personne.

### equipe.json et couleurs-equipe.css
- `equipe.json` contient `tableurOrigine` (chemin relatif, ou `""` s'il n'y a pas de tableur), puis un objet par membre : `espace`, `etiquette`, `couleur`, `hex` et `console`.
- Palette, dans l'ordre :
  1. bleu `#4a9eff` / `Cyan` ;
  2. orange `#ff9340` / `DarkYellow` ;
  3. vert `#34d399` / `Green` ;
  4. rose `#f472b6` / `Magenta`.
- `couleurs-equipe.css` : remplacer `{{PSEUDOn}}`, `{{ETIQn}}` et `{{LEGENDE}}`. Pour un 3e membre, dupliquer chaque ligne marquée 2.

## Mode guidé ou mode normal

- **Guidé** (le choix par défaut pour un projet noté) : aucun résultat dans le coffre, et le skill du projet met Claude en mode prof. Il répond par des questions, vérifie la démarche sans donner la valeur juste, fait ses démonstrations sur un cas inventé, et laisse les choix de matériel aux étudiants.
- **Normal** : le coffre peut contenir des réponses, et Claude calcule en expliquant chaque étape.
