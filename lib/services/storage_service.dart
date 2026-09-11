import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String reportsKey = 'recycling_reports';

  Future<void> saveReport(Map<String, dynamic> report) async {
    final preferences = await SharedPreferences.getInstance();

    final reports = await getReports();

    reports.add(report);

    final jsonData = jsonEncode(reports);

    await preferences.setString(
      reportsKey,
      jsonData,
    );

  }

  Future<List<Map<String, dynamic>>> getReports() async {
    final preferences = await SharedPreferences.getInstance();

    final jsonData = preferences.getString(reportsKey);

    if (jsonData == null || jsonData.isEmpty) {
      return [];
    }

    final decoded = jsonDecode(jsonData);

    return List<Map<String, dynamic>>.from(
      decoded.map(
            (item) => Map<String, dynamic>.from(item),
      ),
    );
  }

  Future<void> markReportAsSynced(int index) async {
    final preferences = await SharedPreferences.getInstance();

    final reports = await getReports();

    if (index < 0 || index >= reports.length) {
      return;
    }

    reports[index]['synced'] = true;

    await preferences.setString(
      reportsKey,
      jsonEncode(reports),
    );
  }
}