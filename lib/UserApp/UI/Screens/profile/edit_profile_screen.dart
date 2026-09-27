import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:shop_easy/UserApp/core/constant/colors.dart';
import 'package:shop_easy/UserApp/core/constant/text_style.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // Controllers
  final TextEditingController nameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController phoneController = TextEditingController();

  final TextEditingController addressController = TextEditingController();


  final FirebaseAuth auth = FirebaseAuth.instance;

  final FirebaseFirestore db = FirebaseFirestore.instance;

  final FirebaseStorage storage = FirebaseStorage.instance;


  bool isLoading = true;
  bool isSaving = false;


  File? selectedImage;
  String profileImage = "";

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    try {
      final User? user = auth.currentUser;

      if (user == null) {
        return;
      }

      nameController.text = user.displayName ?? "";

      emailController.text = user.email ?? "";


      final DocumentSnapshot<Map<String, dynamic>> doc = await db
          .collection("users")
          .doc(user.uid)
          .get();

      if (doc.exists) {
        final data = doc.data();

        if (data != null) {
          phoneController.text = data["phone"] ?? "";

          addressController.text = data["address"] ?? "";

          profileImage = data["profileImage"] ?? "";
        }
      }

      // If Firestore doesn't have image,
      // use Firebase Auth photoURL.
      if (profileImage.isEmpty &&
          user.photoURL != null &&
          user.photoURL!.isNotEmpty) {
        profileImage = user.photoURL!;
      }
    } catch (e) {
      debugPrint("Load Profile Error: $e");

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Failed to load profile: $e")));
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();

      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
      );

      if (image == null) {
        return;
      }

      if (!mounted) return;

      setState(() {
        selectedImage = File(image.path);
      });
    } catch (e) {
      debugPrint("Image Picker Error: $e");

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Could not select image: $e")));
    }
  }

  Future<String?> uploadProfileImage(String userId) async {
    // No new image selected
    if (selectedImage == null) {
      if (profileImage.isNotEmpty) {
        return profileImage;
      }

      return null;
    }

    try {
      final Reference ref = storage
          .ref()
          .child("profileImages")
          .child("$userId.jpg");

      await ref.putFile(selectedImage!);

      final String downloadUrl = await ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      debugPrint("Upload Image Error: $e");

      rethrow;
    }
  }

  Future<void> saveProfile() async {
    final User? user = auth.currentUser;

    if (user == null) {
      return;
    }

    // Validate name
    if (nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please enter your name")));

      return;
    }

    // Validate email
    if (emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please enter your email")));

      return;
    }

    try {
      setState(() {
        isSaving = true;
      });

      final String? imageUrl = await uploadProfileImage(user.uid);

      await user.updateDisplayName(nameController.text.trim());

      if (imageUrl != null && imageUrl.isNotEmpty) {
        await user.updatePhotoURL(imageUrl);
      }

      final String newEmail = emailController.text.trim();

      final String currentEmail = user.email ?? "";

      if (newEmail != currentEmail) {
        await user.verifyBeforeUpdateEmail(newEmail);
      }

      await db.collection("users").doc(user.uid).set({
        "uid": user.uid,

        "name": nameController.text.trim(),

        "email": newEmail,

        "phone": phoneController.text.trim(),

        "address": addressController.text.trim(),

        "profileImage": imageUrl ?? "",

        "updatedAt": FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            newEmail != currentEmail
                ? "Profile updated. Please verify your new email."
                : "Profile updated successfully.",
          ),
        ),
      );

      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      String message = "Something went wrong.";

      if (e.code == "requires-recent-login") {
        message = "Please login again before changing your email.";
      } else if (e.code == "email-already-in-use") {
        message = "This email is already being used.";
      } else if (e.code == "invalid-email") {
        message = "Please enter a valid email address.";
      } else if (e.code == "weak-password") {
        message = "The password is too weak.";
      } else if (e.message != null) {
        message = e.message!;
      }

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } on FirebaseException catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "Firebase error occurred.")),
      );
    } catch (e) {
      debugPrint("Save Profile Error: $e");

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,

      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 0,

        title: Text(
          "Edit Profile",
          style: style16.copyWith(fontWeight: FontWeight.bold),
        ),
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 45,
                          backgroundColor: primaryColor,

                          child: CircleAvatar(
                            radius: 42,
                            backgroundColor: Colors.grey.shade200,

                            backgroundImage: selectedImage != null
                                ? FileImage(selectedImage!)
                                : profileImage.isNotEmpty
                                ? NetworkImage(profileImage)
                                : null,

                            child: selectedImage == null && profileImage.isEmpty
                                ? Icon(
                                    Icons.person,
                                    size: 55,
                                    color: secondaryColor,
                                  )
                                : null,
                          ),
                        ),

                        TextButton(
                          onPressed: isSaving ? null : pickImage,

                          child: Text(
                            "Change Profile Picture",
                            style: TextStyle(color: primaryColor, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 15),

                  const Text(
                    "Full Name",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                  ),

                  const SizedBox(height: 6),

                  TextField(
                    controller: nameController,

                    textInputAction: TextInputAction.next,

                    decoration: InputDecoration(
                      filled: true,
                      fillColor: whiteColor,

                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  const Text(
                    "Email Address",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                  ),

                  const SizedBox(height: 6),

                  TextField(
                    controller: emailController,

                    keyboardType: TextInputType.emailAddress,

                    textInputAction: TextInputAction.next,

                    decoration: InputDecoration(
                      filled: true,
                      fillColor: whiteColor,

                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  const Text(
                    "Phone Number",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                  ),

                  const SizedBox(height: 6),

                  TextField(
                    controller: phoneController,

                    keyboardType: TextInputType.phone,

                    textInputAction: TextInputAction.next,

                    decoration: InputDecoration(
                      filled: true,
                      fillColor: whiteColor,

                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  const Text(
                    "Default Address",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                  ),

                  const SizedBox(height: 6),

                  TextField(
                    controller: addressController,

                    maxLines: 3,

                    decoration: InputDecoration(
                      filled: true,
                      fillColor: whiteColor,

                      contentPadding: const EdgeInsets.all(12),

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    height: 52,

                    child: ElevatedButton(
                      onPressed: isSaving ? null : saveProfile,

                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,

                        foregroundColor: whiteColor,

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),

                      child: isSaving
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              "Save Changes",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
