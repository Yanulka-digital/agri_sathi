import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
class AuthScreen extends StatefulWidget{const AuthScreen({super.key});@override State<AuthScreen> createState()=>_AuthScreenState();}
class _AuthScreenState extends State<AuthScreen>{
 final email=TextEditingController(),password=TextEditingController();bool busy=false;
 Future<void>signIn()async{setState(()=>busy=true);try{await Supabase.instance.client.auth.signInWithPassword(email:email.text.trim(),password:password.text);if(mounted)ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('Login सफल हुआ।')));}on AuthException catch(e){if(mounted)ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text(e.message)));}finally{if(mounted)setState(()=>busy=false);}}
 @override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:const Text('Agri Sathi Login')),body:Padding(padding:const EdgeInsets.all(20),child:Column(children:[
 TextField(controller:email,keyboardType:TextInputType.emailAddress,decoration:const InputDecoration(labelText:'Email')),
 TextField(controller:password,obscureText:true,decoration:const InputDecoration(labelText:'Password')),
 const SizedBox(height:20),FilledButton(onPressed:busy?null:signIn,child:Text(busy?'Please wait...':'Login'))]));
}
