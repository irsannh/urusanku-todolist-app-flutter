import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:urusanku_app/config/app_color.dart';
import 'package:urusanku_app/page/forgot_password.dart';
import 'package:urusanku_app/page/home_page.dart';
import 'package:urusanku_app/page/sign_up.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();

  Future<void> login() async {
    if (_formKey.currentState!.validate()) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: _emailController.text.trim(), password: _passwordController.text.trim());
        String uid = userCredential.user!.uid;
        String? fcmToken = await FirebaseMessaging.instance.getToken();
        DatabaseReference ref = FirebaseDatabase.instance.ref("UsersData/$uid");
        await ref.update({
          "fcmToken": fcmToken,
          "isLoggedIn": true,
        });
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Sukses Login', style: GoogleFonts.plusJakartaSans(
                textStyle: TextStyle(
                    color: Colors.white, fontSize: 14, fontWeight: FontWeight.normal
                )
            ),), backgroundColor: Colors.green,)
        );
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => HomePage()), (
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
                  SizedBox(height: 162,),
                  Text('Selamat Datang Kembali', style: GoogleFonts.plusJakartaSans(textStyle: TextStyle(
                    color: Colors.black, fontSize: 20, fontWeight: FontWeight.w600
                  )),),
                  SizedBox(height: 26,),
                  Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Email', style: GoogleFonts.plusJakartaSans(textStyle: TextStyle(
                            color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600
                          )),),
                          SizedBox(height: 8,),
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              hintText: 'Masukkan email anda di sini',
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
                          SizedBox(height: 1,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: TextButton(style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero, // Menghilangkan padding bawaan tombol
                                  minimumSize: Size(0, 0), // Ukuran minimum tombol
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Mengatur ukuran target tap lebih kecil
                                ), onPressed: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPasswordPage()));
                                }, child: Text('Lupa Kata Sandi?', style: GoogleFonts.plusJakartaSans(
                                  textStyle: TextStyle(color: AppColor.blueColor, fontSize: 14, fontWeight: FontWeight.normal),
                                ), textAlign: TextAlign.right,)),
                              ),
                            ],
                          ),
                          SizedBox(height: 16,),
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
                                  login();
                                }, child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.login, color: Colors.white,),
                                SizedBox(width: 8,),
                                Text('Masuk', style: GoogleFonts.plusJakartaSans(
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
                              Text('Belum Punya Akun?', style: GoogleFonts.plusJakartaSans(
                                  textStyle: TextStyle(
                                      color: Colors.black, fontSize: 14, fontWeight: FontWeight.normal
                                  )
                              ),),
                              SizedBox(width: 2,),
                              TextButton(onPressed: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPage()));
                              }, child: Text('Buat Akun', style: GoogleFonts.plusJakartaSans(
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
            ),
          ),
        ),
      ),
    );
  }
}
