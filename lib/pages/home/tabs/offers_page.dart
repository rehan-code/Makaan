import 'package:flutter/material.dart';

class OffersPage extends StatelessWidget {
  const OffersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Offers'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('Offers Page'),
      ),
    );
  }
}
