# Domaines `.gouv.ga` du gouvernement gabonais — inventaire & technologie

> Recherche réalisée le **2026-10-22**.
> Objectif : (1) recenser les liens en `.gouv.ga` utilisés par les sites et services
> du gouvernement gabonais, (2) indiquer lesquels sont codés en **PHP**.

## ⚠️ Méthode & limites (à lire avant la liste)

Cet inventaire a été constitué **à partir d'informations publiques** (moteurs de
recherche, annuaires, profils de technologies publics type StackScan, et surtout la
**structure des URL** indexées de chaque site).

Je **n'ai pas pu interroger les sites en direct** depuis l'environnement d'exécution :
- l'accès réseau sortant (`curl`) y est restreint par politique et refuse ces hôtes ;
- l'outil de récupération de page ne résout plus le DNS (les domaines `.ga` résolvent
  de façon intermittente hors du Gabon).

Conséquence : la **liste des domaines** est fiable, mais la détection **PHP** repose sur
des *empreintes publiques* (motif d'URL, plugins détectés, générateur) et non sur une
lecture directe des en-têtes HTTP. Les cas **confirmés** et **déduits** sont distingués
ci-dessous, et une procédure de vérification directe est donnée en fin de document
(à exécuter depuis une machine qui peut atteindre les sites, p. ex. au Gabon).

---

## 1. Liste des domaines `.gouv.ga` (ministères & SGG)

### Tier A — confirmés (page réelle indexée, avec titre officiel)

| # | Domaine | Entité | Techno observée | PHP ? |
|---|---------|--------|-----------------|-------|
| 1 | `sgg.gouv.ga` (et `www.`) | Secrétariat Général du Gouvernement | CMS (ANINF) | Très probable |
| 2 | `primature.gouv.ga` (et `www.`) | Primature (Premier Ministre) | **Joomla** (URL SEF `/96-…`, `/2-actualites/1409-…/2426-…`) | ✅ **Oui (Joomla)** |
| 3 | `budget.gouv.ga` (et `www.`) | Min. Économie, Finances, Dette et Participations | CMS (ANINF) | Très probable |
| 4 | `diplomatie.gouv.ga` (et `www.`) | Min. Affaires Étrangères | CMS (ANINF) | Très probable |
| 5 | `interieur.gouv.ga` (et `www.`) | Min. Intérieur, Sécurité et Décentralisation | CMS (ANINF ; URL `/ministere/ministre`) | Très probable |
| 6 | `travail.gouv.ga` (et `www.`) | Min. Travail, Plein Emploi et Dialogue Social | CMS (ANINF) | Très probable |
| 7 | `fonction-publique.gouv.ga` | Min. Fonction Publique et Renforcement des Capacités | CMS (ANINF) | Très probable |
| 8 | `sante.gouv.ga` (et `www.`) | Min. Santé | CMS (ANINF) | Très probable |
| 9 | `agriculture.gouv.ga` (et `www.`) | Min. Agriculture, Élevage et Développement Rural | CMS (ANINF) | Très probable |
| 10 | `petrole.gouv.ga` (et `www.`) | Min. Pétrole et du Gaz | CMS (ANINF) | Très probable |
| 11 | `enseignement-superieur.gouv.ga` | Min. Enseignement Supérieur et Recherche Scientifique | CMS (ANINF) | Très probable |

### Tier B — cités dans des annuaires / Wikipédia / anciens menus (existence probable, à revérifier)

| # | Domaine | Entité | Remarque |
|---|---------|--------|----------|
| 12 | `transports.gouv.ga` | Min. Transports / Marine Marchande | Réf. Wikipédia |
| 13 | `mines.gouv.ga` (et `www.`) | Min. Mines | Annuaire |
| 14 | `justice.gouv.ga` | Min. Justice | App « Gabon Services » + annuaire |
| 15 | `economie-numerique.gouv.ga` | Min. Communication & Économie Numérique | Ancien annuaire |
| 16 | `education-nationale.gouv.ga` | Min. Éducation Nationale | Ancien annuaire |
| 17 | `affaires-etrangeres.gouv.ga` | Affaires Étrangères (alias de `diplomatie`) | Annuaire |
| 18 | `finances.gouv.ga` | Finances | Signalé **cassé** dans un annuaire |

> Les intitulés exacts des ministères changent à chaque remaniement (dernière liste
> gouvernementale : **11 octobre 2026**). Le sous-domaine, lui, reste souvent stable.

---

## 2. Domaines publics gabonais **hors `.gouv.ga`** (connexes, pour complétude)

Le gouvernement utilise aussi beaucoup le `.ga` « simple » et des sous-domaines d'agences :

| Domaine | Entité / service | Techno observée | PHP ? |
|---------|------------------|-----------------|-------|
| `gouvernement.ga` | **Portail Gouvernemental** (vitrine officielle) | **WordPress** (permaliens `/AAAA/MM/JJ/…` + plugins WP *All-in-One SEO*, *LayerSlider* détectés par StackScan) | ✅ **Oui (WordPress)** |
| `gouv.ga` (apex) | Portail / landing | StackScan : Microsoft 365, Airtable, Google Search Console (profil **non-PHP** apparent) | ❓ à vérifier |
| `presidence.ga` | Présidence de la République | — | à vérifier |
| `assemblee-nationale.ga` | Assemblée Nationale | — | à vérifier |
| `journal-officiel.ga` | Journal Officiel | — | à vérifier |
| `dgi.ga` / `e-tax.dgi.ga` | Direction Générale des Impôts / portail fiscal **e-Tax** | application métier | à vérifier |
| `dgdi.ga` / `edgdi.dgdi.ga` | Documentation & Immigration (passeport, **e-Visa**) | application métier | à vérifier |
| `cnamgs.ga` / `ecnamgs.cnamgs.ga` / `edeclaration.cnamgs.ga` | Assurance maladie (CNAMGS) | application métier | à vérifier |
| `cnss.ga` | Sécurité sociale (CNSS) | — | à vérifier |
| `tresorpublic.ga` | Trésor Public (TrésorPay) | application métier | à vérifier |
| `administration.ga` | **Nouvelle** plateforme e-administration (guichet unique, en déploiement 2026) | — | à vérifier |

---

## 3. Lesquels sont codés en PHP ?

**Rappel :** PHP se « voit » surtout quand le site tourne sur un **CMS PHP** (WordPress,
Joomla, Drupal) ou expose des URL `.php` / des en-têtes `X-Powered-By: PHP`.

### ✅ Confirmés PHP (par empreinte publique)

- **`primature.gouv.ga` → Joomla** → **PHP**.
  Preuve : motif d'URL SEF propre à Joomla, à identifiant numérique +
  alias (`/96-secretariat-general`, `/2-actualites/1409-politique/2426-…`).
- **`gouvernement.ga` → WordPress** → **PHP** *(domaine `.ga`, pas `.gouv.ga`)*.
  Preuve : permaliens à date (`/2026/10/11/nouveau-gouvernement…/`) **et** plugins
  WordPress détectés par StackScan (*All-in-One SEO*, *LayerSlider*).

### 🟡 Très probablement PHP (déduit, non confirmé site par site)

Tous les sites ministériels `.gouv.ga` ci-dessus (budget, diplomatie, intérieur,
travail, fonction-publique, santé, agriculture, pétrole, enseignement-supérieur, sgg…).

Raisons :
1. Ils ont **tous été conçus par l'ANINF** (Agence Nationale des Infrastructures
   Numériques et des Fréquences), qui déclare avoir réalisé « 77 sites administratifs,
   dont un portail gouvernemental, **28 sites de départements ministériels** et 8 sites
   d'institutions » — c'est le **même atelier / même pile** qui les produit.
