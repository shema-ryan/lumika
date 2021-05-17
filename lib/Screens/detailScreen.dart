import 'package:flutter/material.dart';
import '../Provider/provider.dart';
import 'package:provider/provider.dart';

class DetailsScreen extends StatelessWidget {
  static const routeName = '/DetailsScreen';
  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _media = MediaQuery.of(context).size.width;
    final Product _selectedProduct =
        ModalRoute.of(context)!.settings.arguments as Product;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          _selectedProduct.name.toUpperCase(),
          style: _theme.textTheme.headline6,
        ),
        iconTheme: IconThemeData(
          color: const Color(0xffE8B44A),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Hero(
            tag: _selectedProduct.id,
            child: ClipPath(
              clipper: ImageClipper(),
              child: Image.network(
                _selectedProduct.url,
                fit: BoxFit.cover,
                height: _media * 0.87241,
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    trailing: Text(
                      '\$${_selectedProduct.price}',
                      style: _theme.textTheme.headline6!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    title: Text(
                      _selectedProduct.name,
                      style: _theme.textTheme.headline6!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                        'manufactured by : ${_selectedProduct.company}',
                        style: _theme.textTheme.bodyText2),
                  ),
                  SizedBox(
                    height: _media * 0.05,
                  ),
                  Text('Description', style: _theme.textTheme.headline6),
                  SizedBox(
                    height: 5,
                  ),
                  Text(_selectedProduct.description),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Provider.of<CartProvider>(context, listen: false)
                            .addCart(product: _selectedProduct);
                      },
                      child: Text(
                        'Add to Cart',
                        style: _theme.textTheme.headline6,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }
}

class ImageClipper extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    Path path = Path()
      ..lineTo(0, size.height)
      ..arcToPoint(Offset(10, size.height - 10),radius: Radius.circular(10))
      ..lineTo(size.width - 10, size.height - 10)
      ..arcToPoint(Offset(size.width , size.height),radius: Radius.circular(9))
      ..lineTo(size.width, 0)..close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) => true;
}
/*
 */
/*
Stack(
        children: [
          Positioned(
              top: 0,
              child: Hero(
                tag:_selectedProduct.id,
                child: Image.network(
                  _selectedProduct.url,
                  fit: BoxFit.contain,
                  height: _media * 0.87241,
                ),
              )),
          Positioned(
            top: _media * 0.84241,
            child: Container(
              padding: const EdgeInsets.all(10.0),
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  SizedBox( height: _media * 0.05,),
                  Text('Description' , style: _theme.textTheme.headline6),
                  SizedBox(height: 5,),
                  Text(_selectedProduct.description),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: (){
                        Provider.of<CartProvider>(context , listen: false).addCart(product: _selectedProduct);
                      },
                      child: Text('Add to Cart' , style: _theme.textTheme.headline6,),
                    ),
                  ),
                ],
              ),
              decoration: BoxDecoration(
                  color: _colorDet ? Colors.white: const Color(0xff353839),
                  borderRadius: BorderRadius.only(
                    topRight:const Radius.circular(10),
                    topLeft:const  Radius.circular(10),
                  )
              ),
              height: _media * 0.9,
              width: _media,
            ),
          ),
        ],
      )
 */
