import 'package:flutter/material.dart';

class DirectoryPage extends StatelessWidget {
  const DirectoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Directory'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('Directory Page'),
      ),
    );
  }
}
