import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:khedma/Services/DemandeService.dart';
import 'package:khedma/Services/LocationService.dart';
import 'package:khedma/Services/MinIOService.dart';
import 'package:khedma/Services/SharedPrefService.dart';
import 'package:khedma/entities/Location.dart';
import '../../entities/Demand.dart';
import '../../entities/User.dart';
import '../../theme/AppTheme.dart';
import '../Buttons/IndependentButtonGroup.dart';
import '../Buttons/MyButtons.dart';
import '../Card/SuccessNotificationCard.dart';

class CustomSwitch2 extends StatefulWidget {
  final List<String> buttonLabels;
  final BuildContext context;

  CustomSwitch2({super.key, required this.buttonLabels, required this.context});

  @override
  _CustomSwitch2State createState() => _CustomSwitch2State();
}

class _CustomSwitch2State extends State<CustomSwitch2> {
  List<bool> isSelected = [true, false];
  bool isLoading = false;
  bool showExpertQuestion = false;
  bool showBudgetField = false;
  bool showBudgetSlider = false;
  RangeValues _currentRangeValues = RangeValues(500, 5000);
  bool budgetUnder5000 =
      true;

  bool isYesSelected = false;
  bool isYesSelectedGroup1 = false;
  bool isYesSelectedGroup2 = false;

 late User currentUser;

  // page one text fields
  final TextEditingController _DomaineController =
      TextEditingController();
  final TextEditingController _TitleController =
  TextEditingController();// once for domain once for category
  final TextEditingController _descriptionController =
      TextEditingController(); // for description
  final TextEditingController _budgetController =
      TextEditingController(); // for budget

// page two text fields
  final TextEditingController _CategoryController =
      TextEditingController(); // once for domain once for category
  final TextEditingController _descriptionController2 =
      TextEditingController(); // for description
  final TextEditingController _prixcontroller =
      TextEditingController(); // for prix
  // set defeult for prix

  String? _selectedTimeUnit = 'Heure'; // Default value for dropdown
  String images = '';
  late DemandeService demandeService;
  late LocationService locationService;
  late SharedPrefService sharedPrefService;
  late MinIOService minIOService;
  List<File> _selectedImages = [];
  final int _maxImages = 5;

  @override
  void initState() {
    super.initState();
    demandeService = DemandeService();
    locationService = LocationService();
    sharedPrefService = SharedPrefService();
    minIOService = MinIOService();
    _loadUserId();
    _prixcontroller.text = '50';
  }

  void _loadUserId() async {
    User user = await sharedPrefService.getUser();
    setState(() {
      currentUser= user ;
    });
  }

  Future<String> GetUsername()async{
    User user = await sharedPrefService.getUser();
    return user.userName;
  }

