import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import 'login.dart';

class Admin extends StatefulWidget {
  const Admin({super.key});

  @override
  State<Admin> createState() => _TeacherState();
}

class _TeacherState extends State<Admin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[200],
        automaticallyImplyLeading: false,
        leading: Padding(
          padding: const EdgeInsets.all(15.0),
          child: CircleAvatar(
            backgroundColor: Colors.grey, // Ganti warna sesuai kebutuhan
            radius: 20, // Sesuaikan radius dengan keinginan Anda
            child: Icon(
              Icons.people,
              color: Colors.white, // Ganti warna ikon sesuai kebutuhan
            ),
          ),
        ),
        title: Text(
          "Admin",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              logout(context);
            },
            icon: Icon(
              Icons.logout,
            ),
            color: Colors.white,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Lottie.asset(
                'assets/lottie/welcome.json', // Ganti dengan path file animasi Lottie lokal
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            Text(
              "Selamat Datang Admin",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Tampilkan dialog atau navigasi ke halaman tambah jadwal
          // Misalnya:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddSchedulePage()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    CircularProgressIndicator();
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
  }
}

class AddSchedulePage extends StatefulWidget {
  @override
  _AddSchedulePageState createState() => _AddSchedulePageState();
}

class _AddSchedulePageState extends State<AddSchedulePage> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _judulController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[300],
        automaticallyImplyLeading: false,
        title: Text(
          "Tambah Jadwal",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new),
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _namaController,
              decoration: InputDecoration(labelText: "Nama Mahasiswa"),
            ),
            TextField(
              controller: _judulController,
              decoration: InputDecoration(labelText: "Judul"),
            ),
            ListTile(
              title: Text(
                  "Tanggal: ${DateFormat('dd-MMM-yyyy').format(_selectedDate)}"),
              trailing: Icon(Icons.calendar_today),
              onTap: () async {
                await _selectDate(context);
                // Setelah pemilihan tanggal, perbarui tampilan
                setState(() {});
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Panggil fungsi untuk menyimpan jadwal ke Firestore
                saveSchedule(context);
              },
              child: Text("Tambahkan Jadwal"),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> saveSchedule(BuildContext context) async {
    // Ambil data dari controller
    String nama = _namaController.text;
    String judul = _judulController.text;

    // Validasi apakah data telah diisi
    if (nama.isNotEmpty && judul.isNotEmpty) {
      // Kirim data ke Firestore
      await FirebaseFirestore.instance.collection('jadwal').add({
        'nama': nama,
        'judul': judul,
        'tanggal': DateFormat('yyyy-MM-dd').format(_selectedDate),
      });

      // Tampilkan pesan sukses dan kembali ke halaman Admin
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Jadwal berhasil ditambahkan!'),
        ),
      );
      Navigator.pop(context);
    } else {
      // Tampilkan pesan error jika ada data yang belum diisi
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Semua kolom harus diisi!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
