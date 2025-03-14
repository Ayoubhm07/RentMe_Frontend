import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:khedma/theme/AppTheme.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../Services/SharedPrefService.dart';

class CompleteProfileController {
  SharedPrefService sharedPrefService = SharedPrefService();
  List<String?> _selectedImagePaths = ['', '', ''];
  List<String> _selectedSpecialities = [];
  final TextEditingController _controller = TextEditingController();

  Map<String, dynamic> validate() {
    String errorMessage = '';
    Map<String, dynamic> result = {};
    String images = _selectedImagePaths.join();

    if (_selectedSpecialities.isEmpty) {
      errorMessage = 'Veuillez sélectionner une spécialité';
      result = {'error': true, 'message': errorMessage};
    } else if(_controller.text.isEmpty)
    {
      errorMessage = 'Veuillez remplir la description';
      result = {'error': true, 'message': errorMessage};
    }
    else if (images.isEmpty) {
      errorMessage = 'Veuillez ajouter un projet';
      result = {'error': true, 'message': errorMessage};
    }
    return result;
  }

  void save() {
    // iterate the list of spes and add only the not empty one in the same string separated by ,
    String specialities = '';
    String images = '';
    for(String i in _selectedSpecialities) {
      if (i.isNotEmpty) {
        if (specialities.isEmpty) {
          specialities = i;
        }
        else {
          specialities = specialities + ',' + i;
        }
      }
    }

    for(String? j in _selectedImagePaths) {
      if (j!.isNotEmpty) {
        if (images.isEmpty) {
          images = j;
        }
        else {
          images = '$images,$j';
        }
      }
    }
    sharedPrefService.saveStringToPrefs('specialities', specialities);
    sharedPrefService.saveStringToPrefs('projets', images);
    sharedPrefService.saveStringToPrefs('description', _controller.text);
  }
}

class CompleteProfile extends StatefulWidget {
  final CompleteProfileController controller;

  CompleteProfile({Key? key, required this.controller}) : super(key: key);

  @override
  _CompleteProfileState createState() => _CompleteProfileState();
}

class _CompleteProfileState extends State<CompleteProfile> {
  List<String> _specialities = [];
  bool isAmateur = true;

  @override
  void initState() {
    super.initState();
    _loadSpecialities();

  }

