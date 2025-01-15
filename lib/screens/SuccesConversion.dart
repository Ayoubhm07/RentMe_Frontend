import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:khedma/Services/SharedPrefService.dart';
import 'package:khedma/Services/TransactionService.dart';

import '../entities/TransactionDTO.dart';
import '../entities/User.dart';

class SuccessTokenScreen extends StatefulWidget {
  final String paymentId;
  final int amount;

  SuccessTokenScreen({required this.paymentId, required this.amount});

  @override
  State<SuccessTokenScreen> createState() => _SuccessTokenScreenState();
}

class _SuccessTokenScreenState extends State<SuccessTokenScreen> {
  SharedPrefService sharedPrefService = SharedPrefService();
  User? user;
  Future<void> loadUserandDetails() async {
    User? fetchedUser = await sharedPrefService.getUser();
    print(fetchedUser);
    setState(() {
      user = fetchedUser;
    });
  }

  @override
  void initState() {
    super.initState();
    loadUserandDetails();
  }

  TransactionService transactionService = TransactionService();
  Future<void> onContinuePressed() async {
    print(user);
    if (user != null) {
      TransactionDTO transaction = TransactionDTO(
          userId: user!.id,
          paymentIntentId: widget.paymentId,
          amount: widget.amount * 100,
          tokens: widget.amount,
          details: 'waaaa'
      );
      try {
        String response = await transactionService.buyTokens(transaction);
        print(response);
        Navigator.of(context).pop();
      } catch (e) {
        print("Error purchasing tokens: $e");
      }
    } else {
      print("User data not available.");

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 9, 9, 9),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Spacer(),
            Container(
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.black),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      Text(
                        'Conversion de token',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(width: 48),
                    ],
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Image.asset(
                      "assets/icons/check1.png",
                      width: 100,
                      height: 100,
                    ),
                  ),
                  SizedBox(height: 40),
                  Center(
                    child: Text(
                      'La conversion est terminée avec succès.\nPayment ID: ${widget.paymentId}\nAmount: €${widget.amount}',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w600,
                        fontSize: 24,
                        height: 1.3,
                        color: Color(0xFF1C1F1E),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: ElevatedButton(
                        onPressed: onContinuePressed,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.33),
                          ),
                        ),
                        child: Text(
                          'Continuer',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
