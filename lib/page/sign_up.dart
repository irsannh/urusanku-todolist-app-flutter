import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:urusanku_app/config/app_color.dart';
import 'package:urusanku_app/page/sign_in.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:urusanku_app/page/success_register.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();

  Future<void> register() async {
    if (_formKey.currentState!.validate()) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _emailController.text.trim(), password: _passwordController.text.trim());
        UserCredential userLogin = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: _emailController.text.trim(), password: _passwordController.text.trim());
        String uid = userLogin.user!.uid;
        String? fcmToken = await FirebaseMessaging.instance.getToken();
        String name = _nameController.text.trim();
        DatabaseReference ref = FirebaseDatabase.instance.ref("UsersData/$uid");
        await ref.set({
          "name": name,
          "fcmToken": fcmToken,
          "isLoggedIn": true,
          "tasks": {}
        });
        await FirebaseMessaging.instance.setAutoInitEnabled(true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Berhasil Membuat Akun', style: GoogleFonts.plusJakartaSans(
            textStyle: TextStyle(
              color: Colors.white, fontSize: 14, fontWeight: FontWeight.normal
            )
          ),), backgroundColor: Colors.green,)
        );
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => SuccessRegister()), (
            Route<dynamic> route) => false);
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi Kesalahan: ${e.message}', style: GoogleFonts.plusJakartaSans(textStyle: TextStyle(
              color: Colors.white, fontSize: 14, fontWeight: FontWeight.normal
          )),), backgroundColor: Colors.red,),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi Kesalahan', style: GoogleFonts.plusJakartaSans(textStyle: TextStyle(
          color: Colors.white, fontSize: 14, fontWeight: FontWeight.normal
        )),), backgroundColor: Colors.red,),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        reverse: true,
        child: Padding(
          padding: EdgeInsets.only(bottom: bottom),
          child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Image.asset('images/logo_dua.png', width: 64, height: 64,),
                        SizedBox(width: 8,),
                        Text('UrusanKu', style: GoogleFonts.plusJakartaSans(textStyle: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18, color: AppColor.blueColor
                        )),)
                      ],
                    ),
                    SizedBox(height: 23,),
                    Text('Selamat Datang!', style: GoogleFonts.plusJakartaSans(textStyle: TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 20, color: Colors.black
                    )),),
                    SizedBox(height: 12,),
                    Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Nama', style: GoogleFonts.plusJakartaSans(textStyle: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black
                            )),),
                            SizedBox(height: 8,),
                            TextFormField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                hintText: 'Masukkan nama anda di sini',
                                hintStyle: GoogleFonts.plusJakartaSans(
                                    textStyle: TextStyle(
                                        color: AppColor.grayColor, fontSize: 16, fontWeight: FontWeight.w600
                                    )
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: AppColor.grayColor, width: 1),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: AppColor.blueColor, width: 1),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.red, width: 1),
                                ),
                                errorStyle: TextStyle(
                                  height: 1, // Mengurangi tinggi pesan error
                                  color: Colors.red,
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 14.0,
                                  horizontal: 16.0, // Padding konsisten agar teks di dalam field tetap rapi
                                ),
                                helperText: ' ',
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Nama tidak boleh kosong';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 8,),
                            Text('Email', style: GoogleFonts.plusJakartaSans(textStyle: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black
                            )),),
                            SizedBox(height: 8,),
                            TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                hintText: 'Masukkan email di sini',
                                hintStyle: GoogleFonts.plusJakartaSans(
                                    textStyle: TextStyle(
                                        color: AppColor.grayColor, fontSize: 16, fontWeight: FontWeight.w600
                                    )
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: AppColor.grayColor, width: 1),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: AppColor.blueColor, width: 1),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.red, width: 1),
                                ),
                                errorStyle: TextStyle(
                                  height: 1, // Mengurangi tinggi pesan error
                                  color: Colors.red,
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 14.0,
                                  horizontal: 16.0, // Padding konsisten agar teks di dalam field tetap rapi
                                ),
                                helperText: ' ',
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Email tidak boleh kosong';
                                }
                                if (!value!.contains('@')) {
                                  return 'Masukkan email yang valid';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 8,),
                            Text('Kata Sandi', style: GoogleFonts.plusJakartaSans(textStyle: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black
                            )),),
                            SizedBox(height: 8,),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                hintText: 'Masukkan kata sandi di sini',
                                hintStyle: GoogleFonts.plusJakartaSans(
                                    textStyle: TextStyle(
                                        color: AppColor.grayColor, fontSize: 16, fontWeight: FontWeight.w600
                                    )
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: AppColor.grayColor, width: 1),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: AppColor.blueColor, width: 1),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.red, width: 1),
                                ),
                                errorStyle: TextStyle(
                                  height: 1, // Mengurangi tinggi pesan error
                                  color: Colors.red,
                                ),
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 14.0,
                                  horizontal: 16.0, // Padding konsisten agar teks di dalam field tetap rapi
                                ),
                                helperText: ' ',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Kata sandi tidak boleh kosong';
                                }
                                if (value!.length < 8) {
                                  return 'Kata sandi minimal 8 karakter';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 8,),
                            Text('Konfirmasi Kata Sandi', style: GoogleFonts.plusJakartaSans(textStyle: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black
                            )),),
                            SizedBox(height: 8,),
                            TextFormField(
                              controller: _confirmPasswordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                hintText: 'Konfirmasikan kata sandi di sini',
                                hintStyle: GoogleFonts.plusJakartaSans(
                                    textStyle: TextStyle(
                                        color: AppColor.grayColor, fontSize: 16, fontWeight: FontWeight.w600
                                    )
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: AppColor.grayColor, width: 1),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: AppColor.blueColor, width: 1),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.red, width: 1),
                                ),
                                errorStyle: TextStyle(
                                  height: 1, // Mengurangi tinggi pesan error
                                  color: Colors.red,
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 14.0,
                                  horizontal: 16.0, // Padding konsisten agar teks di dalam field tetap rapi
                                ),
                                helperText: ' ', // Menambahkan ruang tetap agar TextFormField tidak mengecil
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Kata sandi tidak boleh kosong';
                                }
                                if (value != _passwordController.text) {
                                  return 'Kata sandi yang dimasukkan berbeda';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 12,),
                            SizedBox(
                              height: 52, width: double.infinity,
                              child: ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all(AppColor.blueColor),
                                      shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(12)
                                          )
                                      )
                                  ),
                                  onPressed: (){
                                    register();
                                  }, child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.group_add, color: Colors.white,),
                                  SizedBox(width: 8,),
                                  Text('Buat Akun', style: GoogleFonts.plusJakartaSans(
                                      textStyle: TextStyle(
                                          color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold
                                      )
                                  ),)
                                ],
                              )),
                            ),
                            SizedBox(height: 8,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Sudah Punya Akun?', style: GoogleFonts.plusJakartaSans(
                                  textStyle: TextStyle(
                                    color: Colors.black, fontSize: 14, fontWeight: FontWeight.normal
                                  )
                                ),),
                                SizedBox(width: 2,),
                                TextButton(onPressed: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => SignInPage()));
                                }, child: Text('Masuk', style: GoogleFonts.plusJakartaSans(
                                  textStyle: TextStyle(
                                    color: AppColor.blueColor, fontSize: 14, fontWeight: FontWeight.w600
                                  )
                                ),))
                              ],
                            )
                          ],
                        ))
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