  Future<void> _loadSpecialities() async {
    final String response = await rootBundle.loadString('assets/json/job.json');
    final List<dynamic> data = json.decode(response);
    String currentRole = await widget.controller.sharedPrefService.readStringFromPrefs('newRole');
    setState(() {
      isAmateur = currentRole == 'amateur';
      _specialities = List<String>.from(data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFFFFFFFF),
            borderRadius: BorderRadius.circular(40),
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(34, 123, 34, 55.1),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 10.6),
                  child: Text(
                    'Complétez votre profile',
                    style: GoogleFonts.roboto(
                      fontWeight: FontWeight.w600,
                      fontSize: 22.3,
                      height: 1.4,
                      color: Color(0xFF1C1F1E),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 17.4),
                  child: Text(
                    'Nous souhaitons mieux vous connaître afin de finaliser votre profile.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.dmSans(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      color: Color(0xFFA7A6A5),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 22.1),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        color: Color(0xFFF4F6F5),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x11124565),
                            offset: Offset(0, 4.8),
                            blurRadius: 7.14,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(19, 11.4, 19, 11.4),
                        child: Autocomplete<String>(
                          optionsBuilder: (TextEditingValue textEditingValue) {
                            if (textEditingValue.text.isEmpty) {
                              return const Iterable<String>.empty();
                            }
                            return _specialities.where((String option) {
                              return option.toLowerCase().startsWith(
                                  textEditingValue.text.toLowerCase());
                            });
                          },
                          onSelected: (String selection) {
                            setState(() {
                              if (!widget.controller._selectedSpecialities
                                  .contains(selection)) {
                                widget.controller._selectedSpecialities
                                    .add(selection);
                              }
                            });
                          },
                          fieldViewBuilder: (context, controller, focusNode,
                              onEditingComplete) {
                            return TextField(
                              controller: controller,
                              focusNode: focusNode,
                              onEditingComplete: onEditingComplete,
                              decoration: InputDecoration(
                                hintText: 'Spécialisé en:',
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 24),
                  child: SizedBox(
                    width: 264,
                    child: Wrap(
                      spacing: 12,
                      runSpacing: 8,
                      children: widget.controller._selectedSpecialities
                          .map((speciality) =>
                          _buildSpecializationCard(speciality))
                          .toList(),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 22.1),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        color: Color(0xFFF4F6F5),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x11124565),
                            offset: Offset(0, 4.8),
                            blurRadius: 7.14,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(19, 11.4, 19, 11.4),
                        child: TextField(
                          controller: widget.controller._controller,
                          minLines: 3,
                          maxLines: 5,
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.w400,
                            fontSize: 13.3,
                            height: 1.6,
                            color: Color(0xFF141414),
                          ),
                          decoration: InputDecoration(
                            hintText: 'Description',
                            border: InputBorder.none,
                            isDense: true, // Réduit la hauteur du TextField
                            contentPadding: EdgeInsets
                                .zero, // Supprime les marges intérieures
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(5.2, 0, 0, 17),
                  child: Text(
                    'Proposez votre tarif par l’unité qui vous convient.',
                    style: GoogleFonts.dmSans(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      color: Color(0xFFA7A6A5),
                    ),
                  ),
                ),
                /*
                Container(
                  margin: EdgeInsets.only(bottom: 30.8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Prix Section
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Prix :',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: Color(0xFF000000),
                            ),
                          ),
                          SizedBox(height: 5),
                          SizedBox(
                            width: 60, // Minimum width for the text field
                            child: TextFormField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: Color(0xFF0099D5),
                                  ),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 12,
                                ),
                              ),
                              keyboardType: TextInputType.number,
                              initialValue: '50',
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 30),
                      // Par Section
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Par :',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: Color(0xFF000000),
                              ),
                            ),
                            SizedBox(height: 5),
                            DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: Color(0xFF0099D5),
                                  ),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 12,
                                ),
                              ),
                              value: 'Heure',
                              items: <String>[
                                'Heure',
                                'Jour',
                                'Semaine',
                                'Mois',
                                'Année'
                              ].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                // Handle dropdown value change
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
               */
                Container(
                  margin: EdgeInsets.only(bottom: 30.1),
                  child: Text(
                    isAmateur
                        ? 'Ajoutez vos projets'
                        : 'Ajoutez vos certificats',
                    style: GoogleFonts.roboto(
                      fontWeight: FontWeight.w600,
                      fontSize: 14.9,
                      color: Color(0xFF1C1F1E),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildCard(0.27.sw, AppTheme.primaryColor, 0),
                    SizedBox(width: 10.h),
                    _buildCard(0.27.sw, AppTheme.primaryColor, 1),
                    SizedBox(width: 10.h),
                    _buildCard(0.27.sw, AppTheme.primaryColor, 2),
                  ],
                ),
              ],
            ),
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
                  child: widget.controller._selectedImagePaths[index] != ''
                      ? /*Image.file(
                          File(widget.controller._selectedImagePaths[index]!),
                          width: size * 0.4,
                          height: size * 0.4,
                          fit: BoxFit.cover,
                        )*/

                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.picture_as_pdf,
                        color: Colors.red,
                        size: size * 0.4,
                      ),
                      SizedBox(height: 8),
                      Text(
                        File(widget
                            .controller._selectedImagePaths[index]!)
                            .path
                            .split('/')
                            .last.substring(0,12),
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
                    if (widget.controller._selectedImagePaths[index] == '') {
                      FilePickerResult? result =
                      await FilePicker.platform.pickFiles(
                        type: FileType.custom,
                        allowedExtensions: ['pdf'],
                      );
                      if (result != null) {
                        String filePath = result.files.single.path!;
                        setState(() {
                          widget.controller._selectedImagePaths[index] =
                              filePath; // Met à jour l'image spécifique à l'index
                        });
                      } else {
                        print("Aucun fichier sélectionné");
                      }
                    } else {
                      setState(() {
                        widget.controller._selectedImagePaths[index] = '';
                      });
                    }
                  },
                  child: Center(
                    child: widget.controller._selectedImagePaths[index] != ''
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
      ],
    );
  }

  Widget _buildSpecializationCard(String text) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFF064BA6)),
        borderRadius: BorderRadius.circular(22),
        color: Color(0xFFFFFFFF),
        boxShadow: [
          BoxShadow(
            color: Color(0x0C8E8E8E),
            offset: Offset(0, 2),
            blurRadius: 3,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(14, 6, 10, 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: GoogleFonts.roboto(
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: Color(0xFF064BA6),
              ),
            ),
            SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                setState(() {
                  widget.controller._selectedSpecialities.remove(text);
                });
              },
              child: Icon(
                Icons.close,
                size: 16,
                color: Color(0xFF064BA6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}