import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:my_portfolio/core/constants.dart';

class AdminAccessScreen extends StatefulWidget {
  const AdminAccessScreen({super.key});

  @override
  State<AdminAccessScreen> createState() => _AdminAccessScreenState();
}

class _AdminAccessScreenState extends State<AdminAccessScreen> {
  final userNameController = TextEditingController();
  final mobileNoController = TextEditingController();
  final emailIdController = TextEditingController();
  final designationController = TextEditingController();
  final DatabaseReference dbRef =
  FirebaseDatabase.instance.ref(Constants.userDetails);

  @override
  void initState() {
    super.initState();
    _loadUserDetails(); // 🔹 Fetch data when app opens
  }

  /// 🔹 Fetch saved user details from Firebase
  Future<void> _loadUserDetails() async {
    try {
      final snapshot = await dbRef.child('admin_info').get();

      if (snapshot.exists) {
        final data = snapshot.value as Map<dynamic, dynamic>;
        setState(() {
          userNameController.text = data['name'] ?? '';
          mobileNoController.text = data['mobileNumber'] ?? '';
          emailIdController.text = data['emailId'] ?? '';
          designationController.text = data['designation'] ?? '';
        });
        debugPrint('Loaded user details: ${data['name']}');
      } else {
        debugPrint('No user details found in database.');
      }
    } catch (e) {
      debugPrint('Error loading user details: $e');
    }
  }

  /// 🔹 Save or update user details
  Future<void> saveUserDetails() async {
    final name = userNameController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a name')),
      );
      return;
    }

    try {
      await dbRef.child('admin_info').update({
        'name': name,
        'mobileNumber': mobileNoController.text,
        'emailId': emailIdController.text,
        'designation': designationController.text,
        'updatedAt': DateTime.now().toIso8601String(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User details updated successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving data: $e')),
      );
      debugPrint('Error saving data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Portfolio Admin')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              spacing: 16,
              children: [
                TextFormField(
                  controller: userNameController,
                  decoration: const InputDecoration(
                    labelText: 'Enter user name',
                    border: OutlineInputBorder(),
                  ),
                ),
                TextFormField(
                  controller: mobileNoController,
                  decoration: const InputDecoration(
                    labelText: 'Enter Mobile Number',
                    border: OutlineInputBorder(),
                  ),
                ),
                TextFormField(
                  controller: emailIdController,
                  decoration: const InputDecoration(
                    labelText: 'Enter Email Id',
                    border: OutlineInputBorder(),
                  ),
                ),
                TextFormField(
                  controller: designationController,
                  decoration: const InputDecoration(
                    labelText: 'Enter Designation',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: saveUserDetails,
                  child: const Text('Save User Details'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
