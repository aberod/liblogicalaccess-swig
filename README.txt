Pr�paration: 
  

Le projet n�cessite la version 3.0.12 de SWIG (ou possiblement plus). 

Si vous utilisez la version 3.0.12, vous devez copier le dossier csharp situ� dans le d�p�t sous 'swig/csharp' et le fusionner avec [r�pertoire SWIG]\Lib\csharp. 

Il s'agit de quelques fonctionnalit�s qui ne sont pas encore int�gr�es dans la version officielle. 

Pour compiler le projet, penser � utiliser le script swig-build dans le dossier script. La solution Visual Studio est d�j� param�tr�e pour l'utiliser. 


Structure: 

Le projet g�n�re 2 DLLs, une C/C++, une autre C#.


1. LibLogicalAccessNet.win32: 
 
Contient le code C g�n�r� par SWIG � partir des interfaces (fichiers .i). 

On retrouve 10 interfaces : 

- liblogicalaccess.i: interface principale, qui est inclue dans chacune des autres. On y retrouve les includes n�cessaires � tous, la d�finition de quelques %ignore redondant, la d�finition des classes qui seront des shared_ptr (plus de d�tails plus bas), la gestion de l'h�ritage multiple pour les classes o� cela est possible, en transformant les classes en interface, la gestion des exceptions C++ � travers le C# afin de conserver le bon nom d'exception et le bon message du c�t� C# (plus de d�tails plus bas) 

- liblogicalaccess_exception.i : interface d'inclusions des fichiers contenant des classes d'exceptions. De m�me, ces classes sont d�finies comme pouvant �tre shared_ptr � la main dans ce m�me fichier. 

- liblogicalaccess_data.i : interface de wrapping autour des classes de data. On retrouve �galement la majorit� des mappings de type. Cette interface sert en effet � d�finir, � la main ou nom, tout mapping de type non pris en compte par d�faut par SWIG. 

- liblogicalaccess_core.i : interface de wrapping du c�ur des �l�ments de la lib, notamment toutes les classes dont vont d�river tous les plugins. Il s'agit des classes de la plus haute couche d'abstraction qui sont wrapp�es ici. On  y retrouve aussi quelques typemaps, et principalement le mapping des types en sortie c�t� C#, lorsque le type est un pointeur sur un haut niveau d'abstraction d'une hi�rarchie, ce pointeur ne peut plus �tre downcast� perd le polymorphisme en passant � travers le C#. Il faut donc recr�er la classe fille � la main, c�t� C#, puis la remettre dans une classe plus abstraite. Pour chaque famille, on retrouve alors une factory d'objet qui se base sur un simple caract�ristiques de l'objet pour recr�er la bonne classe.  

- liblogicalaccess_iks.i: interface de wrapping et de mapping de type autour de l'IKS. 

- liblogicalaccess_card.i: interface de wrapping autour de tous les plugins cartes. On y retrouve l'inclusion de toutes les classes des cartes. 

- liblogicalaccess_reader.i: idem mais pour les lecteurs. 

- liblogicalaccess_library.i: interface simple pour l'inclusion puis le wrapping des classes de la librairie dynamique. 

- liblogicalaccess_cardservice.i: interface pour l'inclusion des services de cartes. Ne compile pas. 

- liblogicalaccess_readerservice.i: interface pour l'inclusion des services de lecteurs. Ne compile pas. 



2. LibLogicalAccessNet: 

Cette DLL C# va contenir tous les fichiers C# g�n�r�s SWIG. Une r�f�rence � la DLL C++ est requise. On y retrouve �galement les fichiers PInvoke, un pour chaque interface ayant compil�, qui va servir de passerelle entre les deux langages. 


Scripts: 

On retrouve 5 scripts diff�rents dans le dossier scripts. 

Les 3 premiers, en Python, vont servir � adapter dynamiquement les interfaces lorsque cela est possible. 

