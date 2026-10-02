import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
class AdminScreen extends StatefulWidget{const AdminScreen({super.key});@override State<AdminScreen> createState()=>_AdminScreenState();}
class _AdminScreenState extends State<AdminScreen>{
 final client=Supabase.instance.client;List<Map<String,dynamic>> products=[];bool loading=true;
 @override void initState(){super.initState();loadProducts();}
 Future<void>loadProducts()async{try{final data=await client.from('products').select().order('created_at',ascending:false);if(mounted)setState(()=>{products=List<Map<String,dynamic>>.from(data),loading=false});}catch(_){if(mounted)setState(()=>loading=false);}}
 Future<void>addProduct()async{
  final hi=TextEditingController(),en=TextEditingController(),brand=TextEditingController();
  final result=await showDialog<bool>(context:context,builder:(_)=>AlertDialog(title:const Text('नया Product'),content:Column(mainAxisSize:MainAxisSize.min,children:[
   TextField(controller:hi,decoration:const InputDecoration(labelText:'Hindi Name')),TextField(controller:en,decoration:const InputDecoration(labelText:'English Name')),TextField(controller:brand,decoration:const InputDecoration(labelText:'Brand'))]),
   actions:[TextButton(onPressed:()=>Navigator.pop(context,false),child:const Text('Cancel')),FilledButton(onPressed:()async{if(hi.text.trim().isEmpty||en.text.trim().isEmpty)return;await client.from('products').insert({'name_hi':hi.text.trim(),'name_en':en.text.trim(),'brand':brand.text.trim(),'active':true});if(context.mounted)Navigator.pop(context,true);},child:const Text('Add'))]));
  if(result==true)loadProducts();
 }
 @override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:const Text('Agri Sathi Admin')),floatingActionButton:FloatingActionButton.extended(onPressed:addProduct,icon:const Icon(Icons.add),label:const Text('Product')),
 body:loading?const Center(child:CircularProgressIndicator()):ListView.builder(padding:const EdgeInsets.all(12),itemCount:products.length,itemBuilder:(_,i)=>Card(child:ListTile(title:Text(products[i]['name_hi']??''),subtitle:Text('${products[i]['name_en']??''} • ${products[i]['brand']??''}'),trailing:const Icon(Icons.inventory_2_outlined))));
}
