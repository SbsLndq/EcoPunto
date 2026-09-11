import 'dart:async';

import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../services/firestore_service.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final materialsController = TextEditingController();
  final descriptionController = TextEditingController();

  final StorageService storageService = StorageService();
  final FirestoreService firestoreService = FirestoreService();

  bool isSaving = false;

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    materialsController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> saveReport() async {
    if (nameController.text.isEmpty ||
        addressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Completa el nombre y la dirección.',
          ),
        ),
      );
      return;
    }

    setState(() {
      isSaving = true;
    });

    final report = {
      'name': nameController.text.trim(),
      'address': addressController.text.trim(),
      'materials': materialsController.text.trim(),
      'description': descriptionController.text.trim(),
      'date': DateTime.now().toIso8601String(),
      'synced': false,
    };

    // 1. Guardar primero localmente
    await storageService.saveReport(report);

    bool synced = false;

    // 2. Intentar sincronizar con Firestore
    try {
      await firestoreService.saveReport(report).timeout(
        const Duration(seconds: 5),
      );

      await storageService.markReportAsSynced(
        (await storageService.getReports()).length - 1,
      );

      synced = true;
    } on TimeoutException {
      synced = false;
    } catch (e) {
    synced = false;
    }

    if (!mounted) return;

    setState(() {
      isSaving = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          synced
              ? 'Reporte guardado y sincronizado con la nube.'
              : 'Reporte guardado localmente. Se sincronizará cuando haya conexión.',
        ),
      ),
    );

    nameController.clear();
    addressController.clear();
    materialsController.clear();
    descriptionController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reportar un punto'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Registrar punto de reciclaje',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Ayúdanos a mantener actualizada la información '
                  'de los puntos de reciclaje.',
            ),

            const SizedBox(height: 24),

            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nombre del punto',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_on),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: addressController,
              decoration: const InputDecoration(
                labelText: 'Dirección',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.home),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: materialsController,
              decoration: const InputDecoration(
                labelText: 'Materiales que recibe',
                hintText: 'Ej. plástico, vidrio, papel',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.recycling),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Descripción',
                hintText: 'Agrega información adicional',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: isSaving ? null : saveReport,
                icon: isSaving
                    ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                )
                    : const Icon(Icons.save),
                label: Text(
                  isSaving
                      ? 'Guardando...'
                      : 'Guardar reporte',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}