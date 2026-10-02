import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'product_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  final client = Supabase.instance.client;
  List<Map<String,dynamic>> products = [], categories = [];
  bool loading = true; String search = '';
  @override void initState(){super.initState(); loadData();}
  Future<void> loadData() async {
    final c=await client.from('categories').select().eq('active',true).order('created_at');
    final p=await client.from('products').select().eq('active',true).order('created_at',ascending:false);
    if(mounted)setState(()=>{categories=List<Map<String,dynamic>>.from(c),products=List<Map<String,dynamic>>.from(p),loading=false});
  }
  @override Widget build(BuildContext context){
    final filtered=products.where((p){final q=search.trim().toLowerCase();return q.isEmpty||(p['name_hi']??'').toString().toLowerCase().contains(q)||(p['name_en']??'').toString().toLowerCase().contains(q)||(p['brand']??'').toString().toLowerCase().contains(q);}).toList();
    return Scaffold(appBar:AppBar(title:const Text('Agri Sathi',style:TextStyle(fontWeight:FontWeight.bold)),actions:[IconButton(onPressed:()=>Navigator.pushNamed(context,'/auth'),icon:const Icon(Icons.person_outline))]),
      body:RefreshIndicator(onRefresh:loadData,child:ListView(padding:const EdgeInsets.all(16),children:[
        TextField(onChanged:(v)=>setState(()=>search=v),decoration:InputDecoration(hintText:'बीज, खाद, कीटनाशक खोजें...',prefixIcon:const Icon(Icons.search),filled:true,fillColor:Colors.white,border:OutlineInputBorder(borderRadius:BorderRadius.circular(16),borderSide:BorderSide.none))),
        const SizedBox(height:18),const Text('श्रेणियाँ',style:TextStyle(fontSize:20,fontWeight:FontWeight.bold)),const SizedBox(height:10),
        SizedBox(height:90,child:loading?const Center(child:CircularProgressIndicator()):ListView.separated(scrollDirection:Axis.horizontal,itemCount:categories.length,separatorBuilder:(_,__)=>const SizedBox(width:10),itemBuilder:(_,i)=>Container(width:125,padding:const EdgeInsets.all(12),decoration:BoxDecoration(color:const Color(0xFFE8F5E9),borderRadius:BorderRadius.circular(16)),child:Center(child:Text(categories[i]['name_hi']??'',textAlign:TextAlign.center))))),
        const SizedBox(height:20),const Text('उत्पाद',style:TextStyle(fontSize:20,fontWeight:FontWeight.bold)),const SizedBox(height:10),
        if(loading)const Center(child:CircularProgressIndicator()),
        if(!loading&&filtered.isEmpty)const Padding(padding:EdgeInsets.all(30),child:Center(child:Text('अभी कोई उत्पाद उपलब्ध नहीं है।'))),
        ...filtered.map((p)=>Card(margin:const EdgeInsets.only(bottom:12),child:ListTile(
          leading:p['image_url']!=null?Image.network(p['image_url'],width:60,height:60,fit:BoxFit.cover):const CircleAvatar(child:Icon(Icons.eco)),
          title:Text(p['name_hi']??p['name_en']??''),subtitle:Text(p['brand']??''),trailing:const Icon(Icons.chevron_right),
          onTap:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>ProductDetailScreen(product:p))))),
      ]));
  }
}
