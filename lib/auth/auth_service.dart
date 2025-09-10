import 'dart:developer';

import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {

final SupabaseClient _supabase= Supabase.instance.client;


//sign in

Future<AuthResponse>signInWithEmailPassword(
  String email,
  String password,
  
  )
  async{

//sihn in request 

return await _supabase.auth.signInWithPassword(
  email: email,  
  password: password);


}


//sign up

Future<AuthResponse>signUpWithEmailPassword(
  String email,
  String password,
  )async{

    return await _supabase.auth.signUp(email:email ,password:  password);
  }

//sign out

Future<void>signOut()async{
  return await _supabase.auth.signOut();

String? getCurrentUserEmail(){

final Session = _supabase.auth.currentSession;

final User = Session?.user;

return User?.email;


}

}
}