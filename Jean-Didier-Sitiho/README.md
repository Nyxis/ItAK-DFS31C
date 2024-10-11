# Réponses aux Exercices

"Fonctionnement d'Internet", j'ai créé un schéma expliquant le fonctionnement d'Internet lorsque Jean-Didier Sitiho tape `https://gensdeconfiance.com/fr/` dans son navigateur, jusqu'à l'affichage complet de la page. J'ai utilisé l'outil Kroki pour générer ce schéma.

## Outil Utilisé

### Kroki

Kroki est un outil qui permet de créer des diagrammes à partir de descriptions textuelles. Il supporte une multitude de langages de diagrammes comme BlockDiag, SeqDiag, ActDiag, NwDiag, PacketDiag, RackDiag, BPMN, Bytefield, C4 (avec PlantUML), D2, DBML, Ditaa, Erd, Excalidraw, GraphViz, Mermaid, Nomnoml, Pikchr, PlantUML, Structurizr, SvgBob, Symbolator, UMLet, Vega, Vega-Lite, WaveDrom, WireViz, et plus encore.

Pour cet exercice, j'ai utilisé le langage Mermaid pour créer un diagramme de séquence.

## Schéma du Fonctionnement d'Internet

Voici le code Mermaid que j'ai utilisé pour créer le diagramme de séquence décrivant les étapes et les interactions entre le client (navigateur), le serveur DNS, le serveur web, et d'autres composants pertinents :

```mermaid
sequenceDiagram
    participant User as Jean-Didier Sitiho
    participant Browser as Web Browser
    participant DNS as DNS Server
    participant Server as Web Server
    participant DB as Database Server
    participant API as API Server
    participant CDN as Content Delivery Network
    
    User->>Browser: Enter URL (https://gensdeconfiance.com/fr/)
    Browser->>DNS: Request IP Address for gensdeconfiance.com
    DNS->>Browser: Respond with IP Address
    Browser->>Server: Send HTTP Request to gensdeconfiance.com (IP Address)
    Server->>DB: Query Database for page content
    DB->>Server: Return page content
    Server->>API: Fetch additional data from API
    API->>Server: Return additional data
    Server->>CDN: Request static assets (images, CSS, JS)
    CDN->>Server: Return static assets
    Server->>Browser: Send HTTP Response with page content and assets
    Browser->>User: Render webpage
