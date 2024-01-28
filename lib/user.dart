// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();
String? langu;
class UserP extends StatelessWidget {

  final User? user = _auth.currentUser;
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  Future<void> _signOut(BuildContext context) async {
    // Call your sign-out function
    await googleSignIn.signOut();
    await _auth.signOut();
    Navigator.pop(context);
  }



  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
  }

  UserP(BuildContext context, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(AppLocalizations.of(context)?.userinf ?? 'User Info')
      ),
      body: SingleChildScrollView(child:
      Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(user!.photoURL!),
              ),
              const SizedBox(height: 20),
              Text(
                '${user!.displayName}',
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 5),
              Text(
                '${user!.email}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),

              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                },

                child: Text(AppLocalizations.of(context)?.selectlang ?? 'change language'),
              ),
              const SizedBox(height: 30),
              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: () {
                  _signOut(context);
                  // Add any additional functionality or navigation here
                },
                child:  Text(('Sign Out').toString()),
              ),
            ]),
      ),
      ),
    );
  }
}
