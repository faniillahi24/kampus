import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';  // Untuk font yang lebih cantik
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
      backgroundColor: Colors.grey.shade100,  // Latar belakang lebih lembut
      appBar: AppBar(
        backgroundColor: Colors.teal.shade600,  // Warna AppBar lebih menarik dan konsisten
        elevation: 4,
        title: Text(
          'Detail Kampus',
          style: GoogleFonts.poppins(  // Gunakan font Poppins
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: FutureBuilder<DataKampus>(
        future: _kampusDetail,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.teal,  // Warna loader yang sesuai dengan tema
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Terjadi kesalahan: ${snapshot.error}',
                style: GoogleFonts.poppins(
                  color: Colors.red.shade700,
                  fontSize: 16,
                ),
              ),
            );
          } else if (!snapshot.hasData) {
            return Center(
              child: Text(
                'Data tidak ditemukan',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),
            );
          } else {
            final kampus = snapshot.data!;
            final lokasi = LatLng(kampus.latitude, kampus.longitude);

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    elevation: 6,  // Bayangan lebih tebal untuk efek 3D
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    color: Colors.white,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.lightBlue.shade100, Colors.white],  // Gradient untuk latar belakang cantik
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                kampus.nama,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal.shade700,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            _infoRow(Icons.location_on, "Alamat: ${kampus.alamat}", Colors.red.shade700),
                            _infoRow(Icons.phone, "Telp: ${kampus.telpon}", Colors.green.shade700),
                            _infoRow(Icons.category, "Kategori: ${kampus.kategori}", Colors.orange.shade700),
                            _infoRow(Icons.school, "Jurusan: ${kampus.jurusan}", Colors.black),
                            _infoRow(Icons.map, "Latitude: ${kampus.latitude}", Colors.blue.shade700),
                            _infoRow(Icons.map_outlined, "Longitude: ${kampus.longitude}", Colors.blue.shade700),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Lokasi Kampus di Peta:',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal.shade700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ClipRRect(
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
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22, color: iconColor),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
