import 'dart:io';
import 'package:brsm_id/screens/myachievements.dart';
import 'package:brsm_id/screens/myevents.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:brsm_id/service/pickimage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:brsm_id/screens/moipokypki.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? _avatarPath;
  Map<String, dynamic>? userData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAvatarPath(); 
    fetchUserData();
  }
   Future<void> fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (doc.exists) {
      setState(() {
        userData = doc.data();
        isLoading = false;
      });
    }
  }
  
  Future<void> _loadAvatarPath() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _avatarPath = prefs.getString('avatarPath');
    });
  }

  Future<void> _saveAvatarPath(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('avatarPath', path);
  }


  Future<void> _updateAvatar() async {
    final path = await pickAndSaveAvatar();
    if (path != null) {
      await _saveAvatarPath(path); 
      setState(() {
        _avatarPath = path;
      });
    }
  }

  Widget _buildInfoCard(
  String title,
  String value, {
  VoidCallback? onTap,      
  IconData? icon,           
}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(15),
    child: Card(
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Row(
          children: [
            
            Text(
              '$title ',
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'montserrat'),
            ),
            Expanded(
              child: Text(
                value,
                style: const TextStyle(
                    fontSize: 16, fontFamily: 'montserrat', fontWeight: FontWeight.bold),
                textAlign: TextAlign.start,
              ),
            ),
            if (icon != null) ...[
              
              Icon(icon, size: 24, color: Colors.green),
              const SizedBox(width: 10),
            ],
          ],
        ),
      ),
    ),
  );
}


 




  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: Color.fromARGB(255, 116, 199, 130),
          ),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 30),
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: _avatarPath != null
                          ? FileImage(File(_avatarPath!))
                          : null,
                      child: _avatarPath == null
                          ? const Icon(Icons.person, size: 60)
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 4,
                      child: GestureDetector(
                        onTap: _updateAvatar,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.green,
                            border: Border.all(width: 2, color: Colors.white),
                          ),
                          padding: const EdgeInsets.all(8),
                          child: const Icon(Icons.edit, size: 20, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      userData?['name'] ?? '',
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'montserrat'),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      userData?['lastname'] ?? '',
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'montserrat'),
                    ),
                    
                  ],
                ),

                const SizedBox(height: 5),

                 Text(
                     ('Баллы: ${userData?['points'].toString() ?? ''}'),
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'montserrat'),
                    ),

                const SizedBox(height: 20),

                if (userData?['nomer'] != null)
                  _buildInfoCard('Номер', userData!['nomer'].toString()),

               

                _buildInfoCard(
                  "Мои покупки",
                  "",
                  icon: Icons.chevron_right,
                   onTap: () {
                   Navigator.push(context, MaterialPageRoute(builder: (_) => Moipokypki()));
                    },
                    ),

                     _buildInfoCard(
                  "Мои достижения",
                  "",
                  icon: Icons.chevron_right,
                   onTap: () {
                   Navigator.push(context, MaterialPageRoute(builder: (_) => Myachievements()));
                    },
                    ),

                     _buildInfoCard(
                  "Мои события",
                  "",
                  icon: Icons.chevron_right,
                   onTap: () {
                   Navigator.push(context, MaterialPageRoute(builder: (_) => MyEventsPage()));
                    },
                    ),

                     const SizedBox(height: 20),

                    
                ElevatedButton.icon(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                  },
                  icon: const Icon(Icons.logout, color: Color.fromARGB(255, 255, 255, 255),),
                  label: const Text('Выйти', style: TextStyle(color: Color.fromARGB(255, 255, 255, 255),fontFamily: 'montserrat', fontWeight: FontWeight.bold), ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor:const Color.fromARGB(255, 116, 199, 130),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}