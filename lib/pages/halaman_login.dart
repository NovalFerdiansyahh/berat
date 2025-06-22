import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
              style: TextStyle(
                fontSize: 14,
                color: Colors.teal[200],
              ),
            ),
            const SizedBox(height: 40),


            Align(
              alignment: Alignment.centerLeft,
              child: Text("Username"),
            ),
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                hintText: 'Sigma',
              ),
            ),
            const SizedBox(height: 10),

            Align(
              alignment: Alignment.centerLeft,
              child: Text("Email"),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: 'Sigma@gmail.com',
              ),
            ),
            const SizedBox(height: 10),


            Align(
              alignment: Alignment.centerLeft,
              child: Text("Password"),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: '********',
              ),
            ),
            const SizedBox(height: 30),


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
                child: const Text('Login'),
              ),
            ),

            const SizedBox(height: 20),


            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Belum punya akun? "),
                GestureDetector(
                  onTap: () {

                  },
                  child: const Text(
                    "Daftar",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
