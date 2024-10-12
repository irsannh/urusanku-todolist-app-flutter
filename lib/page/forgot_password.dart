import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:urusanku_app/config/app_color.dart';
import 'package:urusanku_app/page/success_reset_password.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  Future<void> resetPassword() async {
    if (_formKey.currentState!.validate()) {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text.trim());
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Berhasil Mengirim Email Untuk Reset Password', style: GoogleFonts.plusJakartaSans(
              textStyle: TextStyle(
                  color: Colors.white, fontSize: 14, fontWeight: FontWeight.normal
              )
          ),), backgroundColor: Colors.green,)
      );
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => SuccessResetPassword()), (Route<dynamic> route) => false);
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
                      SizedBox(height: 270,),
                      Text('Lupa Password', style: GoogleFonts.plusJakartaSans(textStyle: TextStyle(
                        color: Colors.black, fontSize: 20, fontWeight: FontWeight.w600
                      )),),
                      SizedBox(height: 28,),
                      Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                              SizedBox(height: 32,),
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
                                      resetPassword();
                                    }, child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.lock, color: Colors.white,),
                                    SizedBox(width: 8,),
                                    Text('Reset Kata Sandi', style: GoogleFonts.plusJakartaSans(
                                        textStyle: TextStyle(
                                            color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold
                                        )
                                    ),)
                                  ],
                                )),
                              ),
                            ],
                          )
                      ),
                    ],
                  ),
                )
            ),
          ),
      )
    );
  }
}
