import 'package:flutter/material.dart';

import '../../../core/constants/app_color.dart';
import '../../../core/widgets/info_card.dart';
import '../../../core/widgets/state_views.dart';
import '../../../services/subject_service.dart';
import '../models/subject_model.dart';

class MataPelajaranPage extends StatefulWidget {
  const MataPelajaranPage({super.key});

  @override
  State<MataPelajaranPage> createState() => _MataPelajaranPageState();
}

class _MataPelajaranPageState extends State<MataPelajaranPage> {
  late Future<List<Subject>> _future;

  @override
  void initState() {
    super.initState();
    _future = SubjectService.getSubjects();
  }

  void _reload() {
    setState(() => _future = SubjectService.getSubjects());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: AppBar(title: const Text('Mata Pelajaran Saya')),
      body: FutureBuilder<List<Subject>>(
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
            return const EmptyView(
                message: 'Belum ada mata pelajaran yang diampu');
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (_, i) =>
                InfoCard(title: items[i].name, subtitle: items[i].code),
          );
        },
      ),
    );
  }
}