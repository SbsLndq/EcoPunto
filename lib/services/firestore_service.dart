import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'storage_service.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Guardar un reporte en Firestore
  Future<void> saveReport(Map<String, dynamic> report) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('No hay un usuario autenticado.');
    }

    final reportData = {
      ...report,
      'userId': user.uid,
      'createdAt': FieldValue.serverTimestamp(),
    };

    await _firestore.collection('reports').add(reportData);
  }

  // Obtener los reportes del usuario actual
  Future<List<Map<String, dynamic>>> getReports() async {
    final user = _auth.currentUser;

    if (user == null) {
      return [];
    }

    final snapshot = await _firestore
        .collection('reports')
        .where('userId', isEqualTo: user.uid)
        .get();

    return snapshot.docs.map((doc) {
      return {
        'id': doc.id,
        ...doc.data(),
      };
    }).toList();
  }

  // Sincronizar reportes pendientes
  Future<void> syncPendingReports() async {
    final user = _auth.currentUser;

    if (user == null) {
      return;
    }

    final storageService = StorageService();
    final reports = await storageService.getReports();

    for (int i = 0; i < reports.length; i++) {
      final report = reports[i];

      if (report['synced'] == true) {
        continue;
      }

      try {
        await saveReport(report);
        await storageService.markReportAsSynced(i);
      } catch (e) {
        // Si falla, el reporte permanece pendiente.
        continue;
      }
    }
  }
}