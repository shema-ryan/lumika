import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:garage/Screens/cartScreen.dart';
import 'package:provider/provider.dart';
import '../Provider/provider.dart';
import '../Widgets/widget.dart';

class ProductScreen extends StatefulWidget {
  static const routeName = '/ProductScreen';

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final _auth = FirebaseAuth.instance.currentUser;
  String? shema;

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _media = MediaQuery.of(context).size.width;
    List<Product> _obtainedProduct = shema == null
        ? Provider.of<ProductList>(context).list
        : Provider.of<ProductList>(context).filter(shema!);
    final _badge = Provider.of<CartProvider>(context).cart.length;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: _theme.appBarTheme.backgroundColor,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipOval(
            child: FadeInImage(
                alignment: Alignment.center,
                placeholder: const AssetImage('assets/profice.png'),
                fit: BoxFit.cover,
                image: NetworkImage(_auth!.photoURL!)),
          ),
        ),
        title: Text(
          'lumika',
          style: _theme.textTheme.headline6,
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                  icon: Icon(
                    Icons.shopping_cart,
                    color: _theme.iconTheme.color,
                  ),
                  onPressed:_badge == 0 ? null: () {
                   Navigator.of(context).pushNamed(CartScreen.routeName);
                  }),
              Positioned(
                top: 5,
                right: 5,
                child:_badge== 0 ? Container() : Container(
                  height: 20,
                  width: 20,
                  padding:const  EdgeInsets.all(3.0),
                  child: FittedBox(child: Text( _badge.toString(), style: _theme.textTheme.headline6,)),
                  constraints:BoxConstraints(
                  ),
                  decoration: BoxDecoration(
                    color: Provider.of<AppTheme>(context).light ? _theme.primaryColor : Colors.blueAccent,
                    shape: BoxShape.circle,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              Text(
                ' Welcome ${_auth!.displayName}',
                style: _theme.textTheme.headline6,
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: _media * 0.127,
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      shema = value.toLowerCase();
                    });
                  },
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    hintStyle: _theme.textTheme.headline6!
                        .copyWith(color: Colors.black54),
                    hintText: 'search........',
                    prefixIcon: const Icon(Icons.search),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              _obtainedProduct.isNotEmpty
                  ? Container(
                      height: _media * 1.35,
                      child: GridView.builder(
                          itemCount: _obtainedProduct.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 2 / 3,
                            crossAxisSpacing: 2,
                            mainAxisSpacing: 2,
                          ),
                          itemBuilder: (context, index) => GridWidget(
                              obtainedProduct: _obtainedProduct[index],
                              theme: _theme)),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(50),
                      child: Text(
                        'no matching product found ......',
                        style: _theme.textTheme.bodyText2,
                        textAlign: TextAlign.center,
                      ),
                    ),
              const SizedBox(height: 20,),
            ],
          ),
        ),
      ),
    );
  }
}
