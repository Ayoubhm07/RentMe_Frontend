import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:khedma/Services/StripeService.dart';

import 'EchecToken.dart';
import 'SuccesConversion.dart';
import 'TokenInputFormatter.dart';

class AchatTokenScreen extends StatefulWidget {
  @override
  _AchatTokenState createState() => _AchatTokenState();
}

class _AchatTokenState extends State<AchatTokenScreen> {
  TextEditingController _tokenController = TextEditingController();

  StripeService stripeService = StripeService();
  String paymentId = '';
  int amount = 0;
  Future<void> makePayment() async {
    try {
      final paymentIntentData = await stripeService.createPaymentIntent(_tokenController.text, 'EUR');
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentData['client_secret'],
          merchantDisplayName: 'SomeMerchantName',
        ),
      );
      paymentId = paymentIntentData['id'];
      int amountInCents = paymentIntentData['amount'];
      amount = amountInCents ~/ 100;
      displayPaymentSheet();
    } catch (e, s) {
      print("Exception 1: $e");
      print("Stack trace: $s");
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => EchecTokenScreen()
      ));
    }
  }

  double _scale = 0.5; // Start with a small scale

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _scale = 1.0;
      });
    });
  }

  Future<void> displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => SuccessTokenScreen(paymentId: paymentId, amount: amount)
        ));
      });
    } catch (e) {
      print("Error presenting payment sheet: $e");
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => EchecTokenScreen()
      ));
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(35, 9, 9, 9),
      body: SafeArea(
        child: KeyboardVisibilityBuilder(
          builder: (context, isKeyboardVisible) {
            return SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom: isKeyboardVisible ? MediaQuery.of(context).viewInsets.bottom : 0,
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: Icon(Icons.close, color: Colors.black),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              Text(
                                'Achat de tokens',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(width: 48),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Image.asset(
                                "assets/icons/tokenicon.png",
                                width: 35,
                                height: 35,
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: TextField(
                                  controller: _tokenController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    hintText: 'Enter number of tokens',
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: OutlineInputBorder(),
                                  ),
                                  onChanged: (value) => setState(() {}),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    TokenInputFormatter(maxToken: 5000),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Total Cost: ${_tokenController.text.isEmpty ? 0 : int.parse(_tokenController.text)} Euro(s)',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () => makePayment(),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 15),
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'Complétez votre achat',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Center(
                            child: AnimatedScale(
                              scale: isKeyboardVisible ? 0.8 : 1.0,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              child: Container(
                                height: 200,
                                width: 200,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage("assets/images/logo.png"),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
