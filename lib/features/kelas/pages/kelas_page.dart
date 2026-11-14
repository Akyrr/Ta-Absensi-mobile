import 'package:flutter/material.dart';

import '../../../core/constants/app_color.dart';
import '../../../core/widgets/info_card.dart';
import '../../../core/widgets/state_views.dart';
import '../../../services/class_service.dart';
import '../models/class_model.dart';

class KelasPage extends StatefulWidget {
  const KelasPage({super.key});

  @override
  State<KelasPage> createState() => _KelasPageState();
}

class _KelasPageState extends State<KelasPage> {
  late Future<List<ClassInfo>> _future;

  @override
  void initState() {
    super.initState();
    _future = ClassService.getMyClasses();
  }

  void _reload() {
    setState(() => _future = ClassService.getMyClasses());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: AppBar(title: const Text('Kelas Saya')),
      body: FutureBuilder<List<ClassInfo>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const LoadingView();
          }
          if (snap.hasError) {
            return ErrorView(onRetry: _reload);
          }
          final items = snap.data ?? [];
          if (items.isEmpty) {
            return const EmptyView(message: 'Anda belum tergabung di kelas manapun');
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (_, i) => InfoCard(
              title: items[i].name,
              subtitle:
                  'Tingkat ${items[i].gradeLevel} • Wali Kelas: ${items[i].homeroomTeacher ?? 'Belum ditentukan'}',
            ),
          );
        },
      ),
    );
  }
}