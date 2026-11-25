# Maison Claire : page de débarras (Seine-et-Marne)

Site statique, sans framework ni dépendance. Tout le dossier se dépose tel quel à la racine du domaine `https://maisonclaire-debarras.fr/`.

```
index.html          page complète (CSS, JS et JSON-LD intégrés)
logo.svg            logo, version claire (texte vectorisé, sans dépendance de police)
logo-dark.svg       logo, version sombre (fonds foncés)
favicon.svg
fonts/              Fraunces 600, Inter 400 et 600 (woff2, sous-ensemble latin)
img/                karim-*, camion-*, protection-*, piece-vide-* (WebP, 2 tailles chacune), og.jpg, apple-touch-icon.png
robots.txt  sitemap.xml  llms.txt
```

## 1. Déploiement (Cloudflare Pages, gratuit)

- Projet Pages : `maisonclaire` → https://maisonclaire.pages.dev/ (cette adresse technique renvoie `X-Robots-Tag: noindex`, voir `_headers` ; le domaine final, lui, est indexable).
- Déployer : `CLOUDFLARE_ACCOUNT_ID=… CLOUDFLARE_API_TOKEN=… ./deploy.sh`. Seuls les fichiers publics partent (pas les `.md` ni le script).
- `_headers` : sécurité (nosniff, Referrer-Policy, Permissions-Policy, pas de CSP) et cache (page revalidée, polices 1 an immutable, images 1 an : **pour remplacer une image, changer son nom de fichier**).
- `404.html` : vraie page 404 (sans elle, Pages renverrait la page d'accueil en 200 sur toute adresse inconnue).
- Domaine : ajouter `maisonclaire-debarras.fr` comme zone Cloudflare, mettre les serveurs de noms Cloudflare chez le registraire, rattacher le domaine nu au projet Pages, puis : « Always Use HTTPS » activé et une règle de redirection 301 `www.maisonclaire-debarras.fr/*` → `https://maisonclaire-debarras.fr/${1}`.
- Vérifier : `curl -I https://maisonclaire-debarras.fr/` doit répondre `200`, sans redirection ni `x-robots-tag`. C'est l'URL finale des annonces.

**Formulaire : Formspree (offre gratuite, sans pièces jointes).** L'adresse d'envoi est dans l'attribut `action` du `<form id="form-devis">` : remplacer `FORMSPREE_ID` par l'identifiant du formulaire (`https://formspree.io/f/xxxxxxxx`). Tant que ce n'est pas fait, chaque envoi affiche le message d'erreur avec téléphone et WhatsApp. Envoi en JavaScript (`fetch`, `Accept: application/json`) ; sans JavaScript, le navigateur poste directement à Formspree. Anti-spam : champ caché `_gotcha`. Les photos et vidéos passent par WhatsApp.

## 2. Réglages (bloc `CONFIG`, en bas de `index.html`)

| Clé | Rôle |
|---|---|
| `gtmId` | ID Google Tag Manager (`GTM-XXXXXXX`). Vide = aucune bannière, aucun suivi. Renseigné = bannière de consentement, puis GTM chargé seulement après « Accepter ». |
| `trackingPhone` | Numéro de suivi d'appels, ex. `{display:'01 00 00 00 00', e164:'+33100000000'}`. Remplace le numéro **uniquement** pour les visiteurs venus d'une annonce (gclid présent). Le vrai numéro reste dans le HTML, le JSON-LD et la fiche Google. |

## 3. Google Ads

**URL finales (une page = une intention, canonique inchangée) :**
- `https://maisonclaire-debarras.fr/` : H1 « Débarras de maison en Seine-et-Marne »
- `https://maisonclaire-debarras.fr/?v=succession` : H1 « Débarras de maison après un décès en Seine-et-Marne »
- `https://maisonclaire-debarras.fr/?v=appartement` : H1 « Débarras d'appartement en Seine-et-Marne » (et « Vous filmez l'appartement » dans le sous-titre)

**Événements `dataLayer` :**

| Événement | Quand | Paramètres |
|---|---|---|
| `call_click` | clic sur un lien `tel:` | `link_location` (entete, heros, prix, formulaire, pied, barre_mobile, erreur_formulaire) |
| `whatsapp_click` | clic sur un lien WhatsApp | `link_location` |
| `form_submit` | envoi **réussi** du formulaire (réponse OK de Formspree) | `variant` |

