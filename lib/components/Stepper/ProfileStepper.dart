import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khedma/Services/MinIOService.dart';
import 'package:khedma/Services/ProfileService.dart';
import 'package:khedma/Services/UserService.dart';
import 'package:khedma/components/Stepper/stepperComplet.dart';
import 'package:khedma/entities/ProfileDetails.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Services/SharedPrefService.dart';
import '../../entities/User.dart';
import '../../screens/MainPages/HomePage.dart';
import '../../screens/SignUp/DonneeAdresse.dart';
import '../../screens/SignUp/form_experience.dart';
import '../../screens/SignUp/form_societe.dart';
import '../../screens/SignUp/form_Societe2.dart';
import '../../screens/SignUp/formDiplome.dart';
import '../../screens/SignUp/Donne_profile.dart';
import '../../screens/SignUp/Complete_profile.dart';
import '../../theme/AppTheme.dart';

class ProfileStepper extends StatefulWidget {
  const ProfileStepper({super.key});

  @override
  ProfileStepperState createState() => ProfileStepperState();
}

class ProfileStepperState extends State<ProfileStepper> {
  int currentStep = 0;
  int totalSteps = 5;
  late UserService us;
  late SharedPrefService sharedPrefService;
  String role = "USER";
  Map<String, dynamic> validationErrors = {};
  final DonneeProfileController donneeProfileController =
      DonneeProfileController();
  final CompleteProfileController completeProfileController =
      CompleteProfileController();
  final DonneeadresseController donneeadresseController =
      DonneeadresseController();
  final FormExperienceController formExperienceController =
      FormExperienceController();
  final FormSocieteController formSocieteController = FormSocieteController();
  final FormSociete2Controller formSociete2Controller =
      FormSociete2Controller();
  final FormDiplomeController formDiplomeController = FormDiplomeController();
  String formationsfiles = '';
  String projetsfiles = '';
  String ProfilePicturefile = '';
  String Diplomefile = '';
  String Kbisfile = '';
  String qualiteFile = '';
  String assuranceFile = '';

