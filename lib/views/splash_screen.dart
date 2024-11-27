// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import '../services/shared_preferences_service.dart';
import '../views/news_view.dart';
import 'country_selection_dialog.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final SharedPreferencesService _prefsService = SharedPreferencesService();

  @override
  void initState() {
    super.initState();
    _checkCountrySelection();
  }

  Future<void> _checkCountrySelection() async {
    String? country = await _prefsService.getSelectedCountry();
    if (country == null) {
      _showCountrySelectionDialog();
    } else {
      _navigateToNewsView(country);
    }
  }

  void _showCountrySelectionDialog() async {
    final country = await showDialog<String>(
      context: context,
      builder: (context) => CountrySelectionDialog(),
    );

    if (country != null) {
      await _prefsService.setSelectedCountry(country);
      _navigateToNewsView(country);
    }
  }

  void _navigateToNewsView(String country) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => NewsView(initialCountry: country),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
