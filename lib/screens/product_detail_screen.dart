import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductDetailScreen extends StatefulWidget {
  final Map<String,dynamic> product;
  const ProductDetailScreen({super.key,required this.product});
  @override State<ProductDetailScreen> createState()=>_ProductDetailScreenState();
}
class _ProductDetailScreenState extends State<ProductDetailScreen>{
  List<Map<String,dynamic>> variants=[]; String? selected; bool loading=true;
  @override void initState(){super.initState();loadVariants();}
  Future<void> loadVariants()async{
    final data=await Supabase.instance.client.from('product_variants').select().eq('product_id',widget.product['id']).eq('active',true).order('price');
    if(mounted)setState(()=>{variants=List<Map<String,dynamic>>.from(data),loading=false,selected:data.isNotEmpty?data.first['id'].toString():null});
  }
  @override Widget build(BuildContext context){
    Map<String,dynamic>? current;
    for(final v in variants){if(v['id'].toString()==selected){current=v;break;}}
    final p=widget.product;
    return Scaffold(appBar:AppBar(title:Text(p['name_hi']??p['name_en']??'Product')),body:ListView(padding:const EdgeInsets.all(16),children:[
      if(p['image_url']!=null)ClipRRect(borderRadius:BorderRadius.circular(20),child:Image.network(p['image_url'],height:240,fit:BoxFit.cover))
      else Container(height:240,decoration:BoxDecoration(color:Colors.green.shade50,borderRadius:BorderRadius.circular(20)),child:const Icon(Icons.eco,size:90)),
      const SizedBox(height:18),Text(p['name_hi']??'',style:const TextStyle(fontSize:24,fontWeight:FontWeight.bold)),Text(p['name_en']??'',style:TextStyle(color:Colors.grey)),
      const SizedBox(height:18),const Text('पैक साइज चुनें',style:TextStyle(fontSize:18,fontWeight:FontWeight.bold)),const SizedBox(height:8),
      if(loading)const CircularProgressIndicator(),
      Wrap(spacing:8,runSpacing:8,children:variants.map((v)=>ChoiceChip(label:Text('${v['pack_size']}  ₹${v['price']}'),selected:selected==v['id'].toString(),onSelected:(_)=>setState(()=>selected=v['id'].toString()))).toList()),
      const SizedBox(height:18),
      if(current!=null)Text((current['stock']??0)>0?'उपलब्ध • Stock: ${current['stock']}':'Out of Stock',style:TextStyle(fontWeight:FontWeight.bold,color:(current['stock']??0)>0?Colors.green:Colors.red)),
      const SizedBox(height:18),FilledButton.icon(onPressed:current!=null&&(current['stock']??0)>0?()=>ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('Cart integration अगले चरण में जोड़ी जाएगी।'))):null,icon:const Icon(Icons.shopping_cart),label:const Text('कार्ट में जोड़ें'))
    ]));
  }
}
