import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    title: 'CPF Validator',
    home: CPFValidationScreen(),
  ));
}

class CPFValidationScreen extends StatefulWidget {
  const CPFValidationScreen({super.key});

  @override
  _CPFValidationScreenState createState() => _CPFValidationScreenState();
}

class _CPFValidationScreenState extends State<CPFValidationScreen> {
  TextEditingController cpfController = TextEditingController();
  bool isValid = false;

  void validateCPF() {
    String cpf = cpfController.text;
    if (cpf.length != 11) {
      setState(() {
        isValid = false;
      });
      return;
    }

    if (!_hasValidDigits(cpf)) {
      setState(() {
        isValid = false;
      });
      return;
    }

    String firstNineDigits = cpf.substring(0, 9);
    String firstVerifierDigit = cpf.substring(9, 10);
    String secondVerifierDigit = cpf.substring(10, 11);

    bool isFirstDigitValid =
    _calculateVerifierDigit(firstNineDigits, firstVerifierDigit);
    bool isSecondDigitValid =
    _calculateVerifierDigit(cpf.substring(0, 10), secondVerifierDigit);

    setState(() {
      isValid = isFirstDigitValid && isSecondDigitValid;
    });
  }

  bool _hasValidDigits(String cpf) {
    return RegExp(r'^[0-9]{11}$').hasMatch(cpf);
  }

  bool _calculateVerifierDigit(String digits, String expectedDigit) {
    int sum = 0;

    for (int i = 0; i < digits.length; i++) {
      sum += int.parse(digits[i]) * (digits.length + 1 - i);
    }

    int remainder = sum % 11;
    int verifierDigit = remainder < 2 ? 0 : 11 - remainder;

    return verifierDigit.toString() == expectedDigit;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CPF Validator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: cpfController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Digite um CPF',
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: validateCPF,
              child: const Text('Validar CPF'),
            ),
            const SizedBox(height: 16.0),
            Text(
              'CPF é válido: ${isValid ? "Sim" : "Não"}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
