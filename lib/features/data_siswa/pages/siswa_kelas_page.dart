import 'package:flutter/material.dart';

import '../../../core/constants/app_color.dart';
import '../../../core/widgets/info_card.dart';
import '../../../core/widgets/state_views.dart';
import '../../../services/student_service.dart';
import '../models/master_student_model.dart';

class SiswaKelasPage extends StatefulWidget {
  const SiswaKelasPage({super.key});

  @override
  State<SiswaKelasPage> createState() => _SiswaKelasPageState();
}

class _SiswaKelasPageState extends State<SiswaKelasPage> {
  late Future<List<MasterStudent>> _future;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _future = StudentService.getMyClassStudents();
  }

  void _reload() {
    setState(() => _future = StudentService.getMyClassStudents());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: AppBar(title: const Text('Siswa Kelas Saya')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Cari nama atau NISN...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
                isDense: true,
              ),
              onChanged: (v) => setState(() => _query = v.trim().toLowerCase()),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<MasterStudent>>(
              future: _future,
              builder: (context, snap) {
                if (snap.connectionState != ConnectionState.done) {
                  return const LoadingView();
                }
                if (snap.hasError) {
                  return ErrorView(onRetry: _reload);
                }
                final all = snap.data ?? [];
                if (all.isEmpty) {
                  return const EmptyView(
                      message: 'Belum ada siswa di kelas ini');
                }
                final items = all
                    .where((s) =>
                        s.name.toLowerCase().contains(_query) ||
                        s.nisn.contains(_query))
                    .toList();
                if (items.isEmpty) {
                  return const EmptyView(message: 'Siswa tidak ditemukan');
                }
                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: items.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (_, i) => InfoCard(
                      title: items[i].name, subtitle: items[i].nisn),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}