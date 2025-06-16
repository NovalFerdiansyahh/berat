import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  String selectedRole = 'Penulis';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            Text(
              'BERAT',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.teal[200],
                letterSpacing: 2,
              ),
            ),
            Text(
              'Berita Terakurat',
              style: TextStyle(fontSize: 14, color: Colors.teal[200]),
            ),
            const SizedBox(height: 40),


            Align(alignment: Alignment.centerLeft, child: Text("Username")),
            TextField(
              controller: usernameController,
              decoration: InputDecoration(hintText: 'Sigma'),
            ),
            const SizedBox(height: 10),


            Align(alignment: Alignment.centerLeft, child: Text("Email")),
            TextField(
              controller: emailController,
              decoration: InputDecoration(hintText: 'Sigma@gmail.com'),
            ),
            const SizedBox(height: 10),


            Align(alignment: Alignment.centerLeft, child: Text("Telepon")),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(hintText: '+62 000000'),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 10),


            Align(alignment: Alignment.centerLeft, child: Text("Password")),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(hintText: '********'),
            ),
            const SizedBox(height: 10),


            Align(alignment: Alignment.centerLeft, child: Text("Confirmation password")),
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(hintText: '********'),
            ),
            const SizedBox(height: 20),


            Align(alignment: Alignment.centerLeft, child: Text("Daftar sebagai")),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Radio<String>(
                      value: 'Penulis',
                      groupValue: selectedRole,
                      onChanged: (value) {
                        setState(() {
                          selectedRole = value!;
                        });
                      },
                    ),
                    const Text("Penulis"),
                  ],
                ),
                Row(
                  children: [
                    Radio<String>(
                      value: 'Pembaca',
                      groupValue: selectedRole,
                      onChanged: (value) {
                        setState(() {
                          selectedRole = value!;
                        });
                      },
                    ),
                    const Text("Pembaca"),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),


            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {

                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal[200],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text("Daftar"),
              ),
            ),

            const SizedBox(height: 20),


            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Sudah punya akun? "),
                GestureDetector(
                  onTap: () {

                  },
                  child: const Text(
                    "Login",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