- autoComplete.py: ce script - a ne pas lancer trop souvent car extr�mement gourmand en temps, ne le lancer que lorsque des changements majeurs dans la lib ont �t� effectu�s - va servir � ajouter automatiquement les fichiers � inclure lorsqu'ils s'agit de plugins notamment, ainsi qu'ajouter les directives %shared_ptr() automatiquement pour chaque classe dans l'interface liblogicalaccess.i 

- createExceptionClass.py: ce script regarde dans les fichiers de la lib qui contiennent des classes pour les g�n�rer en C#. La liste des fichiers n'est pas dynamique, donc si un fichier avec une nouvelle classe est ajout� dans la lib, il faudra rajouter son emplacement dans le script � la main. 

- adaptExceptionClass.py: a lancer juste apr�s le pr�c�dant pour adapter la classe g�n�r�e automatiquement. 

- callScriptPython.bat: sert simplement � appeler un script python � travers une commande .bat. Utile pour appeler le script depuis Visual Studio, en �v�nement post-build ou pr�-build. Pour l'instant, ce script n'a jamais vraiment �t� utilis�. 

- swig-build.ps1: script Powershell pour compiler les interfaces et optimiser l'utilisation de la m�moire et du processeur. 


Tests Unitaires: 

Les tests unitaires ne sont pas finis et ne tourne pas pour la plupart car ils ne sont qu'un simple recopiage des tests C++ et ne s'adapte pas du tout aux quelques changements op�r�s pour la version C#, notamment les diff�rences de hi�rarchie. 


Avancement du projet:

Le projet est quasiment fonctionnelle, � ce jour il ne fonctionne pas encore � cause de l'heritage multiple. SWIG ne propose pas encore de solution qui marche dans tous les cas. La solution trouv�e est donc de se d�barasser de l'h�ritage multiple/h�ritage virtuel dans la librairie C++ et de le remplacer par des classes englob�s sous forme de bridge � travers les classes qui �taient leurs filles par avant, pour conserver les m�thodes et champs. Cependant, le polymorphisme est perdu. Tous les autres points sensibles sont fonctionnels, � savoir les exceptions, les shared_ptr, le slicing des objets entre les langages (m�me lorsque c'est un pointeur) qui est r�gl� avec toutes les factory, etc.

La documentation de SWIG est relativement compl�te et permet de comprendre mon travail. Il faut savoir que le doc C# n'est pas aussi compl�te que la doc pour le Java, alors que presque toutes les fonctionnalit�s sont similaires. Je recommande de la lire �galement, conjointement � la doc g�n�rale et la doc C#.

De plus, la communaut� SWIG est relativement active, sur GitHub, StackOverflow et sur la mailing list SWIG, ce qui est extrement pratique pour ne pas perdre trop de temps lors d'un probl�me.


Installer:

Une �bauche d'installer a �t� faite. Elle permet de chainer l'installation avec une autre, en utilisant les properties des param�tres d'installation. De plus, les DLLs ont �t� organis�s en 2 features, une pour les 64 bits, l'autre pour les 32, afin d'installer automatiquement les bonnes en fonction de la machine. (https://stackoverflow.com/questions/44827196/chained-packages-in-advanced-installer)

D�p�t dans lesquels des changements ont �t� op�r�s:

- liblogicalaccess: github: schullq/liblogicalaccess branch:develop
- liblogicalaccess-libnfc: github: schullq/liblogicalaccess-libnfc branch:develop
- liblogicalaccess-private : nouvelle branche sur le repos principal -> develop_stagiaire
- LibLogicalAccessWinForms : liblogicalaccesscs branch: v2
- ReadCard: readcard branch:v2


Liens utiles:

- Pull request en attente: https://github.com/swig/swig/pull/989 // pull request de std_list.i et std_vector.i
- Issue toujours ouverte: https://github.com/swig/swig/issues/1022 // Issue � propos de l'heritage virtuel non g�r�
- Question sans reponse sur SO: https://stackoverflow.com/questions/45352707/how-to-use-interface-with-a-templated-class, 
// Question � propos du couplage des directive %template et %interface