---
name: {{SLUG}}
description: Séance de travail à deux sur le coffre {{NOM_PROJET}} ({{SUJET_COURT}}). À utiliser pour démarrer ou finir une séance, aider sur une question, vérifier un calcul, noter l'avancement, répartir le travail ou synchroniser.
---

# {{NOM_PROJET}} à deux

{{MEMBRES_PHRASE}} partagent ce coffre Obsidian par GitHub. {{ROLE_CLAUDE}}

## Démarrer

1. Lance `git pull --rebase`. S'il échoue, signale-le et attends avant de modifier quoi que ce soit.
2. Identifie la personne avec `git config coffre.espace`, sinon `git config user.name`. Si aucun ne correspond à un dossier de `Espaces/`, demande-lui qui elle est.
3. Lis `Équipe/Répartition.md`, `Équipe/Décisions communes.md` et le haut des journaux de `Espaces/`.

C'est fait quand tu as donné en quelques lignes : ce que l'autre a fait depuis, ce que cette personne a à faire, et la prochaine étape.

## Pendant : {{TITRE_MODE}}

{{REGLES_MODE}}

Fonde chaque réponse sur les documents de `Documents/` : {{DOCUMENTS_LISTE}}.{{DECALAGE_POLY}} Si le sujet est ambigu, dis-le et renvoie vers le prof.

## Où écrire

La section « Qui écrit où » de `Équipe/Répartition.md` fait foi. Écris dans l'espace de la personne en face de toi. Pour modifier un fichier que cette section réserve à l'autre, ou le `Guide`, obtiens d'abord son accord explicite et rappelle-lui de prévenir son binôme.

Signe ce qui est fait avec l'étiquette de la personne ({{ETIQUETTES_CODE}}, voir `equipe.json`), et l'état avec `#a-faire`, `#en-cours`, `#a-relire` ou `#valide`. Une tâche cochée dans `Équipe/02` porte l'étiquette de celui qui l'a validée au bout de la ligne. `Équipe/Activité.md` est refaite par la synchro : lis-la pour voir qui a modifié quoi, sans y écrire.

Les réponses vont dans `Espaces/<personne>/Réponses <personne>.md`, sous la question concernée. `Équipe/Réponses.md` les réunit toutes seules : n'y écris rien.

`Espaces/<personne>/Tableur <personne> - aperçu.md` est refait par la synchro à partir du `.xlsx` : lis-le pour voir ses valeurs, et fais écrire dans le `.xlsx`.

Une hypothèse qui concerne les deux va dans `Équipe/Décisions communes.md`. Une question pour le prof va dans `Équipe/07 - Pièges et questions au prof.md`.

## Finir

1. Ajoute en haut du journal de la personne une entrée datée : **Fait**, **À vérifier par l'autre**, **Prochaine étape**.
2. Relis `git status` : chaque fichier doit appartenir à ce qu'elle a le droit de modifier.
3. Avec son accord, lance `powershell -NoProfile -ExecutionPolicy Bypass -File sync-obsidian.ps1 -NoPause`.

C'est fait quand le script affiche « Tout est à jour sur GitHub ». Rappelle alors que l'autre recevra tout à son prochain `SYNC.bat`.

## Garde-fous

- Le dépôt reste privé : il contient les documents des profs.
- Garde les données personnelles et les mots de passe hors du dépôt.
- Le coffre vit hors de Google Drive et de OneDrive : leur synchronisation peut abîmer `.git`. Si un dossier `.tmp.driveupload` apparaît, préviens la personne.
- Si `SYNC.bat` signale un conflit, la version de l'autre est dans le dossier et l'autre version dans une branche `sauvegarde-…` sur GitHub : montre-leur les deux et laisse-les choisir.
