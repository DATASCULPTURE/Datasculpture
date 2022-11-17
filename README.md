# Datasculpture

![screenshot]([https://github.com/DATASCULPTURE/Datasculpture/master/images/screenshot.png?raw=true])

[English version here](README.en.md)

Ce programme est un générateur de formes sur Processing.
Il génère une forme à partir d'un fichier .csv et l'exporte dans un fichier .stl.
```main.pde``` est le point d'entrée du programme.

---

## Bibliothèques 

Le programme utilise la bibliothèque Peasycam.

---

## Usage

Clonez le projet avec la commande `TODO` 
Ouvrez et lancez le projet depuis l'IDE Processing. (S'il faut importer la bibliothèque Peasycam, allez dans Sketch -> Import Library -> Peasycam).  
Quand le programme est lancé, appuyez sur la touche  *espace* pour choisir un fichier .csv à importer.  
Quand la forme en 3D est générée, appuyez sur la touche *entrée* pour l'exporter en .stl.  
Par défaut, le programme ne prend pas en compte la première ligne et la première colonne du ficher .csv donné en entrée.  

---

## STLExporter 


La classe ```STLExporter.pde``` est utilisée pour exporter la forme générée en un fichier .stl. Cette classe peut être utilisée pour exporter n'importe quelle PShape créée dans Processing.  

Pour l'utiliser dans un projet, copier le fichier ```STLExporter.pde``` dans le dossier de votre projet Processing. Vous pouvez ensuite créer un objet STLExporter ainsi :
`STLExporter exporter = new STLExporter();`  
`exporter.export(myPShape, filename);`  

Vous pouvez regarder le fichier  ```main.pde``` pour voir un exemple d'utilisation.


---

## Classes  

ce programme utilise les classes suivantes.

* Branch 
* STLExporter 
* ShapeVisulisation

Le fichier```main.pde``` contient le programe principal.
 