 // add assurance to spring
  Future<bool> SaveProfileDetailsFiles() async{
    MinIOService minIOService = MinIOService();
    final prefs = await SharedPreferences.getInstance();
    // saving formations
    String formations = '';
    formations = await prefs.getString('formations') ?? '';
    await prefs.remove('formations');
    print('formations: $formations');

    List<String> formationsList = formations.split(',');
    print('formationsList: $formationsList');
    for (String formation in formationsList) {
      print('formation: $formation');
      String fileName =
      await minIOService.saveFileToServer("files", File(formation));
      if (formationsfiles.isEmpty) {
        formationsfiles = fileName;
      } else {
        formationsfiles = '$formationsfiles,$fileName';
      }
    }
    print('formationsfiles: $formationsfiles');
    // saving projects
    String projets = '';
    projets = await prefs.getString('projets') ?? '';
    await prefs.remove('projets');
    print('projets: $projets');
    List<String> ProjetsList = projets.split(',');
    print('ProjetsList: $ProjetsList');
    for (String projet in ProjetsList) {
      print('projet: $projet');
      String file = await minIOService.saveFileToServer("files", File(projet));
      if (projetsfiles.isEmpty) {
        projetsfiles = file;
      } else {
        projetsfiles = '$projetsfiles,$file';
      }
    }
    print('projetsfiles: $projetsfiles');
    // saving profile picture
    String ProfilePicture = prefs.getString('image') ?? '';
    await prefs.remove('image');
     ProfilePicturefile =
        await minIOService.saveFileToServer("images", File(ProfilePicture));
    // saving diplome
    String Diplome = prefs.getString('diplome') ?? '';
    await prefs.remove('diplome');
     Diplomefile =
        await minIOService.saveFileToServer("files", File(Diplome));
    if(formationsfiles.isNotEmpty && projetsfiles.isNotEmpty && ProfilePicturefile.isNotEmpty && Diplomefile.isNotEmpty){
      return true;
    }else{
      return false;
    }
  }
  Future<bool> SaveProfileDetailsFilesPro() async{
    MinIOService minIOService = MinIOService();
    final prefs = await SharedPreferences.getInstance();
    // saving formations
    String formations = '';
    formations = await prefs.getString('formations') ?? '';
    await prefs.remove('formations');
    print('formations: $formations');

    List<String> formationsList = formations.split(',');
    print('formationsList: $formationsList');
    for (String formation in formationsList) {
      print('formation: $formation');
      String fileName =
      await minIOService.saveFileToServer("files", File(formation));
      if (formationsfiles.isEmpty) {
        formationsfiles = fileName;
      } else {
        formationsfiles = '$formationsfiles,$fileName';
      }
    }
    print('formationsfiles: $formationsfiles');
    // saving projects
    String projets = '';
    projets = await prefs.getString('projets') ?? '';
    await prefs.remove('projets');
    print('projets: $projets');
    List<String> ProjetsList = projets.split(',');
    print('ProjetsList: $ProjetsList');
    for (String projet in ProjetsList) {
      print('projet: $projet');
      String file = await minIOService.saveFileToServer("files", File(projet));
      if (projetsfiles.isEmpty) {
        projetsfiles = file;
      } else {
        projetsfiles = '$projetsfiles,$file';
      }
    }
    print('projetsfiles: $projetsfiles');
    // saving profile picture
    String ProfilePicture = prefs.getString('image') ?? '';
    await prefs.remove('image');
    ProfilePicturefile = await minIOService.saveFileToServer("images", File(ProfilePicture));
    // saving diplome
    String Diplome = prefs.getString('diplome') ?? '';
    await prefs.remove('diplome');
    Diplomefile = await minIOService.saveFileToServer("files", File(Diplome));
    String Kbis = prefs.getString('KBIS') ?? '';
    await prefs.remove('KBIS');
    Kbisfile = await minIOService.saveFileToServer("files", File(Kbis));
    String qualite = prefs.getString('LabelQualite') ?? '';
    await prefs.remove('LabelQualite');
    qualiteFile = await minIOService.saveFileToServer("files", File(qualite));
    String assurance = prefs.getString('Assurance') ?? '';
    await prefs.remove('Assurance');
    assuranceFile = await minIOService.saveFileToServer("files", File(assurance));
    if(formationsfiles.isNotEmpty && projetsfiles.isNotEmpty && ProfilePicturefile.isNotEmpty && Diplomefile.isNotEmpty && Kbisfile.isNotEmpty && qualiteFile.isNotEmpty && assuranceFile.isNotEmpty){
      return true;
    }else{
      return false;
    }
  }
  Future<bool> SaveProfileDetailsForAmateur() async {
    ProfileService profileService = ProfileService();
    User user = await sharedPrefService.getUser();
    int? userId = user.id;
    ProfileDetails profileDetails = ProfileDetails(
      profilePicture: ProfilePicturefile,
      description: await sharedPrefService.readStringFromPrefs('description') ?? '',
      specialite: await sharedPrefService.readStringFromPrefs('specialities') ?? '',
      projets: projetsfiles,
      diplome: Diplomefile,
      formations: formationsfiles,
      rue: await sharedPrefService.readStringFromPrefs('Adresse') ?? '',
      ville: await sharedPrefService.readStringFromPrefs('Ville') ?? '',
      codePostal: await sharedPrefService.readStringFromPrefs('CodePostal') ?? '',
      pays: await sharedPrefService.readStringFromPrefs('Pays') ?? '',
      titre: await sharedPrefService.readStringFromPrefs('titre') ?? '',
      nomSocieteExp: await sharedPrefService.readStringFromPrefs('nomSocieteExp') ?? '',
      dateDebut: await sharedPrefService.readStringFromPrefs('startDateExp') ?? '',
      dateFin: await sharedPrefService.readStringFromPrefs('endDateExp') ?? '',
      descriptionExp: await sharedPrefService.readStringFromPrefs('descriptionExp') ?? '',
      userId: userId!,
    );
    await sharedPrefService.clearStringFromPrefs('description');
    await sharedPrefService.clearStringFromPrefs('specialities');
    await sharedPrefService.clearStringFromPrefs('Adresse');
    await sharedPrefService.clearStringFromPrefs('Ville');
    await sharedPrefService.clearStringFromPrefs('CodePostal');
    await sharedPrefService.clearStringFromPrefs('Pays');
    await sharedPrefService.clearStringFromPrefs('titre');
    await sharedPrefService.clearStringFromPrefs('nomSocieteExp');
    await sharedPrefService.clearStringFromPrefs('startDateExp');
    await sharedPrefService.clearStringFromPrefs('endDateExp');
    await sharedPrefService.clearStringFromPrefs('descriptionExp');

    bool finished = await profileService.saveProfileDetails(profileDetails);
    return finished;
  }
  Future<bool> SaveProfileDetailsForPro() async {
    ProfileService profileService = ProfileService();
    User user = await sharedPrefService.getUser();
    int? userId = user.id;
    ProfileDetails profileDetails = ProfileDetails(
      profilePicture: ProfilePicturefile,
      description: await sharedPrefService.readStringFromPrefs('description') ?? '',
      specialite: await sharedPrefService.readStringFromPrefs('specialities') ?? '',
      certifications: projetsfiles,
      diplome: Diplomefile,
      formations: formationsfiles,
      rue: await sharedPrefService.readStringFromPrefs('Adresse') ?? '',
      ville: await sharedPrefService.readStringFromPrefs('Ville') ?? '',
      codePostal: await sharedPrefService.readStringFromPrefs('CodePostal') ?? '',
      pays: await sharedPrefService.readStringFromPrefs('Pays') ?? '',
      titre: await sharedPrefService.readStringFromPrefs('titre') ?? '',
      nomSocieteExp: await sharedPrefService.readStringFromPrefs('nomSocieteExp') ?? '',
      dateDebut: await sharedPrefService.readStringFromPrefs('startDateExp') ?? '',
      dateFin: await sharedPrefService.readStringFromPrefs('endDateExp') ?? '',
      descriptionExp: await sharedPrefService.readStringFromPrefs('descriptionExp') ?? '',
      kbis: Kbisfile,
      labelQualite: qualiteFile,
      assurance: assuranceFile,
      nomSociete: await sharedPrefService.readStringFromPrefs('nomSociete') ?? '',
      domaine: await sharedPrefService.readStringFromPrefs('DomaineActivite') ?? '',
      ancienClients: await sharedPrefService.readStringFromPrefs('AncientClients') ?? '',
      nombreSalaries: int.parse(await sharedPrefService.readStringFromPrefs('NombreSalaries') ?? '0'),
      userId: userId!,
    );

    await sharedPrefService.clearStringFromPrefs('description');
    await sharedPrefService.clearStringFromPrefs('specialities');
    await sharedPrefService.clearStringFromPrefs('Adresse');
    await sharedPrefService.clearStringFromPrefs('Ville');
    await sharedPrefService.clearStringFromPrefs('CodePostal');
    await sharedPrefService.clearStringFromPrefs('Pays');
    await sharedPrefService.clearStringFromPrefs('titre');
    await sharedPrefService.clearStringFromPrefs('nomSocieteExp');
    await sharedPrefService.clearStringFromPrefs('startDateExp');
    await sharedPrefService.clearStringFromPrefs('endDateExp');
    await sharedPrefService.clearStringFromPrefs('descriptionExp');
    await sharedPrefService.clearStringFromPrefs('nomSociete');
    await sharedPrefService.clearStringFromPrefs('DomaineActivite');
    await sharedPrefService.clearStringFromPrefs('AncientClients');
    await sharedPrefService.clearStringFromPrefs('NombreSalaries');

    bool finished = await profileService.saveProfileDetails(profileDetails);
    return finished;
  }
  Future<void> dothework()async{
    bool isSavingProfileDetailsFiles = await SaveProfileDetailsFiles();
    if(isSavingProfileDetailsFiles){
      print('Files saved');
      bool isSavingProfileDetailsForAmateur = await SaveProfileDetailsForAmateur();
      if(isSavingProfileDetailsForAmateur){
        print('Profile details saved');
        bool isProfileSetAndRole = await updateIsProfileSetAndRole();
        if(isProfileSetAndRole){
           print('Profile is set and role is updated');
        }
      }
    }
  }
  Future<void> dotheworkPro()async{
    bool isSavingProfileDetailsFiles = await SaveProfileDetailsFilesPro();
    if(isSavingProfileDetailsFiles){
      print(' pro Files saved');
      bool isSavingProfileDetailsForPro = await SaveProfileDetailsForPro();
      if(isSavingProfileDetailsForPro){
        print('pro Profile details saved');
        bool isProfileSetAndRole = await updateIsProfileSetAndRole();
        if(isProfileSetAndRole){
          print('pro Profile is set and role is updated');
        }
      }
    }
  }
  Future<bool> updateIsProfileSetAndRole() async {
    bool finished = false ;
    User? user = await sharedPrefService.getUser();
    user.isProfileCompleted = true;
    String newRole = await sharedPrefService.readStringFromPrefs('newRole');
    user.roles = newRole;
    finished = await us.updateUser(user);
    return finished;
  }

