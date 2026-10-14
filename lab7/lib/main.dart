
import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(
  debugShowCheckedModeBanner: false,
  home: SignupScreen(),
));

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final formKey = GlobalKey<FormState>();
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final confirm = TextEditingController();

  bool hidePassword = true;
  bool hideConfirm = true;

  final List<String> registeredEmails = [
    'test@gmail.com',
    'admin@gmail.com',
  ];

  String? checkName(String? v) {
    if (v == null || v.trim().isEmpty) {
      return 'Name is required';
    }
    return null;
  }

  String? checkEmail(String? v) {
    if (v == null || v.trim().isEmpty) {
      return 'Email is required';
    }

    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
        .hasMatch(v.trim())) {
      return 'Enter a valid email';
    }

    return null;
  }

  String? checkPassword(String? v) {
    if (v == null || v.isEmpty) {
      return 'Password is required';
    }
    if (v.length < 8) {
      return 'Minimum 8 characters';
    }
    if (!RegExp(r'[0-9]').hasMatch(v)) {
      return 'Must contain at least 1 digit';
    }
    return null;
  }

  String? checkConfirm(String? v) {
    if (v == null || v.isEmpty) {
      return 'Please confirm password';
    }
    if (v != password.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  void showMessage(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
  }

  void submit() {
    FocusScope.of(context).unfocus();

    if (!formKey.currentState!.validate()) return;

    final inputEmail = email.text.trim().toLowerCase();

    // Kiểm tra email trùng
    if (registeredEmails.contains(inputEmail)) {
      showMessage('Email already exists!', Colors.red);
      return;
    }

    // Thêm email mới vào danh sách
    registeredEmails.add(inputEmail);

    showMessage('Signup successful!', Colors.green);

    // Xóa dữ liệu sau khi đăng ký thành công
    name.clear();
    email.clear();
    password.clear();
    confirm.clear();
    setState(() {
      hidePassword = true;
      hideConfirm = true;
    });
  }

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    password.dispose();
    confirm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Signup'),
        centerTitle: true,
      ),
      body: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text(
              'Create Account',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            TextFormField(
              controller: name,
              validator: checkName,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: email,
              validator: checkEmail,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: password,
              validator: checkPassword,
              obscureText: hidePassword,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: const Icon(Icons.lock),
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    hidePassword
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () => setState(
                        () => hidePassword = !hidePassword,
                  ),
                ),
              ),
            ),

            if (password.text.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  password.text.length >= 8 &&
                      RegExp(r'[0-9]')
                          .hasMatch(password.text)
                      ? 'Strong password'
                      : 'Weak password',
                  style: TextStyle(
                    color: password.text.length >= 8 &&
                        RegExp(r'[0-9]')
                            .hasMatch(password.text)
                        ? Colors.green
                        : Colors.orange,
                  ),
                ),
              ),
            const SizedBox(height: 16),

            TextFormField(
              controller: confirm,
              validator: checkConfirm,
              obscureText: hideConfirm,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => submit(),
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                prefixIcon: const Icon(Icons.lock_outline),
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    hideConfirm
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () => setState(
                        () => hideConfirm = !hideConfirm,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: submit,
                child: const Text(
                  'Create Account',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
