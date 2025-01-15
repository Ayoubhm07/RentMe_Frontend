import 'package:flutter/material.dart';
import 'package:khedma/Services/DemandeService.dart';
import 'package:khedma/Services/SharedPrefService.dart';
import 'package:khedma/Services/TransactionService.dart';
import '../../entities/Demand.dart';
import '../../entities/User.dart';
import '../../screens/MainPages/HomePage.dart';

class ConfirmPaymentWidget extends StatefulWidget {
  final int amount;
  final String userName;
  final int benifId;
  final int demandId;

  ConfirmPaymentWidget({
    required this.demandId,
    required this.benifId,
    required this.amount,
    required this.userName,
  });

  @override
  _ConfirmPaymentWidgetState createState() => _ConfirmPaymentWidgetState();
}

class _ConfirmPaymentWidgetState extends State<ConfirmPaymentWidget> {
  TransactionService transactionService = TransactionService();
  SharedPrefService sharedPrefService = SharedPrefService();
  User? user;
  int? ownerId;
  DemandeService demandeService = DemandeService();

  @override
  void initState() {
    super.initState();
    loadUserandDetails();
  }

  Future<void> loadUserandDetails() async {
    try {
      User? fetchedUser = await sharedPrefService.getUser();
      if (fetchedUser != null && fetchedUser.id != null) {
        setState(() {
          user = fetchedUser;
          ownerId = fetchedUser.id;  // Now safe to access
        });
      } else {
        print("User or User ID is null.");
      }
    } catch (e) {
      print('Failed to load user details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ownerId == null ? Center(child: CircularProgressIndicator()) : buildPaymentConfirmation();
  }

  Widget buildPaymentConfirmation() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Image.asset("assets/icons/tokenicon.png", width: 60),
          ),
          Text(
            'Confirmation du paiement',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          SizedBox(height: 10),
          Text(
            'Veuillez confirmer les détails du paiement ci-dessous avant de procéder.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          SizedBox(height: 20),
          Text(
            'Montant: €${widget.amount.toStringAsFixed(2)}',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          SizedBox(height: 10),
          Text(
            'Bénéficiaire: ${widget.userName}',
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () async {
                  try {
                    await transactionService.pay(ownerId!, widget.benifId, widget.amount.toInt());
                    await demandeService.updateDemandStatus(widget.demandId);
                    Navigator.pop(context); // Close the current bottom sheet or dialog
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(), // Navigation to CustomSwitchOffreServices
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Payment successful and status updated"),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Error during transaction: $e"),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  'Accepter',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  'Annuler',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
