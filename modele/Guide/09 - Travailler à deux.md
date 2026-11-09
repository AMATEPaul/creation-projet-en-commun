# Travailler à deux sur ce coffre

Retour à [[00 - Accueil]]

Le coffre est stocké sur GitHub. Quand l'un de vous double-clique sur `SYNC.bat`, ses modifications partent. Quand l'autre fait pareil, il les reçoit, et Obsidian les affiche tout de suite.

## La routine

La routine est dans [[00 - Accueil]], et les droits d'écriture dans [[Répartition]]. Obsidian peut rester ouvert pendant la synchronisation. Par contre, **ferme Excel** (ou Word) si tu as ouvert un fichier du coffre.

> [!warning] Ce n'est pas instantané
> Les modifications n'arrivent chez l'autre que lorsqu'il lance `SYNC.bat` à son tour. Ce n'est pas comme un Google Docs.

> [!warning] Le bon SYNC.bat
> Lance toujours le `SYNC.bat` **qui est dans le coffre**. Une copie seule, téléchargée ailleurs (par exemple dans Téléchargements), ne fait rien, parce qu'elle a besoin de `sync-obsidian.ps1` à côté d'elle.

## Installation pour le binôme (une seule fois)

1. **Créer un compte** sur https://github.com/signup et envoyer son pseudo à la personne qui a créé le dépôt.
2. **Accepter l'invitation** reçue par email (*View invitation*, puis *Accept invitation*), ou sur {{DEPOT_URL}}/invitations
3. **Installer Git** depuis https://git-scm.com/download/win, en gardant toutes les options par défaut.
4. **Installer Obsidian** depuis https://obsidian.md/download.
5. **Récupérer le coffre** : touches `Windows + R`, taper `cmd`, Entrée, puis coller cette ligne :

   ```
   git clone {{DEPOT_URL}}.git "%USERPROFILE%\Documents\{{NOM_DOSSIER}}"
   ```

6. **Ouvrir le coffre** : dans Obsidian, *Gérer les coffres*, puis *Ouvrir un dossier en tant que coffre*. Va dans *Ce PC > C: > Utilisateurs > ton nom > Documents*, sélectionne `{{NOM_DOSSIER}}` **sans entrer dedans**, puis clique sur *Sélectionner un dossier*. Attention : le « Documents » de OneDrive n'est pas le bon. Si Obsidian le demande, confirme que tu fais confiance à l'auteur du coffre.
7. **Vérifier** : à gauche, tu dois voir `00 - Accueil` et les dossiers `Guide`, `Équipe` et `Espaces`. Si le coffre est vide, c'est que le mauvais dossier est ouvert : recommence l'étape 6.
8. **Premier `SYNC.bat`** : dans `Documents\{{NOM_DOSSIER}}`. Il demande ton prénom pour l'historique (sauf si Git le connaît déjà), puis ton espace. Une fenêtre GitHub peut s'ouvrir la première fois : *Sign in with your browser*.

Astuce : clic droit sur `SYNC.bat`, *Envoyer vers*, *Bureau (créer un raccourci)*.

## Les messages de SYNC.bat

| Message | Ce que ça veut dire | Que faire |
|---|---|---|
| `Tout est à jour sur GitHub` | Tout s'est bien passé | Rien |
| `CONFLIT` | Vous avez modifié le même fichier non fusionnable, comme un tableur. Ton dossier a pris sa version, la tienne est sauvegardée sur GitHub | Choisissez ensemble quoi garder |
| `Tu as modifié l'espace de…` | Tu as changé un fichier dans l'espace de l'autre. Sauf si tu confirmes, rien n'est envoyé | Déplace ta modification dans ton espace |
| `fichiers ont disparu du dossier` | Beaucoup de fichiers manquent d'un coup. Rien n'a été envoyé | Vérifiez le dossier ensemble |
| `Impossible de joindre GitHub` | Pas d'internet, ou pas d'accès au dépôt | Vérifie ta connexion et l'invitation |
| `Envoi impossible` | L'invitation n'est pas acceptée | Refais l'étape 2 |

## Les règles

- **Chacun son tableur**, dans son espace : Excel ne se fusionne pas.
- **Le même endroit d'une note commune ?** Les deux versions sont gardées à la suite. Rien n'est perdu, il reste à faire le tri.
- **Dépôt privé.** Les documents des profs (sujet, poly) ne doivent pas devenir publics.
- **Pas de données personnelles ni de mots de passe** dans les notes.
- **Pas de Google Drive ni de OneDrive sur ce dossier** : leur synchronisation peut abîmer le dépôt.

## Les couleurs

- **{{LEGENDE}}** Elles apparaissent dans la liste des fichiers, les journaux, les réponses et la page [[Activité]].
- **Pour les activer :** lance `SYNC.bat`, ferme Obsidian puis rouvre-le. Si elles n'apparaissent pas, relance `SYNC.bat` et recommence, ou active-les dans *Réglages*, *Apparence*, *Extraits CSS*, `couleurs-equipe`.
- **Étiquettes :** écris {{ETIQUETTES_CODE}}, `#a-faire`, `#en-cours`, `#a-relire` ou `#valide`. Quand tu coches une tâche, ajoute ton étiquette au bout de la ligne : on voit qui l'a validée.

## Le tableur dans Obsidian

À chaque `SYNC.bat`, ton tableur enregistré est recopié dans la note [[Tableurs]], avec seulement les feuilles que tu as modifiées. Le sens est unique : tu écris dans le tableur, jamais dans la note.

## Avec Claude Code

Ouvre Claude Code dans ce dossier : le skill `{{SLUG}}` du dépôt s'applique à vous deux. Il fait le point en début de séance, guide sans donner les résultats et tient ton journal. Pour l'appeler : `/{{SLUG}}`.