2. Les deux sites de cette famille que j'ai pu identifier précisément tournent sur un
   **CMS PHP** (Joomla pour la Primature, WordPress pour le portail).
3. Au Gabon, **WordPress est le CMS n°1** (StackScan : ~292 sites), servi majoritairement
   sous **Apache** (~35,7 %) — écosystème massivement PHP.

👉 Donc, selon toute vraisemblance, **la quasi-totalité des sites `.gouv.ga`
ministériels sont en PHP** (Joomla et/ou WordPress). Mais seuls **Primature** et
**gouvernement.ga** sont *formellement* établis ici.

### ❓ Probablement PAS de simples sites PHP

- Les **téléservices** (`e-tax.dgi.ga`, `edgdi.dgdi.ga`, `ecnamgs.cnamgs.ga`,
  `tresorpublic.ga`…) sont des **applications métier** (déclarations, paiements, titres
  sécurisés). Leur langage n'est pas déductible de l'extérieur sans test direct — ce peut
  être PHP (Laravel/Symfony) comme Java/.NET/Node. **À vérifier.**
- `gouv.ga` (apex) présente un profil SaaS (Microsoft 365 / Airtable) selon StackScan,
  donc **pas forcément PHP**.

---

## 4. Comment vérifier formellement (depuis une machine qui atteint les sites)

