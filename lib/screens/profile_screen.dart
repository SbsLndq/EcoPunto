import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final storageService = StorageService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis puntos'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: storageService.getReports(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text(
                'No fue posible cargar los reportes.',
              ),
            );
          }

          final reports = snapshot.data ?? [];

          final ecoPoints = reports.length * 10;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Resumen de EcoPuntos
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Colors.green.shade200,
                    ),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.stars,
                        size: 55,
                        color: Colors.green,
                      ),

                      const SizedBox(height: 12),

                      const Text(
                        'Mis EcoPuntos',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        '$ecoPoints',
                        style: const TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),

                      const Text(
                        'puntos acumulados',
                        style: TextStyle(
                          color: Colors.black54,
                        ),
                      ),

                      const SizedBox(height: 16),

                      Text(
                        '♻️ ${reports.length} '
                            '${reports.length == 1 ? 'reporte realizado' : 'reportes realizados'}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Insignia
                const Text(
                  'Mis logros',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: reports.isNotEmpty
                          ? Colors.amber.shade100
                          : Colors.grey.shade200,
                      child: Icon(
                        Icons.emoji_events,
                        color: reports.isNotEmpty
                            ? Colors.amber.shade800
                            : Colors.grey,
                      ),
                    ),
                    title: const Text(
                      'Primer aporte',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      reports.isNotEmpty
                          ? '¡Realizaste tu primer reporte!'
                          : 'Realiza tu primer reporte para desbloquear este logro.',
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Reportes
                const Text(
                  'Mis reportes',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                if (reports.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(30),
                      child: Column(
                        children: [
                          Icon(
                            Icons.recycling,
                            size: 70,
                            color: Colors.green,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Aún no tienes reportes',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Reporta un punto de reciclaje y comienza a ganar EcoPuntos.',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics:
                    const NeverScrollableScrollPhysics(),
                    itemCount: reports.length,
                    itemBuilder: (context, index) {
                      final report = reports[index];

                      return Card(
                        margin: const EdgeInsets.only(
                          bottom: 12,
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor:
                            Colors.green.shade100,
                            child: const Icon(
                              Icons.recycling,
                              color: Colors.green,
                            ),
                          ),
                          title: Text(
                            report['name'] ?? 'Sin nombre',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Padding(
                            padding:
                            const EdgeInsets.only(top: 5),
                            child: Text(
                              '${report['address'] ?? 'Sin dirección'}\n'
                                  '♻️ +10 EcoPuntos',
                            ),
                          ),
                          trailing: const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}