  @override
  void initState() {
    super.initState();
    us = UserService();
    sharedPrefService = SharedPrefService();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                if (currentStep > 0) {
                  setState(() {
                    currentStep--;
                  });
                } else {
                  Navigator.of(context).pop();
                }
              },
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: LinearProgressIndicator(
                        value: currentStep / totalSteps,
                        backgroundColor: Colors.grey[200],
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(Colors.blue),
                        minHeight: 4.h,
                      ),
                    ),
                    CircleAvatar(
                      radius: 15.r,
                      backgroundColor: currentStep >= totalSteps
                          ? Colors.green
                          : Colors.grey[200],
                      child: Icon(
                        Icons.check_circle_outline_outlined,
                        color: currentStep >= totalSteps
                            ? Colors.white
                            : Colors.grey[600],
                        size: 20.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                ///////////houuni
                alignment: Alignment.topCenter,
                children: [_getPageForStep(currentStep)],
              ),
            ),
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.w),
              child: Center(
                // buttons continuer, ignorer
                child: _buildButtonsForStep(currentStep),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getPageForStep(int step) {
    if (step == 0) {
      return DonneeProfile(controller: donneeProfileController);
    }
    if (role == "amateur") {
      switch (step) {
        case 1:
          return CompleteProfile(controller: this.completeProfileController);
        case 2:
          return Donneeadresse(controller: donneeadresseController);
        case 3:
          return formDiplome(controller: this.formDiplomeController);
        case 4:
          return FormExperience(controller: this.formExperienceController);
        case 5:
          dothework();
          return Steppercomplet();
        default:
          return const Center(child: Text('Étape inconnue'));
      }
    } else {
      switch (step) {
        case 1:
          return CompleteProfile(controller: this.completeProfileController);
        case 2:
          return Donneeadresse(controller: donneeadresseController);
        case 3:
          return formDiplome(controller: this.formDiplomeController);
        case 4:
          return FormExperience(controller: this.formExperienceController);
        case 5:
          return FormSociete(controller: this.formSocieteController);
        case 6:
          return FormSociete2(controller: this.formSociete2Controller);
        case 7:
          dotheworkPro();
          return Steppercomplet();
        default:
          return const Center(child: Text('Étape inconnue'));
      }
    }
  }

  Map<String, dynamic> _validateStep(int step) {
    if (step == 0) {
      return donneeProfileController.validate();
    }
    if (role == "amateur") {
      switch (step) {
        case 1:
          return completeProfileController.validate();
        case 2:
          return donneeadresseController.validate();
        case 3:
          return formDiplomeController.validate();
        case 4:
          return formExperienceController.validate();
        default:
          return <String, dynamic>{};
      }
    } else {
      switch (step) {
        case 1:
          return completeProfileController.validate();
        case 2:
          return donneeadresseController.validate();
        case 3:
          return formDiplomeController.validate();
        case 4:
          return formExperienceController.validate();
        case 5:
          return formSocieteController.validate();
        case 6:
          return formSociete2Controller.validate();
        default:
          return <String, dynamic>{};
      }
    }
  }

  void _SaveStep(int step) {

    if (role == "amateur") {
      switch (step) {
        case 1:
          return completeProfileController.save();
        case 2:
          return donneeadresseController.save();
        case 3:
          return formDiplomeController.save();
        case 4:
          return formExperienceController.save();
        default:
          return;
      }
    } else {
      switch (step) {
        case 1:
          return completeProfileController.save();
        case 2:
          return donneeadresseController.save();
        case 3:
          return formDiplomeController.save();
        case 4:
          return formExperienceController.save();
        case 5:
          return formSocieteController.save();
        case 6:
          return formSociete2Controller.save();

        default:
          return;
      }
    }
  }

  Widget _buildButtonsForStep(int step) {
    if (step == 0) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  this.validationErrors = _validateStep(currentStep);
                  if (this.validationErrors.isEmpty) {
                    donneeProfileController.save();
                    sharedPrefService.readStringFromPrefs('role').then((value) {
                      role = value;
                      if (role == "amateur") {
                        totalSteps = 5;
                      } else {
                        totalSteps = 7;
                      }
                      currentStep++;
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(validationErrors['message']),
                        backgroundColor: Colors.redAccent,
                        behavior: SnackBarBehavior.floating,
                        // add a button to dismiss the snackbar
                        // add time duration to dismiss the snackbar
                        duration: const Duration(seconds: 1),
                        action: SnackBarAction(
                          label: 'OK',
                          textColor: Colors.white,
                          onPressed: () {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          },
                        ),
                      ),
                    );
                  }
                });
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                backgroundColor: AppTheme.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.33.r),
                ),
              ),
              child: Text(
                'Continuer',
                style: TextStyle(
                  fontSize: 0.034.sw,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  // go home
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );
                });
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                backgroundColor: AppTheme.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.33.r),
                ),
              ),
              child: Text(
                'Je suis un client',
                style: TextStyle(
                  fontSize: 0.034.sw,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      );
    }
    if (step == totalSteps) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Center(
          child: Container(
            width: 0.4.sw,
            child: ElevatedButton(
              onPressed: () {
                sharedPrefService.checkAllValues();
                // Naviguer vers HomeScreen
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                backgroundColor: AppTheme.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.33.r),
                ),
              ),
              child: Text(
                'Continuer vers l\'accueil',
                style: TextStyle(
                  fontSize: 0.034.sw,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Center(
          child: Container(
            width: 0.4.sw,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  this.validationErrors = _validateStep(currentStep);
                  if (this.validationErrors.isNotEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(validationErrors['message']),
                        backgroundColor: Colors.redAccent,
                        behavior: SnackBarBehavior.floating,
                        duration: const Duration(seconds: 1),
                        action: SnackBarAction(
                          label: 'OK',
                          textColor: Colors.white,
                          onPressed: () {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          },
                        ),
                      ),
                    );
                  } else {
                    _SaveStep(currentStep);
                    currentStep++;
                  }
                });
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                backgroundColor: AppTheme.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.33.r),
                ),
              ),
              child: Text(
                'Continuer',
                style: TextStyle(
                  fontSize: 0.034.sw,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      );
    }
  }
}
