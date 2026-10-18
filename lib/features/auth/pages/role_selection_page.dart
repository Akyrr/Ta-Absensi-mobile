
import 'package:flutter/material.dart';
import '../../home/home.dart';

class RoleSelectionPage extends StatefulWidget {
  const RoleSelectionPage({super.key});

  @override
  State<RoleSelectionPage> createState() =>
      _RoleSelectionPageState();
}

class _RoleSelectionPageState extends State<RoleSelectionPage> {
  String? _selectedRole;

  final List<String> _roles = [
    'Siswa',
    'Siswa Inti',
    'Wali Kelas',
    'Guru Mata Pelajaran',
  ];

  void _continueToDashboard() {
    if (_selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan pilih role terlebih dahulu.'),
        ),
      );
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(
          activeRole: _selectedRole!,
        ),
      ),
    );
  }

  IconData _getRoleIcon(String role) {
    switch (role) {
      case 'Siswa':
        return Icons.person_outline;
      case 'Siswa Inti':
        return Icons.groups_outlined;
      case 'Wali Kelas':
        return Icons.supervisor_account_outlined;
      case 'Guru Mata Pelajaran':
        return Icons.school_outlined;
      default:
        return Icons.person_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pilih Role Aktif'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.manage_accounts_outlined,
                    size: 56,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Pilih Role Aktif',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Pilih role yang ingin kamu gunakan '
                    'untuk mengakses aplikasi.',
                  ),
                  const SizedBox(height: 24),
                  ..._roles.map(
                    (role) => Card(
                      child: RadioListTile<String>(
                        value: role,
                        groupValue: _selectedRole,
                        title: Text(role),
                        secondary: Icon(_getRoleIcon(role)),
                        onChanged: (value) {
                          setState(() {
                            _selectedRole = value;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _continueToDashboard,
                      child: const Text('Lanjutkan'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
