import 'package:flutter/material.dart';

class ForgetPasswordView extends StatelessWidget {
  const ForgetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text("Forget Password"),
      ),
      body: Column(
        children: [
          const SizedBox(height: 32),
          const Text("A forget password email will be sent to your email id"),
          const SizedBox(height: 32),
          const TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Password",
            ),
          ),
          const SizedBox(height: 32),
          FilledButton(onPressed: () {}, child: const Text("Send")),
        ],
      ),
    );
  }
}
