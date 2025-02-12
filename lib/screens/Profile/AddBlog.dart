import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:khedma/Services/TravailService.dart';
import 'package:khedma/entities/Travail.dart';
import 'package:khedma/Services/MinIOService.dart';

import '../../Services/SharedPrefService.dart';
import '../../entities/User.dart';

class AddBlog extends StatefulWidget {
  final Function(Map<String, dynamic>) onSave;

  const AddBlog({Key? key, required this.onSave}) : super(key: key);

  @override
  _AddBlogState createState() => _AddBlogState();
}

class _AddBlogState extends State<AddBlog> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final List<File> _selectedImages = [];
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  final TravailService travailService = TravailService(); // Ajoutez TravailService
  final MinIOService minIOService = MinIOService(); // Ajoutez MinIOService
  bool isLoading = false; // Pour gérer l'état de chargement
  final SharedPrefService sharedPrefService = SharedPrefService();
  User? user;


  Future<void> loadUser() async {
    user = await sharedPrefService.getUser();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 1),
      end: Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.forward();
    loadUser();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true; // Activer l'état de chargement
      });

      try {
        // Créer un objet Travail
        Travail newTravail = Travail(
          description: _descriptionController.text,
          titre: _titleController.text,
          image: '', // Initialiser avec une chaîne vide
          addedDate: DateTime.now(), // Date actuelle
          userId: user!.id ?? 0,
        );

        Travail savedTravail = await travailService.addTravail(newTravail);
        int travailId = savedTravail.id!;
        List<String> imageUrls = [];
        for (int i = 0; i < _selectedImages.length; i++) {
          String imageUrl = await minIOService.saveTravailImagesToServer(
            'images', // Nom du bucket
            _selectedImages[i], // Fichier image
            travailId, // ID du travail
          );
          imageUrls.add(imageUrl);
        }

        String updatedImages = imageUrls.join(',');
        newTravail.image = updatedImages ;
        print(updatedImages);
        await travailService.updateTravailImages(travailId, updatedImages);
        setState(() {
          isLoading = false;
        });
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Succès'),
              content: Text('Travail ajouté avec succès !'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Fermer le dialogue
                    Navigator.pop(context); // Fermer le formulaire
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } catch (e) {
        // Désactiver l'état de chargement en cas d'erreur
        setState(() {
          isLoading = false;
        });

        // Afficher un message d'erreur
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de l\'ajout du travail : $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _pickImages() async {
    final ImagePicker _picker = ImagePicker();
    final List<XFile>? images = await _picker.pickMultiImage();

    if (images != null && images.isNotEmpty) {
      setState(() {
        _selectedImages.addAll(images.map((image) => File(image.path)).toList());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Titre du formulaire
              Text(
                "Ajouter un travail",
                style: GoogleFonts.roboto(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 20),
              // Champ Titre
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: "Titre",
                  labelStyle: GoogleFonts.roboto(
                    color: Colors.grey[600],
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Color(0xFF0099D6)),
                  ),
                ),
                style: GoogleFonts.roboto(
                  fontSize: 16,
                  color: Colors.black87,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Veuillez entrer un titre";
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              // Champ Description
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: "Description",
                  labelStyle: GoogleFonts.roboto(
                    color: Colors.grey[600],
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Color(0xFF0099D6)),
                  ),
                ),
                style: GoogleFonts.roboto(
                  fontSize: 16,
                  color: Colors.black87,
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Veuillez entrer une description";
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              // Section Images
              Text(
                "Images",
                style: GoogleFonts.roboto(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8),
              // Grille horizontale des images sélectionnées
              Container(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _selectedImages.length + 1, // +1 pour le bouton d'ajout
                  itemBuilder: (context, index) {
                    if (index == _selectedImages.length) {
                      // Bouton pour ajouter des images
                      return GestureDetector(
                        onTap: _pickImages,
                        child: Container(
                          width: 100,
                          margin: EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.grey[300]!,
                              width: 1,
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.add_photo_alternate,
                              size: 40,
                              color: Colors.grey[400],
                            ),
                          ),
                        ),
                      );
                    } else {
                      // Afficher les images sélectionnées
                      return Container(
                        width: 100,
                        margin: EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: FileImage(_selectedImages[index]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
              SizedBox(height: 24),
              // Bouton Ajouter
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _submitForm, // Désactiver le bouton pendant le chargement
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF0099D6),
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: isLoading
                      ? CircularProgressIndicator(color: Colors.white) // Afficher un indicateur de chargement
                      : Text(
                    "Ajouter",
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}