Pour chaque domaine, l'un de ces signaux suffit à confirmer PHP :

```bash
# 1) En-têtes HTTP : X-Powered-By / cookie de session PHP
curl -sI https://budget.gouv.ga | grep -iE 'server|x-powered-by|set-cookie'
#   -> "X-Powered-By: PHP/8.x"  ou  "Set-Cookie: PHPSESSID=..."  => PHP

# 2) Balise générateur dans le HTML
curl -s https://budget.gouv.ga | grep -i '<meta name="generator"'
#   -> content="Joomla! ..."   => Joomla (PHP)
#   -> content="WordPress x.y" => WordPress (PHP)

# 3) Chemins d'assets caractéristiques
#   /wp-content/ , /wp-includes/            => WordPress (PHP)
#   /templates/ , /media/system/ , index.php?option=com_  => Joomla (PHP)
#   /sites/default/files/ , ?q=node/        => Drupal (PHP)
```

Profils publics (aucune installation requise) :
`whatcms.org`, `builtwith.com`, `w3techs.com`, `wappalyzer.com` — saisir le domaine.

---

## Sources principales

- Portail : [gouvernement.ga](https://gouvernement.ga/) · [Le Gouvernement (11/10/2026)](https://gouvernement.ga/2026/10/11/nouveau-gouvernement-de-la-republique-gabonaise/)
- SGG : [sgg.gouv.ga](https://www.sgg.gouv.ga/) · [organisation](https://www.sgg.gouv.ga/organisation)
- Primature : [primature.gouv.ga](https://www.primature.gouv.ga/) · [exemple URL Joomla](https://www.primature.gouv.ga/2-actualites/1409-politique/2426-gouvernement-de-la-transition-raymond-ndong-sima-iii-/)
- Ministères : [budget](https://www.budget.gouv.ga/) · [diplomatie](https://www.diplomatie.gouv.ga/) · [interieur](https://www.interieur.gouv.ga/) · [travail](https://www.travail.gouv.ga/) · [fonction-publique](https://fonction-publique.gouv.ga/) · [sante](https://www.sante.gouv.ga/) · [agriculture](https://www.agriculture.gouv.ga/) · [petrole](https://www.petrole.gouv.ga/)
- ANINF : [L'ANINF au centre du numérique gabonais (AllAfrica)](https://fr.allafrica.com/stories/202512250150.html)
- Profil techno : [StackScan — Gabon](https://www.stackscan.com/country/gabon) · [W3Techs — exemple .ga](https://w3techs.com/sites/info/cgcgabon.ga)
- Téléservices : [e-Tax](https://e-tax.dgi.ga/) · [e-DGDI](https://edgdi.dgdi.ga/)
- Nouvelle plateforme : [administration.ga (Tech Review Africa)](https://techreviewafrica.com/news/6582/gabon-unveils-administrationga-platform-to-promote-sovereign-digital-government)
