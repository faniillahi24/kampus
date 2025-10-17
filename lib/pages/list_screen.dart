import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';  // Import untuk font yang lebih cantik
import '../model/data_kampus.dart';
import '../services/api_service.dart';
import 'tambah_data_kampus.dart';
import 'edit_data_kampus.dart';
import 'detail_data_kampus.dart';

class ListDataKampusPage extends StatefulWidget {
  const ListDataKampusPage({Key? key}) : super(key: key);

  @override
  State<ListDataKampusPage> createState() => _ListDataKampusPageState();
}

class _ListDataKampusPageState extends State<ListDataKampusPage> {
  late Future<List<DataKampus>> _kampusList;

  @override
  void initState() {
    super.initState();
    _kampusList = ApiService.fetchAll();
  }

  void _refresh() {
    setState(() {
      _kampusList = ApiService.fetchAll();
    });
  }

  void _confirmDelete(int id) async {
    final confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Konfirmasi Hapus"),
        content: const Text("Apakah kamu yakin ingin menghapus data ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Hapus"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await ApiService.delete(id);
      _refresh();
    }
  }

  Widget _buildCard(DataKampus kampus) {
    return Card(
      elevation: 6,  // Bayangan lebih tebal untuk efek 3D
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),  // Border lebih halus
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.lightBlue.shade100, Colors.white],  // Gradient untuk latar belakang yang cantik
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: Colors.teal.shade200,  // Warna lebih lembut
                radius: 30,
                child: const Icon(Icons.account_balance, color: Colors.teal, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailDataKampusPage(id: kampus.id!),
                      ),
                    );
                  },
                  splashColor: Colors.lightBlue.shade200,  // Efek splash yang lebih cantik
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        kampus.nama,
                        style: GoogleFonts.poppins(  // Gunakan font Poppins untuk tampilan modern
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.teal.shade700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _infoRow(Icons.location_on, "Alamat: ${kampus.alamat}", Colors.red.shade700),
                      _infoRow(Icons.phone, "Telp: ${kampus.telpon}", Colors.green.shade700),
                      _infoRow(Icons.category, "Kategori: ${kampus.kategori}", Colors.orange.shade700),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue, size: 24),
                    tooltip: 'Edit',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditDataKampusPage(data: kampus),
                        ),
                      ).then((_) => _refresh());
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color:Colors.red, size: 24),
                    tooltip: 'Hapus',
                    onPressed: () => _confirmDelete(kampus.id!),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,  // Latar belakang halaman lebih lembut
      appBar: AppBar(
        backgroundColor: Colors.teal.shade600,  // Warna AppBar lebih menarik
        elevation: 4,
        title: const Text(
          'Data Kampus',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
            fontFamily: 'Poppins',  // Gunakan font yang sama untuk konsistensi
          ),
        ),
      ),
      body: FutureBuilder<List<DataKampus>>(
        future: _kampusList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.teal,  // Warna loader lebih sesuai
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Terjadi Kesalahan: ${snapshot.error}',
                style: GoogleFonts.poppins(color: Colors.red.shade700),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'Belum ada data kampus',
                style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey.shade600),
              ),
            );
          } else {
            return RefreshIndicator(
              onRefresh: () async => _refresh(),
              color: Colors.teal,  // Warna refresh indicator
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return _buildCard(snapshot.data![index]);
                },
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.teal.shade600,  // Warna yang lebih serasi
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(
          'Tambah Data',
          style: GoogleFonts.poppins(color: Colors.white, fontSize: 16),
        ),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TambahDataKampusPage()),
          );
          _refresh();
        },
      ),
    );
  }
}

Widget _infoRow(IconData icon, String text, Color color) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
          ),
        ),
      ],
    ),
  );
}