Dans GTM : un déclencheur « Événement personnalisé » par événement, relié à une balise de conversion Google Ads, avec le « Conversion Linker ». Conversions principales conseillées : `form_submit` et `call_click` (un clic n'est pas un appel abouti : si possible, mesurer aussi les appels réels via le numéro de suivi).

**Champs cachés du formulaire :** `gclid`, `gbraid`, `wbraid`, `v`, `utm_source`, `utm_medium`, `utm_campaign`, `utm_term`, `utm_content`, `consentement_mesure` (oui / non). N'importez un gclid en conversion hors ligne que si `consentement_mesure = oui`.

## 4. Consentement

- Consent Mode v2 : `ad_storage`, `ad_user_data`, `ad_personalization`, `analytics_storage` à `denied` par défaut (en tête de page, avant tout script).
- Bannière : « Refuser » et « Accepter » de même taille et même style. Fermer ou faire défiler ne vaut pas accord. Choix conservé 6 mois, modifiable via « Pied de page > Cookies > Modifier mes choix ».
- Aucun script de suivi chargé avant le choix. Refus = rien n'est chargé et les cookies `_ga`, `_gcl` éventuels sont supprimés.
- Si vous ajoutez d'autres outils (pixel Meta, chat…), passez à une CMP complète (ex. tarteaucitron.js, gratuit) plutôt que d'étendre cette bannière.

## 5. Garanties G1 à G8

Texte officiel, repris mot pour mot dans la section « Le risque est pour nous, pas pour vous », dans la carte de prix (G2), dans la FAQ et dans `llms.txt`. Le héros en affiche 3 résumés courts, validés. Pour modifier une garantie, la changer **partout** : rechercher `data-g="G` dans `index.html`, puis la FAQ et `llms.txt`.

## 6. À remplacer avant mise en ligne

Toutes ces valeurs sont surlignées en jaune (`data-demo`). Après remplacement, supprimer l'attribut `data-demo` : la recherche `data-demo` dans `index.html` doit renvoyer 0 résultat. Aucune n'est dans le JSON-LD.

| Valeur d'exemple | Où |
|---|---|
| Prénom du responsable terrain « Julien » | Étape 2 |
| E-mail `contact@maisonclaire-debarras.fr` | Mentions légales, Confidentialité |
| Assureur et n° RC pro « MMA IARD, contrat n° 145 678 901 » | FAQ « Êtes-vous assurés ? », pied de page, mentions légales |
| Médiateur « CM2C, 49 rue de Ponthieu, 75008 Paris » | Pied de page, rubrique Médiateur |
| Mention TVA « TVA non applicable, article 293 B du CGI » | Pied de page, mentions légales |
| Adresse du siège « 12 rue de la République, 77100 Meaux » | Mentions légales |
| Date de mise à jour « 25 novembre 2026 » | Fin de la FAQ (texte **et** attribut `datetime`) ; reporter la date dans `sitemap.xml` |
| Forme juridique, directeur de la publication | Mentions légales (ajoutés car obligatoires) |

**Sections masquées** (`hidden`) : « Avant / après » et « Avis Google ». Ne retirer `hidden` qu'avec de vraies photos (accord écrit du client) et de vrais avis Google copiés mot pour mot. Ne jamais ajouter `AggregateRating` ni `Review` au JSON-LD.

## 7. Check-list de lancement

- [ ] Valeurs d'exemple remplacées, `data-demo` = 0 résultat
- [ ] Fiche Google : même nom, même numéro, zone de service = mêmes communes, adresse masquée
- [ ] Un vrai envoi de formulaire, notification Formspree reçue sur le téléphone
- [ ] Liens Appeler et WhatsApp testés sur un vrai téléphone (Android et iPhone)
- [ ] GTM en mode Aperçu : consentement `denied` au chargement, aucune balise avant le choix, les 3 événements remontent
- [ ] `curl -I` sur les 3 URL finales : `200`, pas de redirection
- [ ] Search Console : domaine validé, `sitemap.xml` envoyé
- [ ] Lighthouse mobile relancé sur l'URL de production ; données terrain (CrUX / Search Console) à lire après environ 28 jours de trafic
- [ ] Si le texte change : mettre à jour la date « mises à jour le », `sitemap.xml` et `llms.txt` en même temps
- [ ] À faire valider par un juriste (je ne suis pas avocat) : G5 (annulation jusqu'à 48 h, à comparer au droit de rétractation de 14 jours d'un contrat conclu à distance), G3 (règle et plafond d'indemnisation, couverture par l'assurance), et la phrase « jamais plus de 20 % au-dessus du devis sans votre accord écrit » dans G2 (elle peut se lire comme « jusqu'à +20 % sans vous demander » ; or la modification unilatérale du prix par le professionnel figure parmi les clauses interdites de l'art. R212-1, 3° du Code de la consommation), le modèle de devis, le contrat de médiation, l'attestation RC pro
- [ ] G7 : vérifier que chaque filière (déchetterie, ressourcerie, association) délivre un bon de dépôt
- [ ] Visite obligatoire sous 48 h pour chaque maison : prévoir qui remplace le responsable terrain en cas de pic de demandes
- [ ] Obligations à vérifier pour l'activité : récépissé de déclaration de transport de déchets en préfecture (art. R541-50 du Code de l'environnement, selon les tonnages transportés) ; si vous revendez des objets, régime des revendeurs d'objets mobiliers (registre)
