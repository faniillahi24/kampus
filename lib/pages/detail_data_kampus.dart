import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../model/data_kampus.dart';
import '../services/api_service.dart';

class DetailDataKampusPage extends StatefulWidget {
  final int id;

  const DetailDataKampusPage({Key? key, required this.id}) : super(key: key);

  @override
  State<DetailDataKampusPage> createState() => _DetailDataKampusPageState();
}

class _DetailDataKampusPageState extends State<DetailDataKampusPage> {
  late Future<DataKampus> _kampusDetail;

  @override
  void initState() {
    super.initState();
    _kampusDetail = ApiService.fetchById(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Detail Kampus',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
      ),

      body: FutureBuilder<DataKampus>(
        future: _kampusDetail,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Data tidak ditemukan'));
          } else {
            final kampus = snapshot.data!;
            final lokasi = LatLng(kampus.latitude, kampus.longitude);

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 4,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              kampus.nama,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.lightBlue,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          _infoRow(Icons.location_on, "Alamat: ${kampus.alamat}", Colors.red),
                          _infoRow(Icons.phone, "Telp: ${kampus.telpon}", Colors.green),
                          _infoRow(Icons.category, "Kategori: ${kampus.kategori}", Colors.orange),
                          _infoRow(Icons.school, "Jurusan: ${kampus.jurusan}", Colors.black),
                          _infoRow(Icons.map, "Latitude: ${kampus.latitude}", Colors.blue),
                          _infoRow(Icons.map_outlined, "Longitude: ${kampus.longitude}", Colors.blue),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Lokasi Kampus di Peta:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: SizedBox(
                      height: 250,
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: lokasi,
                          zoom: 15,
                        ),
                        markers: {
                          Marker(
                            markerId: const MarkerId('lokasi_kampus'),
                            position: lokasi,
                            infoWindow: InfoWindow(title: kampus.nama),
                          )
                        },
                        myLocationEnabled: false,
                        zoomControlsEnabled: true,
                        mapType: MapType.normal,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _infoRow(IconData icon, String text, Color iconColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: iconColor),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}