import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:khedma/Services/JWTService.dart';
import 'package:khedma/Services/ProfileService.dart';
import 'package:khedma/Services/SharedPrefService.dart';
import 'package:khedma/Services/UserService.dart';
import 'package:khedma/components/Card/RentalCardMyDemand.dart';
import 'package:khedma/entities/Demand.dart';
import 'package:khedma/entities/User.dart';
import '../../Services/DemandeService.dart';
import '../../entities/ProfileDetails.dart';
import '../Card/RentalCardDisponibleOffre.dart';

class CustomSwitchOffreServices extends StatefulWidget {
  final List<String> buttonLabels;

  const CustomSwitchOffreServices({Key? key, required this.buttonLabels}) : super(key: key);

  @override
  State<CustomSwitchOffreServices> createState() => _CustomSwitchOffreServicesState();
}

class _CustomSwitchOffreServicesState extends State<CustomSwitchOffreServices> {
  List<bool> isSelected = [true, false];
  DemandeService demandeService = DemandeService();
  UserService userService = UserService();
  ProfileService profileService = ProfileService();
  SharedPrefService sharedPrefService = SharedPrefService();
  ProfileDetails? profileDetails;
  ProfileDetails? profileDetails2;
  User? user;


  @override
  Widget build(BuildContext context) {
    return Column(
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
            fillColor: const Color(0xFF0099D6),
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
                for (int buttonIndex = 0; buttonIndex < isSelected.length; buttonIndex++) {
                  isSelected[buttonIndex] = (buttonIndex == index);
                }
              });
            },
            isSelected: isSelected,
          ),
        ),
        SizedBox(height: 20.h),
        Expanded(
          child: _buildContent(),
        ),
      ],
    );
  }

  Widget _buildContent() {
    return isSelected[0] ? _buildDisponibleSection() : _buildTermineeSection();
  }

  Future<List<Demand>> getAllDemandsWithUser() async {
    User user1 = await sharedPrefService.getUser();
    int userId = user1.id ?? 0;
    var demands = await demandeService.getDemandsByNotUserId(userId);
     
    for (var demand in demands) {
      var user = await userService.findUserById(demand.userId);
      profileDetails2 = await profileService.getProfileDetails(user.id ?? 0);
      demand.userImage = profileDetails2?.profilePicture;
      demand.ownerName = user.userName;
      demand.phoneNumber = user.numTel;
      demand.userEmail = user.email ;
      demand.location = profileDetails2!.ville!+","+profileDetails2!.rue!+","+profileDetails2!.codePostal!+","+profileDetails2!.pays!;
    }
    return demands;
  }
  String _formatDateTime(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd -- HH:MM').format(dateTime);
  }
  Widget _buildDisponibleSection() {
    return FutureBuilder<List<Demand>>(
      future: getAllDemandsWithUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Erreur: ${snapshot.error}');
        } else {
          return ListView.builder(
            itemCount: snapshot.data?.length ?? 0,
            itemBuilder: (context, index) {
              Demand demand = snapshot.data![index];
              return RentalItemCardDisponibleOffre(
                userId: demand.userId,
                demandId: demand.id ?? 0,
                imageUrl: 'assets/images/menage.jpeg',
                title: demand.title ?? '',
                date: _formatDateTime(demand.addedDate),
                evalue: true,
                budget: demand.budget,
                description: demand.description,
                location: demand.location,
                ownerName: demand.ownerName ?? '',
                phoneNumber : demand.phoneNumber ?? "",
                userEmail : demand.userEmail ?? "",
                userImage : demand.userImage ?? "",
                statut: demand.status.toString().split('.').last,
              );
            },
          );
        }
      },
    );
  }

  Widget _buildTermineeSection() {
    return FutureBuilder<List<Demand>>(
      future: fetchUserDemands(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Erreur: ${snapshot.error}');
        } else {
          return ListView.builder(
            itemCount: snapshot.data?.length ?? 0,
            itemBuilder: (context, index) {
              Demand demand = snapshot.data![index];
              return RentalItemCardMyDemand(
                demandId: demand.id ?? 0,
                description: demand.description,
                imageUrl: 'assets/images/menage.jpeg',
                title: demand.title ?? '',
                date: _formatDateTime(demand.addedDate),
                evalue: true,
                budget: demand.budget,
                location: "*",
                ownerName: demand.ownerName ?? '',
                userImage: profileDetails!.profilePicture!,
                statut: demand.status.toString().split('.').last,
              );
            },
          );
        }
      },
    );
  }

  Future<List<Demand>> fetchUserDemands() async {
    user = await sharedPrefService.getUser();
    profileDetails = await sharedPrefService.getProfileDetails();
    int userId= user?.id ?? 0;
    print(user?.id);
    print(user?.userName);
    return demandeService.getDemandsByUserId(userId);
  }
}


