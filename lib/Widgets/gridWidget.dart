import 'package:flutter/material.dart';
import 'package:garage/Screens/detailScreen.dart';
import '../Provider/provider.dart';
import 'package:provider/provider.dart';
class GridWidget extends StatelessWidget {
  const GridWidget({
    Key? key,
    required Product obtainedProduct,
    required ThemeData theme,
  })   : _obtainedProduct = obtainedProduct,
        _theme = theme,
        super(key: key);

  final Product _obtainedProduct;
  final ThemeData _theme;

  @override
  Widget build(BuildContext context) {
    final _scaffold = ScaffoldMessenger.of(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        Navigator.of(context).pushNamed(DetailsScreen.routeName, arguments: _obtainedProduct);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: GridTile(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              children: [
                Expanded(
                  child: Hero(
                    tag: _obtainedProduct.id,
                    child: FadeInImage(
                      placeholder:const AssetImage('assets/96x96.gif'),
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        _obtainedProduct.url,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          footer:GridTileBar(
            backgroundColor: Colors.grey.withOpacity(0.5),
            trailing: IconButton(
                icon: Icon(
                  Icons.shopping_cart,
                  color: _theme.iconTheme.color,
                ),
                onPressed: () {
                  _scaffold.removeCurrentSnackBar(reason: SnackBarClosedReason.timeout);
                  Provider.of<CartProvider>(context , listen: false).addCart(product: _obtainedProduct);
                  _scaffold.showSnackBar(SnackBar(
                    content: const Text('an item has been added to cart'),
                    action: SnackBarAction(
                      label: 'UNDO',
                      onPressed: (){
                        Provider.of<CartProvider>(context , listen: false).removeCartItem(_obtainedProduct);
                      },
                    ),
                  ));
                }),
            title: Text(
              _obtainedProduct.name.toUpperCase(),
              style: _theme.textTheme.bodyText2,
            ),
          ) ,

        ),
      ),
    );
  }
}


