# Recette, 25 novembre 2026

Mesures faites en local (Chrome 153 sans interface, serveur Node avec compression Brotli), sur la version livrée.

| Critère | Résultat | Comment vérifié |
|---|---|---|
| Lighthouse mobile : Performance ≥ 90 | **99 à 100** (4 passages) | Lighthouse 13.6, profil mobile par défaut (Moto G Power 412×823, 4G lente simulée, CPU ×4), 3 passages sur `/` et 1 sur `?v=succession` |
| Lighthouse : Accessibilité ≥ 95 | **100** | idem |
| Lighthouse : SEO = 100 | **100** | idem (robots.txt, canonique, meta description, liens explorables) |
| Lighthouse : Bonnes pratiques | 100 | idem |
| LCP ≤ 2,5 s | **0,6 à 0,7 s** (labo) | Lighthouse, simulation 4G lente |
| CLS ≤ 0,1 | **0** (labo) | Lighthouse + polices préchargées, image dimensionnée, variante H1 appliquée avant affichage |
| INP ≤ 200 ms | **40 ms max** (proxy labo) | Puppeteer, CPU ×4, API Event Timing sur 42 interactions (ouverture des rubriques, clic d'appel, case RGPD, saisie). TBT Lighthouse 10 à 110 ms |
| Poids HTML+CSS+JS compressé < 100 ko | **15,6 ko** gzip, 13,8 ko Brotli | `gzip -9` et Brotli sur index.html (CSS et JS intégrés). Page entière avec polices et images : 87 Ko |
| JSON-LD sans erreur | JSON valide, types et propriétés conformes à schema.org | Parsing + vérification de types TypeScript avec `schema-dts` (0 erreur ; contrôle négatif : une propriété inventée est bien rejetée) |
| Absence d'AggregateRating / Review | **Aucun** | Recherche dans le JSON-LD |
| Aucune valeur d'exemple dans le JSON-LD | **Aucune** | Recherche des 12 valeurs d'exemple (Karim, Julien, MMA, CM2C, adresse, e-mail, date…) |
| Page lisible sans JavaScript | **Oui** : H1, 11 H2, 8 questions FAQ, formulaire ; 12 294 caractères de texte contre 12 268 avec JS | Puppeteer, JavaScript désactivé |
| Variantes `?v=` | `succession` et `appartement` changent H1 et titre, `appartement` change aussi « la maison » en « l'appartement » ; canonique inchangée ; `?v=__proto__` et valeur inconnue sans effet ; 1 seul H1 | Puppeteer sur 5 URL |
| Aucune erreur console | **0** sur les 5 URL | Puppeteer (erreurs, avertissements, exceptions, requêtes échouées) |
| Test des 5 secondes (375 px) | **OK** à 375×667, 375×812 et 412×823 : H1 en 119-196 px, sous-titre 215-300 px, bouton d'appel 320-374 px | Positions mesurées dans le navigateur |
| HTML conforme | 1 seule erreur W3C, volontaire : attribut `netlify-honeypot` (exigé par Netlify) | Validateur W3C Nu (vnu.jar) ; html-validate : 3 alertes « tel-non-breaking », faux positifs (l'espace signalée est dans « Appeler le », le numéro est déjà en espaces insécables) |
| Événements dataLayer | `call_click`, `whatsapp_click`, `photo_upload`, `form_submit` remontent avec leurs paramètres | Puppeteer : clics, ajout d'un fichier, envoi du formulaire |
| gclid, v et UTM conservés | Oui, dans les champs cachés, et toujours présents après envoi | URL de test `?gclid=…&v=succession&utm_…` |
| Formulaire | Envoi OK + message ; champ vide bloqué ; erreur serveur → message de repli avec téléphone et WhatsApp ; fichier de 9 Mo → avertissement, pas d'envoi | Puppeteer avec réponses 200 et 500 simulées |
| Consentement | Bannière visible, 0 requête de suivi avant le choix et après défilement ; Refuser → 0 requête, même après rechargement ; Accepter → GTM chargé, `consent update` à `granted` ; boutons Refuser et Accepter identiques (152×48, même style) | Puppeteer avec un identifiant GTM de test, requêtes Google interceptées |
| Consent Mode v2 par défaut | Les 4 signaux à `denied` + `wait_for_update` | Lecture du dataLayer |
| Barre d'appel mobile | Cachée tant que les boutons du haut sont visibles, visible ensuite ; en fin de page, le dernier élément s'arrête 35 px au-dessus d'elle | Puppeteer |
| Clavier et focus visible | Lien d'évitement en 1er, puis appel, boutons ; contour de 3 px partout | Puppeteer, touche Tab |
| Cibles tactiles ≥ 44 px | Boutons 48 à 54 px ; case RGPD 28 px, mais toute l'étiquette (≥ 44 px) est cliquable | Mesure des éléments visibles |
| Réponses directes 40-60 mots | 11 H2 : 43 à 54 mots ; 8 FAQ : 48 à 57 mots | Script de comptage |
| Termes interdits | 0 prix au m³, 0 « garanti », 0 urgence, 0 déduction fiscale ; « débarras gratuit » et « rachat » uniquement à la forme négative | Recherche dans le texte visible |

## Non mesuré (donc non validé)

- **Données terrain au 75e centile** (LCP, INP, CLS réels) : impossibles avant la mise en ligne. Les chiffres ci-dessus sont des mesures de labo. À lire dans Search Console / CrUX après environ 28 jours de trafic.
- Lighthouse sur l'hébergement réel (TLS, CDN, HTTP/2) : à relancer sur l'URL de production.
- **Test des résultats enrichis de Google** (outil en ligne, non accessible ici). Probable : signalement d'une adresse manquante pour le type LocalBusiness. C'est attendu, puisque l'adresse n'est volontairement pas déclarée (zone de service).
- Envoi réel par Netlify Forms, réception de la notification, limite réelle des pièces jointes.
- Liens `tel:` et WhatsApp sur de vrais téléphones.
- Lecteur d'écran (VoiceOver, TalkBack) : seul l'audit automatique axe (via Lighthouse) a été passé.
- Conteneur GTM réel et balises de conversion Google Ads.

## Principes de persuasion appliqués

| Principe | Où |
|---|---|
| 1. Système 1 (quoi, où, comment, quoi faire en 5 s) | Héros : H1 (quoi + où), sous-titre (comment), 2 boutons (quoi faire). Un message par section. Test des 5 secondes OK |
| 2. Coût psychologique : clarté | « Ce que vous n'aurez pas à faire » (3 gestes : appeler, filmer, valider), « Comment ça se passe » (4 étapes) |
| 2. Coût psychologique : applicabilité | « Vous vous reconnaissez ? » (4 situations), « Succession », FAQ « J'habite loin », « plusieurs héritiers », « petits volumes » |
| 2. Coût psychologique : contrôle | Réassurance du héros (rien signé chez vous, papiers mis de côté), devis écrit (étapes), plafond de 20 % (prix), boîte et inventaire signé (jour J), photos le jour même, paiement après |
| 3. Soulagement avant le prix | Le prix n'apparaît qu'en 7e section (héros compris), après « Ce que vous n'aurez pas à faire » et « Ce qui est compris ». Aucun prix dans le héros |
| 4. Douleur de payer | Un seul prix d'appel « tout compris », 10 éléments cochés, « Paiement après l'intervention » dans la carte de prix, aucun prix au m³ |
| 5. Miroir | Citations dans les cartes : « Je ne sais pas par où commencer », « J'habite loin », « La maison doit être vide pour la vente » ; « On est plusieurs » (succession) |
| 6. Trois motivations | Fonctionnelle : cartes et « Le jour J » (vide, balayée, date). Expérientielle : « Le jour J » (arrivée, protection, boîte, photos). Identitaire : la ligne au-dessus du formulaire |
| 7. Confiance sans avis | « Ce que nous ne faisons pas » + encadré « Pourquoi pas de débarras gratuit ? », visage de l'interlocuteur, SIRET, assurance |
| 8. Rien de trompeur | Aucun avis, chiffre ni chantier inventé ; sections Avis et Avant/après masquées ; valeurs d'exemple surlignées. Réserve : la phrase des 20 % (voir README) |

## Mise à jour : infographie et photos intégrées

Lighthouse mobile, 2 passages : Performance 97 et 100, Accessibilité 100, Bonnes pratiques 100, SEO 100. LCP 0,8 s, CLS 0, TBT 50 à 190 ms. Poids total de la page : 195 Ko (photos en WebP, chargées seulement à l'approche). Test des 5 secondes toujours OK aux 3 tailles d'écran, 0 erreur console, INP labo 40 ms.

## Mise à jour : garanties G1 à G8

| Critère | Résultat | Comment vérifié |
|---|---|---|
| Garanties mot pour mot | G1 à G8 présentes dans la section « Le risque est pour nous, pas pour vous » ; occurrences dans le texte visible : G1 ×2, G2 ×2, G3 ×2, G4 ×2, G5 ×1, G6 ×1, G7 ×2, G8 ×2, toutes identiques au texte officiel (au détail typographique près : apostrophe courbe, espaces insécables) | Script de comparaison sur le texte visible ; les 9 éléments `data-g` sont identiques au texte officiel |
| Résumés autorisés | 3 lignes courtes dans le héros (« Maison : prix maximum écrit après visite », « Ce que vous gardez est listé, et indemnisé s'il disparaît ») + G1 entière | Décision validée avant intégration |
| Doublons | La section Prix ne garde que G2 | Lecture |
| Phrases interdites | 0 « paiement / payez après l'intervention », 0 « Vous payez après » seul, 0 maison chiffrée sur vidéo seule, 0 rétractation présentée comme garantie, 0 délai d'intervention garanti | Recherche dans le texte visible et dans le JSON-LD |
| FAQ | 9 questions, réponses de 50 à 60 mots ; 12 H2 avec réponse directe de 43 à 57 mots | Script de comptage |
| Valeurs d'exemple | Toutes marquées `data-demo` (Julien, MMA IARD, contrat n° 145 678 901, CM2C, adresse, TVA, entreprise individuelle, e-mail, date, directeur de publication, hébergeur) ; aucune dans le JSON-LD | Script : texte visible une fois les zones `data-demo` retirées |
| Lighthouse mobile | 97 à 100 / 100 / 100 / 100 sur 3 passages ; LCP 0,8 s ; CLS 0 ; TBT 10 à 210 ms (proxy INP labo : 48 ms) | Lighthouse 13.6, profil mobile |
| Poids HTML+CSS+JS | 17,1 ko gzip | gzip -9 |
| Sans JavaScript | H1, 12 H2, 9 questions, formulaire présents | Puppeteer, JS désactivé |
| Test des 5 secondes à 375 px | Tout est visible sans défiler, y compris à 375×667 : H1 119-196, sous-titre 215-300, bouton d'appel 318-372, 3 garanties 508-637 px | Positions mesurées |
| Variantes, console, consentement, formulaire | Inchangés : variantes OK, 0 erreur console, 0 requête de suivi avant le choix, événements et champs cachés OK | Puppeteer |
| JSON-LD | Seuls les textes de description ont changé ; JSON valide, types schema.org conformes | Parsing + schema-dts |

Non mesuré : données terrain, Lighthouse en production, test des résultats enrichis de Google, liens d'appel et WhatsApp sur de vrais téléphones, et la tenue réelle des garanties (bons de dépôt, visite sous 48 h, indemnisation).

## Recette Cloudflare Pages + Formspree (25 novembre 2026)

Testé sur https://maisonclaire.pages.dev/ (Playwright, Lighthouse 12.8.2 mobile).

| Contrôle | Résultat |
|---|---|
| Site en HTTPS sur pages.dev | OK, 200 |
| Site sur maisonclaire-debarras.fr, redirection www et http → https | NON TESTÉ : domaine non enregistré (AFNIC : introuvable) |
| En-têtes | nosniff, Referrer-Policy, Permissions-Policy présents, pas de CSP ; cache conforme (page max-age=0, polices 1 an immutable, images 1 an) |
| 404 | `/nimportequoi` → 404 ; README, RECETTE et deploy.sh non publiés |
| noindex | Aucun dans la page (meta robots index,follow) ni dans robots.txt. `X-Robots-Tag: noindex` uniquement sur l'hôte maisonclaire.pages.dev, volontaire |
| Canonique, robots.txt, sitemap.xml | Canonique https://maisonclaire-debarras.fr/ ; robots.txt autorise Googlebot ; sitemap.xml répond 200 et ne contient que https://maisonclaire-debarras.fr/ |
| Formulaire, succès (réponse Formspree simulée 200) | Message de succès, sans rechargement ; `form_submit` (variant) envoyé ; en-tête Accept: application/json ; champs gclid, v, UTM, consentement_mesure, _gotcha transmis |
| Formulaire, erreur (réponse simulée 500) | Message d'erreur avec téléphone et WhatsApp ; aucun `form_submit` |
| Envoi réel reçu dans Formspree (e-mail et tableau de bord) | NON TESTÉ : identifiant Formspree à fournir |
| E-mail contact@ | NON TESTÉ : domaine non enregistré |
| Événements | call_click, whatsapp_click (dont `formulaire`) OK ; photo_upload retiré |
| Lighthouse mobile (pages.dev) | Performance 100, Accessibilité 100, Bonnes pratiques 100. SEO 69 à cause du noindex volontaire de pages.dev |
| Lighthouse SEO sans la règle pages.dev (wrangler pages dev, mêmes en-têtes) | SEO 100, Accessibilité 100 |
| Signaux web | LCP 1,2 s, CLS 0, TBT 30 ms (labo). INP : pas mesurable en labo, à lire dans la Search Console après trafic réel |
| Console | 0 erreur |
| Sans JavaScript | Contenu, formulaire (envoi direct à Formspree) et barre d'appel visibles |
