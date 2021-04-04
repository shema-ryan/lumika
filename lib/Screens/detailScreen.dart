import 'package:flutter/material.dart';
import '../Provider/provider.dart';
import 'package:provider/provider.dart';

class DetailsScreen extends StatefulWidget {
  static const String routeName = '/DetailsScreen.dart';

  const DetailsScreen();

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _media = MediaQuery.of(context).size.width;
    final Product _selectedProduct =
        ModalRoute.of(context)!.settings.arguments as Product;
    final _colorDet = Provider.of<AppTheme>(context).light ;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: const Color(0xffE8B44A),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Positioned(
              top: 0,
              child: Image.network(
                _selectedProduct.url,
                fit: BoxFit.cover,
                height: _media * 0.8931,
              )),
          Positioned(
            top: _media * 0.85241,
            child: Container(
              padding: const EdgeInsets.all(10.0),
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox( height: _media *0.05089,),
                 ListTile(
                   contentPadding: EdgeInsets.zero,
                   trailing:Text('\$${_selectedProduct.price}', style: _theme.textTheme.headline6!.copyWith(
                       fontWeight: FontWeight.bold
                   ),),
                   title: Text(_selectedProduct.name, style: _theme.textTheme.headline6!.copyWith(
                       fontWeight: FontWeight.bold
                   ),),
                   subtitle:Text('manufactured by : ${_selectedProduct.company}', style: _theme.textTheme.bodyText2
                 ),),
                  SizedBox( height: _media * 0.1526,),
                  Text('Description' , style: _theme.textTheme.headline6),
                  SizedBox(height: 5,),
                  Text(_selectedProduct.description),
                  Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: (){},
                      child: Text('Add to Cart' , style: _theme.textTheme.headline6,),
                    ),
                  ),
                ],
              ),
              decoration: BoxDecoration(
                color: _colorDet ? Colors.white: _theme.primaryColor,
                borderRadius: BorderRadius.only(
                  topRight:const Radius.circular(15),
                  topLeft:const  Radius.circular(15),
                )
              ),
              height: _media * 1.1,
              width: _media,
            ),
          ),
        ],
      ),
    );
  }
}
