import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:khedma/theme/AppTheme.dart';

import '../../Services/SharedPrefService.dart';

class FormDiplomeController {
  SharedPrefService sharedPrefService = SharedPrefService();
  List<String> _selectedFormatinos = ['', '', ''];
  String _selectedDiplome = '';

  Map<String, dynamic> validate() {
    String errorMessage = '';
    Map<String, dynamic> result = {};
    String formations = _selectedFormatinos.join();

    if (_selectedDiplome == '') {
      errorMessage = 'Veuillez ajouter votre diplome';
      result = {'error': true, 'message': errorMessage};
    } else if (formations == '') {
      errorMessage = 'Veuillez ajouter vos formations';
      result = {'error': true, 'message': errorMessage};
    }
    return result;
  }

  void save() {
    sharedPrefService.saveStringToPrefs('diplome', _selectedDiplome);
    String formations = '';
    for (String f in _selectedFormatinos) {
      if (formations.isEmpty) {
        formations = f;
      } else {
        if (f.isNotEmpty) {
          formations = formations + ',' + f;
        }
      }
    }
    sharedPrefService.saveStringToPrefs('formations', formations);
  }
}

class formDiplome extends StatefulWidget {
  final FormDiplomeController controller;

  formDiplome({Key? key, required this.controller}) : super(key: key);

  @override
  _formDiplomeState createState() => _formDiplomeState();
}

class _formDiplomeState extends State<formDiplome> {
  @override
  void initState() {
    super.initState();
  }

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
                  // Ajustez cette valeur pour réduire l'espace
                  Center(
                    child: Container(
                      width: 0.8.sw,
                      child: Text(
                        'Avez vous un diplôme ?',
                        style: TextStyle(
                          fontSize: 0.06.sw,
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
                        'Nous souhaitons mieux vous connaître afin de finaliser votre profile.',
                        style: TextStyle(
                          fontSize: 0.04.sw,
                          color: AppTheme.accentColor,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w500,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(height: 50.h),
                  Text(
                    'Diplome',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildDiplomeCard(0.27.sw, AppTheme.primaryColor),
                    ],
                  ),
                  SizedBox(height: 50.h),
                  Text(
                    'Formations',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20.h),

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
          );
        },
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
                  child: widget.controller._selectedFormatinos[index] != ''
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
                              File(widget.controller._selectedFormatinos[index])
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
                    if (widget.controller._selectedFormatinos[index] == '') {
                      FilePickerResult? result =
                          await FilePicker.platform.pickFiles(
                        type: FileType.custom,
                        allowedExtensions: ['pdf'],
                      );
                      if (result != null) {
                        String filePath = result.files.single.path!;
                        setState(() {
                          widget.controller._selectedFormatinos[index] =
                              filePath; // Met à jour l'image spécifique à l'index
                        });
                      } else {
                        print("Aucun fichier sélectionné");
                      }
                    } else {
                      setState(() {
                        widget.controller._selectedFormatinos[index] = '';
                      });
                    }
                  },
                  child: Center(
                    child: widget.controller._selectedFormatinos[index] != ''
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

  Widget _buildDiplomeCard(double size, Color color) {
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
                  child: widget.controller._selectedDiplome != ''
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
                              File(widget.controller._selectedDiplome)
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
                    if (widget.controller._selectedDiplome == '') {
                      FilePickerResult? result =
                          await FilePicker.platform.pickFiles(
                        type: FileType.custom,
                        allowedExtensions: ['pdf'],
                      );
                      if (result != null) {
                        String filePath = result.files.single.path!;
                        setState(() {
                          widget.controller._selectedDiplome =
                              filePath; // Met à jour l'image spécifique à l'index
                        });
                      } else {
                        print("Aucun fichier sélectionné");
                      }
                    } else {
                      setState(() {
                        widget.controller._selectedDiplome = '';
                      });
                    }
                  },
                  child: Center(
                    child: widget.controller._selectedDiplome != ''
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
}
