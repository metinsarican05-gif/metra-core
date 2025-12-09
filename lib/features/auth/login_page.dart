import 'package:flutter/material.dart';
import 'register_page.dart';
import '../../main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController phoneCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final Color background = const Color(0xFF0A1A2F);
    final Color card = const Color(0xFF101E33);
    final Color primary = const Color(0xFF1ED1F5);

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        title: const Text("Giriş Yap"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildInput(
                controller: phoneCtrl,
                label: "Telefon",
                keyboard: TextInputType.phone,
                validatorText: "Zorunlu alan",
              ),
              const SizedBox(height: 18),

              _buildInput(
                controller: passwordCtrl,
                label: "Şifre",
                isPassword: true,
                validatorText: "Zorunlu alan",
              ),
              const SizedBox(height: 30),

              /// GİRİŞ BUTONU
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: isLoading
                      ? null
                      : () {
                    if (_formKey.currentState!.validate()) {
                      setState(() => isLoading = true);

                      Future.delayed(const Duration(seconds: 1), () {
                        setState(() => isLoading = false);

                        Navigator.pushReplacementNamed(context, "/home");
                      });
                    }
                  },
                  child: isLoading
                      ? const CircularProgressIndicator(
                    color: Colors.black,
                  )
                      : const Text(
                    "Giriş Yap",
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RegisterPage()),
                  );
                },
                child: const Text(
                  "Hesabın yok mu? Kayıt Ol",
                  style: TextStyle(
                    color: Colors.white70,
                    decoration: TextDecoration.underline,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInput({
    required TextEditingController controller,
    required String label,
    String? validatorText,
    bool isPassword = false,
    TextInputType keyboard = TextInputType.text,
  }) {
    final Color card = const Color(0xFF101E33);

    return Container(
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboard,
        obscureText: isPassword,
        validator: (v) {
          if (validatorText != null && (v == null || v.isEmpty)) {
            return validatorText;
          }
          return null;
        },
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
