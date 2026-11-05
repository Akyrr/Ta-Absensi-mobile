import 'package:flutter/material.dart';
import '../../../core/constants/app_color.dart';
import '../../../core/helpers/navigation_helper.dart';
import '../models/jurnal_model.dart';
import 'detail_jurnal_page.dart';

class HistoryJurnalPage extends StatelessWidget {
  const HistoryJurnalPage({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = JournalRepository();

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      appBar: AppBar(
        title: const Text('Riwayat Jurnal Guru', style: TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.bold, fontSize: 16)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryDark),
          onPressed: () => NavigationHelper.pop(context),
        ),
      ),
      body: SafeArea(
        child: repo.journals.isEmpty
            ? const Center(child: Text('Belum ada riwayat jurnal.'))
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: repo.journals.length,
                itemBuilder: (context, index) {
                  final jrn = repo.journals[index];
                  return InkWell(
                    onTap: () => NavigationHelper.push(context, DetailJurnalPage(entry: jrn)),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(jrn.className, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                              Text(jrn.period, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(jrn.subject, style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary)),
                          const SizedBox(height: 4),
                          Text(jrn.topic, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.primaryDark)),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
