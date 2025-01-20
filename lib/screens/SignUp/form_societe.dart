import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khedma/Services/SharedPrefService.dart';
import '../../components/Buttons/MyButtons.dart';
import '../../theme/AppTheme.dart';

class FormSocieteController {
  SharedPrefService sharedPrefService = SharedPrefService();
  List<String> _selectedDocuments = ['', '', ''];
  List<String> cardNames = [
    'K.BIS',
    'Label de qualité',
    'Assurance'
  ];

  TextEditingController nomSocieteController = TextEditingController();
  TextEditingController domaineActiviteController = TextEditingController();

  Map<String, dynamic> validate() {
    Map<String, dynamic> result = {};
    if(nomSocieteController.text.isEmpty || domaineActiviteController.text.isEmpty)
    {
      result = {'error': true, 'message': 'Veuillez remplir tous les champs'};
    }
    // all the documents must be selected
    else if(_selectedDocuments[0] == '' || _selectedDocuments[1] == '' || _selectedDocuments[2] == '') {
      result = {'error': true, 'message': 'Veuillez télécharger tous les documents'};
    }
    return result;
  }

  void save() {
    // save the data to shared preferences
    sharedPrefService.saveStringToPrefs('NomSociete', nomSocieteController.text);
    sharedPrefService.saveStringToPrefs('DomaineActivite', domaineActiviteController.text);
    sharedPrefService.saveStringToPrefs('KBIS', _selectedDocuments[0]);
    sharedPrefService.saveStringToPrefs('LabelQualite', _selectedDocuments[1]);
    sharedPrefService.saveStringToPrefs('Assurance', _selectedDocuments[2]);
  }
}

class FormSociete extends StatefulWidget {
  final FormSocieteController controller;

  const FormSociete({Key? key, required this.controller}) : super(key: key);

  @override
  State<FormSociete> createState() => _FormSocieteState();
}

class _FormSocieteState extends State<FormSociete> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),
                  Center(
                    child: Image.asset(
                      "assets/images/logo_rent_me-removebg-preview 2.png",
                      width: 50.w,
                      height: 50.h,
                    ),
                  ),
                  SizedBox(height: 50.h),
                  Center(
                    child: Container(
                      width: 0.8.sw,
                      child: Text(
                        'Avez vous une société ?',
                        style: TextStyle(
                          fontSize: 0.05.sw,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.secondaryColor,
                          fontFamily: 'Roboto',
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Center(
                    child: Container(
                      width: 0.8.sw,
                      child: Text(
                        'Veuillez citer vos justificatifs pour valider votre statut.',
                        style: TextStyle(
                          fontSize: 0.03.sw,
                          color: AppTheme.accentColor,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w500,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(height: 30.h),
                  _buildTextField({
                    'label': 'Nom de la Société:',
                    'hint': 'Nom de la Société:',
                  }),
                  SizedBox(height: 10.h),
                  _buildTextField({
                    'label': 'Domaine d’activité:',
                    'hint': 'Domaine d’activité:',
                  }),
                  SizedBox(height: 16.h),
                  SizedBox(height: 50.h),
                  Text(
                    'Documents',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _buildCard(100.w, Colors.blue, 0),
                      SizedBox(width: 16.w),
                      _buildCard(100.w, Colors.blue, 1),
                      SizedBox(width: 16.w),
                      _buildCard(100.w, Colors.blue, 2),
                    ],
                  ),
                  SizedBox(height: 30.h),
                  Center(
                    child: Container(
                      width: 0.8.sw,
                      child: Text(
                        'Veuillez télécharger les documents nécessaires comme K.BIS, Garantie décennale, Label de qualité (RGE).',
                        style: TextStyle(
                          fontSize: 0.03.sw,
                          color: AppTheme.accentColor,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w500,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField(Map<String, dynamic> textFieldData) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: AppTheme.grisTextField,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5.0,
            spreadRadius: 1.0,
            offset: const Offset(0, 2.0),
          ),
        ],
      ),
      child: TextField(
        controller: textFieldData['label'] == 'Nom de la Société:'
            ? widget.controller.nomSocieteController
            : widget.controller.domaineActiviteController,
        decoration: InputDecoration(
          hintText: textFieldData['hint'],
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          // Ajoutez le padding ici
          hintStyle: const TextStyle(color: AppTheme.secondaryColor),
          // Changer la couleur du hint text ici

          border: const UnderlineInputBorder(
            borderSide:
                BorderSide(color: AppTheme.grisTextField), // Bordure blanche
          ),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
                color: AppTheme.grisTextField), // Bordure blanche quand inactif
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
                color: AppTheme.grisTextField), // Bordure blanche quand actif
          ),
        ),
      ),
    );
  }

  Widget _buildCard(double size, Color color, int index) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: size * 0.9,
              height: size * 0.9,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.white, width: 2.0),
                borderRadius: BorderRadius.circular(15.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 10.0,
                    spreadRadius: 1.0,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(bottom: size * 0.1),
                  child: widget.controller._selectedDocuments[index] != ''
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.picture_as_pdf,
                              color: Colors.red,
                              size: size * 0.4,
                            ),
                            SizedBox(height: 8),
                            Text(
                              File(widget.controller._selectedDocuments[index])
                                  .path
                                  .split('/')
                                  .last
                                  .substring(0, 12),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        )
                      : Image.asset(
                          'assets/icons/image.png',
                          width: size * 0.4,
                          height: size * 0.4,
                        ),
                ),
              ),
            ),
            Positioned(
              top: size * 0.0,
              right: size * 0.0,
              child: Container(
                width: size * 0.20,
                height: size * 0.20,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
                child: GestureDetector(
                  onTap: () async {
                    if (widget.controller._selectedDocuments[index] == '') {
                      FilePickerResult? result =
                          await FilePicker.platform.pickFiles(
                        type: FileType.custom,
                        allowedExtensions: ['pdf'],
                      );
                      if (result != null) {
                        String filePath = result.files.single.path!;
                        setState(() {
                          widget.controller._selectedDocuments[index] =
                              filePath; // Met à jour l'image spécifique à l'index
                        });
                      } else {
                        print("Aucun fichier sélectionné");
                      }
                    } else {
                      setState(() {
                        widget.controller._selectedDocuments[index] = '';
                      });
                    }
                  },
                  child: Center(
                    child: widget.controller._selectedDocuments[index] != ''
                        ? Icon(
                            Icons.remove,
                            color: Colors.white,
                            size: size * 0.18,
                          )
                        : Icon(
                            Icons.add,
                            color: Colors.white,
                            size: size * 0.18,
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Container(
          width: size * 0.9,
          child: Text(
            widget.controller.cardNames[index],
            style: TextStyle(
              fontSize: 12,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        )
      ],
    );
  }
}
