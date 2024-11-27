import 'package:flutter/material.dart';

class CountrySelectionDialog extends StatelessWidget {
  final List<Map<String, String>> countries = [
    {"code": "id", "name": "Indonesia"},
    {"code": "us", "name": "United States"},
    {"code": "gb", "name": "United Kingdom"},
    {"code": "jp", "name": "Japan"},
    {"code": "in", "name": "India"},
  ];

  CountrySelectionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Pilih Negara"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: countries.map((country) {
          return ListTile(
            title: Text(country["name"]!),
            onTap: () => Navigator.pop(context, country["code"]),
          );
        }).toList(),
      ),
    );
  }
}
