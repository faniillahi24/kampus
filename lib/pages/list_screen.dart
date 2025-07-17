import 'package:flutter/material.dart';
import '../model/data_kampus.dart';
import '../services/api_service.dart';
import 'tambah_data_kampus.dart';
import 'edit_data_kampus.dart';
import 'detail_data_kampus.dart'; // ⬅️ Tambahkan import detail page

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
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: Colors.teal.shade100,
              radius: 28,
              child: const Icon(Icons.account_balance, color: Colors.lightBlue, size: 30),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      kampus.nama,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _infoRow(Icons.location_on, "Alamat: ${kampus.alamat}", Colors.red),
                    _infoRow(Icons.phone, "Telp: ${kampus.telpon}", Colors.green),
                    _infoRow(Icons.category, "Kategori: ${kampus.kategori}", Colors.orange),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
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
                  icon: const Icon(Icons.delete, color: Colors.red),
                  tooltip: 'Hapus',
                  onPressed: () => _confirmDelete(kampus.id!),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        elevation: 2,
        title: const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Data Kampus',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
      ),
      body: FutureBuilder<List<DataKampus>>(
        future: _kampusList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Terjadi Kesalahan: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Belum ada data kampus'));
          } else {
            return RefreshIndicator(
              onRefresh: () async => _refresh(),
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 80),
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
        backgroundColor: Colors.lightBlue,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Tambah Data',
          style: TextStyle(color: Colors.white),
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
    padding: const EdgeInsets.symmetric(vertical: 2),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Icon(icon, size: 18, color: color),
        ),
        const SizedBox(width: 6),
        Expanded(child: Text(text)),
      ],
    ),
  );
}