import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import 'login.dart';

class Usert extends StatefulWidget {
  const Usert({super.key});

  @override
  State<Usert> createState() => _UserState();
}

class _UserState extends State<Usert> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
          "User",
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
              "Selamat Datang User",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SeminarSchedulePage()),
                );
              },
              icon: Icon(
                Icons.calendar_month_sharp,
                size: 50,
              ),
            ),
          ],
        ),
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

class SeminarSchedulePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.deepPurple[300],
        automaticallyImplyLeading: false,
        title: Text(
          "Jadwal Seminar",
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
      body: SeminarScheduleList(),
    );
  }
}

class SeminarScheduleList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('jadwal').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        // Jika tidak ada error dan snapshot sudah memiliki data
        List<QueryDocumentSnapshot> documents = snapshot.data!.docs;

        return ListView.builder(
          itemCount: documents.length,
          itemBuilder: (context, index) {
            // Dapatkan data jadwal dari Firestore
            Map<String, dynamic> scheduleData =
                documents[index].data() as Map<String, dynamic>;

            // Tampilkan data jadwal
            return SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      scheduleData['nama'],
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Judul\t\t\t: ${scheduleData['judul']}',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    // Text(
                    //   'Tanggal: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(scheduleData['tanggal']))}',
                    // ),

                    Text('Tanggal: ${scheduleData['tanggal']}'),
                  ],
                ),
              ),
            );
            // ListTile(
            //   title: Text(
            //     scheduleData['nama'],
            //     style: TextStyle(
            //       fontSize: 20,
            //       fontWeight: FontWeight.bold,
            //     ),
            //   ),
            //   subtitle: Text(
            //       'Judul: ${scheduleData['judul']}\nTanggal: ${scheduleData['tanggal']}'),
            //   // Tambahkan fungsi lainnya sesuai kebutuhan
            // );
          },
        );
      },
    );
  }
}