  @override
  void dispose() {
    _DomaineController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  bool validateDemandeService() {
    if (_DomaineController.text.isEmpty ||
        _budgetController.text.isEmpty ||
        _descriptionController.text.isEmpty) {
      return false;
    }
    return true;
  }

  bool validateLocation() {
    if (_CategoryController.text.isEmpty ||
        _prixcontroller.text.isEmpty ||
        _descriptionController2.text.isEmpty ||
        _selectedImages.isEmpty) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(9.0),
              boxShadow: [
                BoxShadow(
                  color: Color(0x11000000),
                  blurRadius: 24,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: ToggleButtons(
              borderRadius: BorderRadius.circular(9.0),
              borderColor: Colors.transparent,
              selectedBorderColor: Colors.transparent,
              fillColor: const Color(0xFF2DC3FF),
              selectedColor: Colors.white,
              color: Colors.grey,
              constraints: BoxConstraints(
                minWidth: 150.0.w,
                minHeight: 44.0.h,
              ),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    widget.buttonLabels[0],
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: isSelected[0] ? Colors.white : Colors.grey,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    widget.buttonLabels[1],
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: isSelected[1] ? Colors.white : Colors.grey,
                    ),
                  ),
                ),
              ],
              onPressed: (int index) {
                setState(() {
                  for (int buttonIndex = 0;
                      buttonIndex < isSelected.length;
                      buttonIndex++) {
                    isSelected[buttonIndex] = (buttonIndex == index);
                  }
                });
              },
              isSelected: isSelected,
            ),
          ),
          SizedBox(height: 20.h),
          _buildContent(),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isSelected[0]) ...[
            _buildDomainSection(),
            SizedBox(height: 30.h),
            _buildTerminerSection(),
          ] else if (isSelected[1]) ...[
            _buildCategorieSection(),
          ],
        ],
      ),
    );
  }

  Widget _buildDomainSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Titre de la demande',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 10.h),
        TextField(
          controller: _TitleController,
          decoration: InputDecoration(
            hintText: 'Entrez le titre de votre demande',
            hintStyle: TextStyle(color: Colors.grey),
            prefixIcon: Icon(Icons.title, color: Color(0xFF0099D6)),
            filled: true,
            fillColor: Color(0xFFEDF4FF),
            contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        Text(
          'Domaine',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 10.h),
        TextField(
          controller: _DomaineController,
          decoration: InputDecoration(
            hintText: 'Ménage/Développ...',
            hintStyle: TextStyle(color: Colors.grey),
            prefixIcon: Icon(Icons.search, color: Color(0xFF0099D6)),
            filled: true,
            fillColor: Color(0xFFEDF4FF),
            contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              borderSide: BorderSide.none,
            ),
            suffixIcon: IconButton(
              icon: Icon(Icons.clear, color: Colors.grey),
              onPressed: () {
                _DomaineController.clear();
              },
            ),
          ),
        ),
        SizedBox(height: 16.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            CustomButton(
              text: 'Design',
              color: Color(0xFF2DC4FF),
              onPressed: () {
                _DomaineController.clear();
                _DomaineController.text = 'Design';
              },
              borderColor: Color(0xFF2DC4FF),
              textColor: Colors.white,
              textStyle: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        SizedBox(height: 30.h),
        _buildDescriptionTextField(
            'Description', 'Description', _descriptionController),
        SizedBox(height: 30.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: _buildBudgetField()),
          ],
        ),
        if (showExpertQuestion) ...[
          SizedBox(height: 30.h),
          Text(
            ' Votre demande dépasse 5000€, Avez-vous besoin d’un expert ?',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 30.h),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomYesNoButton(
                  onPressed: () {
                    setState(() {
                      isYesSelectedGroup2 =
                          true; // Mettez à jour pour le deuxième groupe
                      showBudgetField = false;
                      showBudgetSlider = false;
                    });
                  },
                  isYes: true,
                  isSelected: isYesSelectedGroup2,
                ),
                SizedBox(width: 30.w),
                CustomYesNoButton(
                  onPressed: () {
                    setState(() {
                      isYesSelectedGroup2 = false;
                      showBudgetField = true;
                      showBudgetSlider =
                          false; // Mettez à jour pour le deuxième groupe
                    });
                  },
                  isYes: false,
                  isSelected: !isYesSelectedGroup2,
                ),
              ],
            ),
          ),
          SizedBox(height: 30.h),
          Center(
            child: Text(
              textAlign: TextAlign.center,
              'Nous vous conseillons de consulter un expert.',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: Color(0xFFA7A6A5),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTerminerSection() {
    return FutureBuilder<String>(
      future: GetUsername(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("Failed to get username: ${snapshot.error}"));
        }

        String ownerName = snapshot.data!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 50.h),
            Center(
              child: isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });
                  if (validateDemandeService()) {
                    Demand newDemand = Demand(
                      ownerName: ownerName,
                      title: _TitleController.text,
                      domain: _DomaineController.text,
                      location: "MEDENINE YA HAAAJ",
                      description: _descriptionController.text,
                      budget: double.parse(_budgetController.text),
                      isExpertNeeded: isYesSelectedGroup2,
                      status: DemandStatus.open,
                      addedDate: DateTime.now(),
                      userId: currentUser.id!,
                    );

                    try {
                      await demandeService.saveDemande(newDemand);
                      setState(() {
                        isLoading = false;
                      });

                      // Show SuccessDialog
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return SuccessDialog(
                            message: 'Demande enregistrée avec succès !',
                            logoPath: 'assets/images/logo.png',
                            iconPath: 'assets/icons/check1.png',
                          );
                        },
                      );
                      Future.delayed(Duration(seconds: 2), () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      });

                    } catch (error) {
                      setState(() {
                        isLoading = false;
                      });

                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return SuccessDialog(
                            message: 'Erreur lors de l\'enregistrement de la demande !',
                            logoPath: 'assets/images/logo.png',
                            iconPath: 'assets/icons/echec.png',
                          );
                        },
                      );
                      Future.delayed(Duration(seconds: 2), () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      });
                    }

                  } else {
                    setState(() {
                      isLoading = false;
                    });

                    // Show SnackBar for validation errors
                    ScaffoldMessenger.of(widget.context).showSnackBar(
                      SnackBar(
                        content: Text("Veuillez remplir tous les champs !"),
                        backgroundColor: Colors.redAccent,
                        behavior: SnackBarBehavior.fixed,
                        duration: const Duration(seconds: 2),
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
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor, // Couleur bleue
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // Rayon
                  ),
                  padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 50.w),
                ),
                child: Text(
                  'Terminer',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }



  Widget _buildCategorieSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Catégorie',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 10.h),
        TextField(
          controller: _CategoryController,
          decoration: InputDecoration(
            hintText: 'Transport/Éléct...',
            hintStyle: TextStyle(color: Colors.grey),
            prefixIcon: Icon(Icons.search, color: Color(0xFF0099D6)),
            filled: true,
            fillColor: Color(0xFFEDF4FF),
            contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              borderSide: BorderSide.none,
            ),
            suffixIcon: IconButton(
              icon: Icon(Icons.clear, color: Colors.grey),
              onPressed: () {
                _CategoryController.clear();
              },
            ),
          ),
        ),
        SizedBox(height: 16.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            CustomButton(
              text: 'Meuble',
              color: Color(0xFF2DC4FF),
              onPressed: () {
                _CategoryController.clear();
                _CategoryController.text = 'Meuble';
              },
              borderColor: Color(0xFF2DC4FF),
              textColor: Colors.white,
              textStyle: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        SizedBox(height: 30.h),
        Text(
          'Photos',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 30.h),
        if (_selectedImages.isEmpty)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
              _buildCard(
                  0.27.sw, AppTheme.primaryColor, 'assets/icons/image.png'),
            SizedBox(width: 20.h),
              _buildCardPlus(
                  0.27.sw, AppTheme.primaryColor, 'assets/images/img_12.png'),
          ],
        ),
        if ( _selectedImages.isNotEmpty)
        Row(
          mainAxisAlignment: _selectedImages.length == _maxImages ?  MainAxisAlignment.center : MainAxisAlignment.start,
          children: [
            if (_selectedImages.length < _maxImages)
            _buildImagePreview(2),
            if (_selectedImages.length == _maxImages)
              _buildImagePreview(3),
            SizedBox(width: 20.h),
            if (_selectedImages.length < _maxImages)
              _buildCardPlus(
                  0.27.sw, AppTheme.primaryColor, 'assets/images/img_12.png'),
          ],
        ),
        SizedBox(height: 30.h),
        _buildDescriptionTextField('', 'Déscription', _descriptionController2),
        SizedBox(height: 30.h),
        Container(
          margin: EdgeInsets.only(bottom: 30.8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
                    width: 80.w,
                    child: TextFormField(
                      controller: _prixcontroller,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: AppTheme.primaryColor,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 12,
                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              SizedBox(width: 30),
              Column(
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
                  SizedBox(
                    width: 100.w, // Reduced width for dropdown
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: AppTheme.primaryColor,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 4,
                        ),
                      ),
                      value: _selectedTimeUnit, // Initial value
                      items: <String>[
                        'Heure',
                        'Jour',
                        'Semaine',
                        'Mois',
                        'Année'
                      ] // Dropdown options
                          .map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        // Handle dropdown value change
                        setState(() {
                          _selectedTimeUnit = newValue;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 20.h),
        Center(
          child: isLoading
              ? CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });
                    if (validateLocation()) {
                      for (int i = 0; i < _selectedImages.length; i++) {
                        String imageUrl = await minIOService.saveFileToServer(
                            'images', _selectedImages[i]);
                        images += imageUrl + ',';
                      }
                      print("images" + images);
                      Location location = Location(
                        description: _descriptionController2.text,
                        category: _CategoryController.text,
                        prix: double.parse(_prixcontroller.text),
                        timeUnit: _selectedTimeUnit!,
                        images: images,
                        status: LocationStatus.DISPONIBLE,
                        userId: currentUser.id!,
                      );
                      await (locationService.saveLocation(location));

                      setState(() {
                        isLoading = false;
                      });
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return SuccessDialog(
                            message: 'Demande de location ajoutée correctement',
                            logoPath: 'assets/images/logo.png',
                            iconPath: 'assets/icons/check1.png',
                          );
                        },
                      );
                      Future.delayed(Duration(seconds: 2), () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      });
                    } else {
                      // show a snackbar
                      ScaffoldMessenger.of(widget.context).showSnackBar(
                        SnackBar(
                          content: Text("Veuillez remplir tous les champs !"),
                          backgroundColor: Colors.redAccent,
                          behavior: SnackBarBehavior.fixed,

                          duration: const Duration(seconds: 2),
                          action: SnackBarAction(
                            label: 'OK',
                            textColor: Colors.white,
                            onPressed: () {
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                            },
                          ),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor, // Blue color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20), // Radius
                    ),
                    padding:
                        EdgeInsets.symmetric(vertical: 10.h, horizontal: 50.w),
                  ),
                  child: Text(
                    'Terminer',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildCard(double size, Color color, String imagePath) {
    return GestureDetector(
      onTap: _pickImage,
      child: Column(
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
                      offset: Offset(0, 10.0),
                    ),
                  ],
                ),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: size * 0.1),
                    child: Image.asset(
                      imagePath,
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
                  child: Center(
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: size * 0.18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCardPlus(double size, Color color, String imagePath) {
    return GestureDetector(
      onTap: _pickImage,
      child: Column(
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
                      offset: Offset(0, 10.0),
                    ),
                  ],
                ),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: size * 0.1),
                    child: Image.asset(
                      imagePath,
                      width: size * 0.4,
                      height: size * 0.4,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImagePreview(int size) {
    return Container(
      height: 0.27.sw * 0.9,
      width: 0.27.sw * 0.9 * size + 20,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _selectedImages.length,
        itemBuilder: (context, index) {
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                child: Container(
                  width: 0.27.sw * 0.9,
                  height: 0.27.sw * 0.9,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                  child: Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            _selectedImages[index],
                            width: 0.27.sw * 0.9,
                            height: 0.27.sw * 0.9,
                            fit: BoxFit.cover,
                          ),
                        )
                  ),
                ),
              ),
              Positioned(
                top: 0.0,
                right: 8.0,
                child: Container(
                  width: 0.27.sw * 0.20,
                  height: 0.27.sw * 0.20,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _removeImage(index);
                          });
                        },
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                          size: 0.27.sw * 0.18,
                        )),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile>? images = await picker.pickMultiImage();

    if (images != null &&
        _selectedImages.length + images.length <= _maxImages) {
      setState(() {
        _selectedImages
            .addAll(images.map((image) => File(image.path)).toList());
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('You can select up to $_maxImages images only.')),
      );
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }



  Widget _buildDescriptionTextField(
      String label, String hintText, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 10.h),
        TextField(
          controller: controller,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            hintText: hintText,
            // Hint personnalisé
            filled: true,
            fillColor: Color(0xFFEDF4FF),
            contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBudgetField() {
    return Row(
      children: [
        Text(
          'Budget :',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(width: 10.w), // Espacement entre le texte et le champ de texte
        Container(
          width: 200.w, // Largeur personnalisée du champ de texte
          child: TextField(
            controller: _budgetController,
            onChanged: (value) {
              setState(() {
                double? budget = double.tryParse(value);
                if (budget != null && budget >= 5000) {
                  showExpertQuestion = true;
                } else {
                  showExpertQuestion = false;
                }
              });
            },
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'ex.. 1000 € ',
              hintStyle: TextStyle(color: Colors.grey),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
            ),
          ),
        ),
        SizedBox(width: 10.w), // Espacement entre le champ de texte et l'icône
        Image.asset('assets/icons/coin.png',
            height: 50.h, width: 50.w, fit: BoxFit.scaleDown),
      ],
    );
  }
}
