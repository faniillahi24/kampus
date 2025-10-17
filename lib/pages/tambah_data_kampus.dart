import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';  // Import untuk font yang lebih cantik
import '../model/data_kampus.dart';
import '../services/api_service.dart';

class TambahDataKampusPage extends StatefulWidget {
  const TambahDataKampusPage({Key? key}) : super(key: key);

  @override
  State<TambahDataKampusPage> createState() => _TambahDataKampusPageState();
}

class _TambahDataKampusPageState extends State<TambahDataKampusPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _telponController = TextEditingController();
  final TextEditingController _kategoriController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();
  final TextEditingController _jurusanController = TextEditingController();

  void _simpanData() async {
    if (_formKey.currentState!.validate()) {
      final kampus = DataKampus(
        nama: _namaController.text,
        alamat: _alamatController.text,
        telpon: _telponController.text,
        kategori: _kategoriController.text,
        latitude: double.parse(_latitudeController.text),
        longitude: double.parse(_longitudeController.text),
        jurusan: _jurusanController.text,
      );

      try {
        await ApiService.create(kampus);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data berhasil ditambahkan')),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal: $e')),
        );
      }
    }
  }

  Widget _buildInput({
    required String label,
    required IconData icon,
    required Color iconColor,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),  // Padding lebih lega
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: iconColor, size: 22),  // Ukuran ikon lebih besar
          labelText: label,
          labelStyle: GoogleFonts.poppins(color: Colors.grey.shade700),  // Font label lebih stylish
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.teal.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.teal.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.teal.shade600, width: 2),
          ),
          filled: true,
          fillColor: Colors.grey.shade50,  // Warna filled lebih lembut
        ),
        style: GoogleFonts.poppins(fontSize: 16, color: Colors.black87),  // Font teks input
        validator: (value) => value!.isEmpty ? '$label tidak boleh kosong' : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,  // Latar belakang lebih lembut
      appBar: AppBar(
        backgroundColor: Colors.teal.shade600,  // Warna AppBar lebih menarik
        elevation: 4,
        title: Text(
          'Tambah Data Kampus',
          style: GoogleFonts.poppins(  // Gunakan font Poppins
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade50, Colors.white],  // Gradient untuk latar belakang cantik
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(20),  // Padding lebih besar untuk layout rapi
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildInput(
                label: 'Nama',
                icon: Icons.school,
                iconColor: Colors.teal.shade700,
                controller: _namaController,
              ),
              _buildInput(
                label: 'Alamat',
                icon: Icons.location_on,
                iconColor: Colors.red.shade700,
                controller: _alamatController,
              ),
              _buildInput(
                label: 'Telpon',
                icon: Icons.phone,
                iconColor: Colors.green.shade700,
                controller: _telponController,
                keyboardType: TextInputType.phone,
              ),
              _buildInput(
                label: 'Kategori',
                icon: Icons.category,
                iconColor: Colors.orange.shade700,
                controller: _kategoriController,
              ),
              _buildInput(
                label: 'Jurusan',
                icon: Icons.book,
                iconColor: Colors.black,
                controller: _jurusanController,
              ),
              _buildInput(
                label: 'Latitude',
                icon: Icons.map,
                iconColor: Colors.blue.shade700,
                controller: _latitudeController,
                keyboardType: TextInputType.number,
              ),
              _buildInput(
                label: 'Longitude',
                icon: Icons.navigation,
                iconColor: Colors.blue.shade700,
                controller: _longitudeController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 24),  // Spasi lebih besar sebelum button
              ElevatedButton.icon(
                icon: const Icon(Icons.save, color: Colors.white),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal.shade600,  // Warna button serasi
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                  elevation: 5,  // Tambahkan bayangan untuk efek 3D
                ),
                onPressed: _simpanData,
                label: Text(
                  'Simpan',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
