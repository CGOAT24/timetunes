import 'package:flutter/material.dart';

import '../providers/timetunes_rest_providers.dart';
import '../services/auth_storage.dart';
import '../services/settings_services.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _restController = TextEditingController();
  final TextEditingController _amqUrlController = TextEditingController();
  final TextEditingController _amqPortController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadValues();
  }

  void _loadValues() {
    _restController.text = SettingsService.getRestUrl();
    _amqUrlController.text = SettingsService.getAmqUrl();
    _amqPortController.text = SettingsService.getAmqPort().toString();
    setState(() {});
  }

  void _saveSettings() {
    SettingsService.setRestUrl(_restController.text);
    SettingsService.setAmqUrl(_amqUrlController.text);
    SettingsService.setAmqPort(int.parse(_amqPortController.text));
  }

  void _testServer(BuildContext context) async {
    bool isConnected = await TimeTunesRESTProvider.checkServerStatus();

    final snackBar = SnackBar(
      content: Text(
        isConnected
            ? "Connexion réussie au serveur TimeTunes"
            : "Connexion échouée. Veuillez réessayer.",
      ),
    );

    if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _logout(BuildContext context) async {
    await AuthStorage.clearToken();
    if (context.mounted) {
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Paramètres"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildTextField("REST URL", _restController),
              _buildTextField("AMQ URL", _amqUrlController),
              _buildTextField("AMQ Port", _amqPortController,
                  keyboardType: TextInputType.number),
              ElevatedButton.icon(
                onPressed: _saveSettings,
                icon: const Icon(Icons.save),
                label: const Text("Sauvegarder"),
              ),
              const Divider(color: Colors.white10, thickness: 1, height: 30),
              ListTile(
                leading: const Icon(Icons.wifi, color: Colors.white),
                title: const Text("Tester la connexion au serveur",
                    style: TextStyle(color: Colors.white)),
                trailing:
                    const Icon(Icons.chevron_right, color: Colors.white54),
                onTap: () => _testServer(context),
              ),
              const Divider(color: Colors.white10, thickness: 1, height: 30),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.redAccent),
                title: const Text("Se déconnecter",
                    style: TextStyle(color: Colors.redAccent)),
                onTap: () => _logout(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          border: const OutlineInputBorder(),
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white24)),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.orange)),
        ),
      ),
    );
  }
}
