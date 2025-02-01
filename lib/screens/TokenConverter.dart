import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import '../Services/SharedPrefService.dart';
import '../Services/TransactionService.dart';
import '../entities/User.dart';
import 'EchecToken.dart';
import 'TokenInputFormatter.dart';

class TokenConverterScreen extends StatefulWidget {
  @override
  _TokenConverterState createState() => _TokenConverterState();
}

class _TokenConverterState extends State<TokenConverterScreen> {
  final TextEditingController _tokenController = TextEditingController();

  TransactionService transactionService = TransactionService();

  Future<void> makeCashout() async {
    try {
      User user = await SharedPrefService().getUser();
      if (_tokenController.text.isNotEmpty) {
        int tokens = int.parse(_tokenController.text);
        print("Myyyy TOKEEENNNNNS : $tokens");
        print("MYYY USEEEEERRR  : $user");
        await transactionService.workerPayout(user.id ?? 0, tokens);
      } else {
        throw Exception("Le champ de tokens est vide !");
      }
    } catch (e, s) {
      print("Exception 1: $e");
      print("Stack trace: $s");

      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => EchecTokenScreen(),
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
                                'Retrait de tokens',
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
                                    hintText: 'Nombres de jetons à convertir',
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: OutlineInputBorder(),
                                  ),
                                  onChanged: (value) {
                                    setState(() {});
                                  },
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly, // Accepter uniquement les chiffres
                                    TokenInputFormatter(maxToken: 5000),   // Limite personnalisée pour les tokens
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
                            onPressed: () => makeCashout(),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 15),
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'Complétez votre retrait',
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
