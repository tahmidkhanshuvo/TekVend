import 'package:amar/product_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'chat_screen.dart'; // Import the Chat page

class OTPPage extends StatefulWidget {
  const OTPPage({super.key});

  @override
  OTPPageState createState() => OTPPageState();
}

class OTPPageState extends State<OTPPage> {
  final _otpControllers = List<TextEditingController>.generate(6, (_) => TextEditingController());
  final _otpFocusNodes = List<FocusNode>.generate(6, (_) => FocusNode());
  bool _isValidOTP = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter OTP'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
              child: Image.asset(
                'lib/images/chatlogo.png',
                fit: BoxFit.contain,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(6, (index) {
                return SizedBox(
                  width: 40,
                  child: TextField(
                    controller: _otpControllers[index],
                    focusNode: _otpFocusNodes[index],
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    textAlign: TextAlign.center,
                    maxLength: 1,
                    decoration: InputDecoration(
                      counterText: '',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: _isValidOTP ? Colors.black : Colors.red,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: _isValidOTP ? Colors.green : Colors.red,
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty && index < 5) {
                        FocusScope.of(context).nextFocus();
                      }
                      if (value.isEmpty && index > 0) {
                        FocusScope.of(context).previousFocus();
                      }
                      if (_otpControllers.every((controller) => controller.text.isNotEmpty)) {
                        String otp = _otpControllers.map((controller) => controller.text).join();
                        if (RegExp(r'^\d{6}$').hasMatch(otp)) {
                          setState(() {
                            _isValidOTP = true;
                          });
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const ProductPage()),
                          );
                        } else {
                          setState(() {
                            _isValidOTP = false;
                          });
                        }
                      }
                    },
                  ),
                );
              }),
            ),
            const SizedBox(height: 16),
            Text(
              _isValidOTP ? '' : 'Invalid OTP. Please try again.',
              style: const TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
