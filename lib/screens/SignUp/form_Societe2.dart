import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khedma/Services/SharedPrefService.dart';

import '../../theme/AppTheme.dart';


class FormSociete2Controller{
  SharedPrefService sharedPrefService = SharedPrefService();
   TextEditingController ancientClientsController = TextEditingController();
   TextEditingController nombreSalariesController = TextEditingController();


  Map<String, dynamic> validate()
  {
    Map<String, dynamic> result = {};

    String errorMessage = '';
    if (ancientClientsController.text.isEmpty || nombreSalariesController.text.isEmpty) {
      errorMessage = 'Veuillez remplir tous les champs';
      result = {'error': true, 'message': errorMessage};
    }

    return result;
  }
  void save()
  {
    sharedPrefService.saveUserData('AncientClients', ancientClientsController.text);
    sharedPrefService.saveUserData('NombreSalaries', nombreSalariesController.text);
  }
}
class FormSociete2 extends StatefulWidget {
  final FormSociete2Controller controller;

  const FormSociete2({Key? key, required this.controller}) : super(key: key);
  @override
  _FormSociete2State createState() => _FormSociete2State();
}

class _FormSociete2State extends State<FormSociete2> {
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
                  SizedBox(height: 50.h), // Ajustez cette valeur pour réduire l'espace

                  Center(
                    child: Container(
                      width: 0.8.sw,
                      child: Text(
                        'Vos justificatifs professionnels',
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

                  SizedBox(height: 30.h),
                  _buildTextField({
                    'label': 'Ancient clients:',
                    'hint': 'Ancient clients:',
                  }),
                  SizedBox(height: 10.h),
                  _buildTextField({
                    'label': 'Nombre de salariés:',
                    'hint': 'Nombre de salariés:',
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
        controller: textFieldData['label'] == 'Ancient clients:' ? widget.controller.ancientClientsController : widget.controller.nombreSalariesController,
        keyboardType: textFieldData['label'] == 'Ancient clients:' ? TextInputType.text : TextInputType.number,
        decoration: InputDecoration(
          hintText: textFieldData['hint'],
          contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0), // Ajoutez le padding ici
          hintStyle: TextStyle(color: AppTheme.secondaryColor), // Changer la couleur du hint text ici

          border: UnderlineInputBorder(
            borderSide: BorderSide(color: AppTheme.grisTextField), // Bordure blanche
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: AppTheme.grisTextField), // Bordure blanche quand inactif
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: AppTheme.grisTextField), // Bordure blanche quand actif
          ),

        ),
      ),
    );
  }
}
