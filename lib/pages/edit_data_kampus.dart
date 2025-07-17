
import 'package:flutter/material.dart';
import '../model/data_kampus.dart';
import '../services/api_service.dart';

class EditDataKampusPage extends StatefulWidget {
  final DataKampus data;

  const EditDataKampusPage({Key? key, required this.data}) : super(key: key);

  @override
  State<EditDataKampusPage> createState() => _EditDataKampusPageState();
}

class _EditDataKampusPageState extends State<EditDataKampusPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _namaController;
  late TextEditingController _alamatController;
  late TextEditingController _telponController;
  late TextEditingController _kategoriController;
  late TextEditingController _latitudeController;
  late TextEditingController _longitudeController;
  late TextEditingController _jurusanController;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.data.nama);
    _alamatController = TextEditingController(text: widget.data.alamat);
    _telponController = TextEditingController(text: widget.data.telpon);
    _kategoriController = TextEditingController(text: widget.data.kategori);
    _latitudeController = TextEditingController(text: widget.data.latitude.toString());
    _longitudeController = TextEditingController(text: widget.data.longitude.toString());
    _jurusanController = TextEditingController(text: widget.data.jurusan);
  }

  void _updateData() async {
    if (_formKey.currentState!.validate()) {
      final updatedData = DataKampus(
        id: widget.data.id,
        nama: _namaController.text,
        alamat: _alamatController.text,
        telpon: _telponController.text,
        kategori: _kategoriController.text,
        latitude: double.parse(_latitudeController.text),
        longitude: double.parse(_longitudeController.text),
        jurusan: _jurusanController.text,
      );

      try {
        await ApiService.update(widget.data.id!, updatedData);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data berhasil diperbarui')),
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
    required TextEditingController controller,
    required Color iconColor,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: iconColor),
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.grey.shade100,
        ),
        validator: (value) => value!.isEmpty ? '$label tidak boleh kosong' : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        elevation: 0,
        title: const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Edit Data Kampus',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: Container(
        color: Colors.grey.shade100,
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildInput(
                label: 'Nama',
                icon: Icons.school,
                iconColor: Colors.teal,
                controller: _namaController,
              ),
              _buildInput(
                label: 'Alamat',
                icon: Icons.location_on,
                iconColor: Colors.red,
                controller: _alamatController,
              ),
              _buildInput(
                label: 'Telpon',
                icon: Icons.phone,
                iconColor: Colors.green,
                controller: _telponController,
                keyboardType: TextInputType.phone,
              ),
              _buildInput(
                label: 'Kategori',
                icon: Icons.category,
                iconColor: Colors.orange,
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
                iconColor: Colors.blue,
                controller: _latitudeController,
                keyboardType: TextInputType.number,
              ),
              _buildInput(
                label: 'Longitude',
                icon: Icons.navigation,
                iconColor: Colors.blue,
                controller: _longitudeController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.update, color: Colors.white),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: _updateData,
                label: const Text(
                  'Update',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
