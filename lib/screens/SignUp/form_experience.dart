import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../Services/SharedPrefService.dart';
import '../../theme/AppTheme.dart';

class FormExperienceController {
  SharedPrefService sharedPrefService = SharedPrefService();
  TextEditingController titreController = TextEditingController();
  TextEditingController nomSocieteController = TextEditingController();
  TextEditingController desctiptionController = TextEditingController();

  DateTime? startDate;
  DateTime? endDate;

  Map<String, dynamic> validate() {
    Map<String, dynamic> result = {};
    String errorMessage = '';
    if(titreController.text.isEmpty || nomSocieteController.text.isEmpty){
      errorMessage = 'Veuillez remplir tous les champs';
      result = {'error': true, 'message': errorMessage};
    }
    else if(startDate == null || endDate == null){
      errorMessage = 'Veuillez remplir les dates';
      result = {'error': true, 'message': errorMessage};
    }
    else if (startDate!.isAfter(endDate!) ) {
      errorMessage = 'La date de début doit être avant la date de fin';
      result = {'error': true, 'message': errorMessage};
    }
    else if(startDate!.isAfter(endDate!.subtract(Duration(days: 30)))){
      errorMessage = 'La période doit être d\'au moins 30 jours';
      result = {'error': true, 'message': errorMessage};
    }
    else if (desctiptionController.text.isEmpty)
    {
      errorMessage = 'Veuillez remplir tous les champs';
      result = {'error': true, 'message': errorMessage};
    }
    return result;
  }

  void save() {
    sharedPrefService.saveStringToPrefs('titre', titreController.text);
    sharedPrefService.saveStringToPrefs('nomSocieteExp', nomSocieteController.text);
    sharedPrefService.saveStringToPrefs('descriptionExp', desctiptionController.text);
    sharedPrefService.saveStringToPrefs('startDateExp', startDate.toString());
    sharedPrefService.saveStringToPrefs('endDateExp', endDate.toString());
  }
}

class FormExperience extends StatefulWidget {
  final FormExperienceController controller;

  const FormExperience({Key? key, required this.controller}) : super(key: key);

  @override
  State<FormExperience> createState() => _FormExperienceState();
}

class _FormExperienceState extends State<FormExperience> {
  @override
  void dispose() {
    // Dispose les contrôleurs pour éviter les fuites de mémoire
    super.dispose();
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
                  Center(
                    child: Container(
                      width: 0.8.sw,
                      child: Text(
                        'Avez-vous une expérience ?',
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
                        'Nous souhaitons découvrir votre expérience.',
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
                    'label': 'Titre:',
                    'hint': 'Titre:',
                  }),
                  SizedBox(height: 10.h),
                  _buildTextField({
                    'label': 'Nom de société précédente:',
                    'hint': 'Nom de société précédente:',
                  }),
                  SizedBox(height: 50.h),
                  Text(
                    'Période',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    // Padding horizontal pour 'Du'
                    child: Text(
                      'Du:',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.blue,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Center(
                    child: ElevatedButton(
                      onPressed: () => _selectDate(context, true),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, backgroundColor: Colors.blue, // Text color
                        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: Text(widget.controller.startDate == null
                          ? 'Sélectionner une date'
                          : '${widget.controller.startDate!.day}/${widget.controller.startDate!.month}/${widget.controller.startDate!.year}'),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    // Padding horizontal pour 'Du'
                    child: Text(
                      'Jusqu' 'à:',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.blue,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Center(
                    child: ElevatedButton(
                      onPressed: () => _selectDate(context, false),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, backgroundColor: Colors.blue, // Text color
                        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: Text(widget.controller.endDate == null
                          ? 'Sélectionner une date'
                          : '${widget.controller.endDate!.day}/${widget.controller.endDate!.month}/${widget.controller.endDate!.year}'),
                    ),
                  ),
                  SizedBox(height: 30.h),
                  _buildTextField({
                    'label': 'Description',
                    'hint': 'Description',
                  }),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField(Map<String, dynamic> textFieldData) {
    TextEditingController controller = TextEditingController();
    if (textFieldData['label'] == 'Titre:')
      controller = widget.controller.titreController;
    if (textFieldData['label'] == 'Nom de société précédente:')
      controller = widget.controller.nomSocieteController;
    if (textFieldData['label'] == 'Description')
      controller = widget.controller.desctiptionController;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: AppTheme.grisTextField,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5.0,
            spreadRadius: 1.0,
            offset: Offset(0, 2.0),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        maxLines: textFieldData['label'] == 'Description' ? 5 : 2,
        minLines: textFieldData['label'] == 'Description' ? 3 : 1,
        decoration: InputDecoration(
          hintText: textFieldData['hint'],
          contentPadding:
          EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          hintStyle: TextStyle(color: AppTheme.secondaryColor),
          border: UnderlineInputBorder(
            borderSide:
            BorderSide(color: AppTheme.grisTextField), // Bordure blanche
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                color: AppTheme.grisTextField), // Bordure blanche quand inactif
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                color: AppTheme.grisTextField), // Bordure blanche quand actif
          ),
        ),
      ),
    );
  }

  void _selectDate(BuildContext context, bool isStartDate) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(Duration(days: 4)),
      firstDate: DateTime(1960),
      lastDate: DateTime.now(),

    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          widget.controller.startDate = picked;
        } else {
          widget.controller.endDate = picked;
        }
      });
    }
  }
}