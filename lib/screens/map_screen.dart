import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/recycling_point.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final TextEditingController searchController =
  TextEditingController();

  final List<RecyclingPoint> recyclingPoints = const [
    RecyclingPoint(
      name: 'EcoPunto Centro',
      address: 'Centro de Medellín',
      materials: 'Plástico · Vidrio · Papel',
      distance: '0.8 km',
      latitude: 6.2442,
      longitude: -75.5812,
    ),
    RecyclingPoint(
      name: 'Punto Verde Laureles',
      address: 'Laureles, Medellín',
      materials: 'Plástico · Cartón',
      distance: '2.1 km',
      latitude: 6.2447,
      longitude: -75.5989,
    ),
    RecyclingPoint(
      name: 'Recicla Parque',
      address: 'El Poblado, Medellín',
      materials: 'Vidrio · Papel · Cartón',
      distance: '3.4 km',
      latitude: 6.2088,
      longitude: -75.5681,
    ),
  ];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<RecyclingPoint> get filteredPoints {
    final query = searchController.text.toLowerCase().trim();

    if (query.isEmpty) {
      return recyclingPoints;
    }

    return recyclingPoints.where((point) {
      final name = point.name.toString().toLowerCase();
      final address = point.address.toString().toLowerCase();
      final materials =
      point.materials.toString().toLowerCase();

      return name.contains(query) ||
          address.contains(query) ||
          materials.contains(query);
    }).toList();
  }

  Future<void> openLocation(
        RecyclingPoint point,
      ) async {
    final latitude = point.latitude;
    final longitude = point.longitude;

    final url = Uri.parse(
      'https://www.google.com/maps/search/?api=1'
          '&query=$latitude,$longitude',
    );

    await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    );
  }

  void showPointDetails(
      BuildContext context,
        RecyclingPoint point,
      ) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.recycling,
                    color: Colors.green,
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      point.name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  const Icon(Icons.location_on),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      point.address,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  const Icon(Icons.recycling),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      point.materials,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  const Icon(Icons.near_me),
                  const SizedBox(width: 10),
                  Text(
                    point.distance,
                  ),
                ],
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () {
                    openLocation(point);
                  },
                  icon: const Icon(
                    Icons.directions,
                  ),
                  label: const Text(
                    'Ver ubicación',
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final points = filteredPoints;

    final markers = points.map((point) {
      return Marker(
        point: LatLng(
          point.latitude,
          point.longitude,
        ),
        width: 50,
        height: 60,
        child: GestureDetector(
          onTap: () {
            showPointDetails(
              context,
              point,
            );
          },
          child: const Icon(
            Icons.location_on,
            color: Colors.green,
            size: 46,
          ),
        ),
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Puntos de reciclaje',
        ),
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              16,
              16,
              16,
              10,
            ),
            child: TextField(
              controller: searchController,
              onChanged: (_) {
                setState(() {});
              },
              decoration: InputDecoration(
                hintText:
                'Buscar punto de reciclaje',
                prefixIcon:
                const Icon(Icons.search),
                suffixIcon:
                searchController.text.isNotEmpty
                    ? IconButton(
                  icon: const Icon(
                    Icons.clear,
                  ),
                  onPressed: () {
                    searchController.clear();
                    setState(() {});
                  },
                )
                    : null,
                border: OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(16),
                ),
              ),
            ),
          ),

          SizedBox(
            height: 320,
            child: Padding(
              padding:
              const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: ClipRRect(
                borderRadius:
                BorderRadius.circular(20),
                child: FlutterMap(
                  options: const MapOptions(
                    initialCenter: LatLng(
                      6.2442,
                      -75.5812,
                    ),
                    initialZoom: 12,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                      'https://tile.openstreetmap.org/'
                          '{z}/{x}/{y}.png',
                      userAgentPackageName:
                      'com.example.ecopunto',
                    ),
                    MarkerLayer(
                      markers: markers,
                    ),
                  ],
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(
              16,
              20,
              16,
              12,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                points.isEmpty
                    ? 'Sin resultados'
                    : 'Puntos cercanos',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          Expanded(
            child: points.isEmpty
                ? const Center(
              child: Column(
                mainAxisAlignment:
                MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_off,
                    size: 60,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'No encontramos puntos',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Prueba con otro término.',
                  ),
                ],
              ),
            )
                : ListView.builder(
              padding:
              const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              itemCount: points.length,
              itemBuilder:
                  (context, index) {
                final point =
                points[index];

                return Card(
                  margin:
                  const EdgeInsets.only(
                    bottom: 14,
                  ),
                  child: ListTile(
                    contentPadding:
                    const EdgeInsets.all(
                      14,
                    ),
                    leading: CircleAvatar(
                      backgroundColor:
                      Colors.green
                          .shade100,
                      child: const Icon(
                        Icons.recycling,
                        color: Colors.green,
                      ),
                    ),
                    title: Text(
                      point.name,
                      style:
                      const TextStyle(
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),
                    subtitle:
                    Padding(
                      padding:
                      const EdgeInsets
                          .only(
                        top: 6,
                      ),
                      child: Text(
                        '${point.address}\n'
                            '${point.materials}',
                      ),
                    ),
                    trailing: Text(
                      point.distance,
                      style:
                      const TextStyle(
                        fontWeight:
                        FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    onTap: () {
                      showPointDetails(
                        context,
                        point,
                      );
                    },
                  ),
                );
              },
            ),
          ),

          const Padding(
            padding:
            EdgeInsets.only(bottom: 8),
            child: Text(
              '© OpenStreetMap contributors',
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}