# Travailler à deux sur ce coffre

Retour à [[00 - Accueil]]

Le coffre est stocké sur GitHub. Quand l'un de vous double-clique sur `SYNC.bat`, ses modifications partent. Quand l'autre fait pareil, il les reçoit, et Obsidian les affiche tout de suite.

## La routine

1. **En arrivant** : double-clic sur `SYNC.bat`.
2. **En partant** : attends 2 ou 3 secondes après ta dernière frappe, puis double-clic sur `SYNC.bat`.
3. Préviens ton binôme : « j'ai synchronisé ».

Obsidian peut rester ouvert. Par contre, **ferme Excel** (ou Word) avant de synchroniser si tu as ouvert un de ces fichiers.

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
7. **Vérifier** : à gauche, tu dois voir les notes `00 - Accueil` à `09 - Travailler à deux`. Si le coffre est vide, c'est que le mauvais dossier est ouvert : recommence l'étape 6.
8. **Premier `SYNC.bat`** : dans `Documents\{{NOM_DOSSIER}}`. Il demande ton prénom pour l'historique, et une fenêtre GitHub peut s'ouvrir la première fois : *Sign in with your browser*.

Astuce : clic droit sur `SYNC.bat`, *Envoyer vers*, *Bureau (créer un raccourci)*.

## Les messages de SYNC.bat

| Message | Ce que ça veut dire | Que faire |
|---|---|---|
| `Tout est à jour sur GitHub` | Tout s'est bien passé | Rien |
| `CONFLIT` | Vous avez modifié le même fichier non fusionnable, comme un tableur. Ton dossier a pris sa version, la tienne est sauvegardée sur GitHub | Choisissez ensemble quoi garder |
| `fichiers ont disparu du dossier` | Beaucoup de fichiers manquent d'un coup. Rien n'a été envoyé | Vérifiez le dossier ensemble |
| `Impossible de joindre GitHub` | Pas d'internet, ou pas d'accès au dépôt | Vérifie ta connexion et l'invitation |
| `Envoi impossible` | L'invitation n'est pas acceptée | Refais l'étape 2 |

## Les règles

- **Chacun son tableur.** Excel ne se fusionne pas : faites chacun votre copie, avec votre prénom dans le nom du fichier.
- **Le même endroit d'une note ?** Les deux versions sont gardées à la suite. Rien n'est perdu, il reste à faire le tri.
- **Dépôt privé.** Les documents des profs (sujet, poly) ne doivent pas devenir publics.
- **Pas de données personnelles ni de mots de passe** dans les notes.
