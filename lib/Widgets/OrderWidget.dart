import 'package:flutter/material.dart';
import '../Provider/orderProvider.dart';
import 'package:intl/intl.dart';

class OrderWidget extends StatelessWidget {
  final List<Order> _order;
  OrderWidget(this._order);
  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    return _order.isEmpty
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/404.png',
                fit: BoxFit.cover,
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text('No order Made yet !',
                    style: Theme.of(context).textTheme.headline6!),
              )
            ],
          )
        : ListView.builder(
            itemBuilder: (context, index) => Card(
              margin: const EdgeInsets.all(10.0),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('ID :\n${_order[index].id.toString()}'),
                        Text(
                            'OrderDate: \n${DateFormat().format(_order[index].placedOn)}'),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Payment Method:\n${_order[index].delivery}'),
                        const SizedBox(
                          height: 10,
                        ),
                        Text('OrderState: \n${_order[index].deliveryStatus}'),
                        const SizedBox(
                          height: 10,
                        ),
                        Text('Address :\n${_order[index].address}')
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    DataTable(
                        dividerThickness: 0.2,
                        showBottomBorder: true,
                        columns: ['Name', 'Quantity', 'Total']
                            .map((e) => DataColumn(
                                  label: Text(
                                    e,
                                    style: _theme.textTheme.headline6!.copyWith(
                                      color: _theme.primaryColor,
                                    ),
                                  ),
                                ))
                            .toList(),
                        rows: _order[index]
                            .product
                            .map((cart) => DataRow(cells: [
                                  DataCell(Text(cart.product.name)),
                                  DataCell(Text(cart.quantity.toString())),
                                  DataCell(FittedBox(
                                      child: Text(
                                          '\$ ${cart.quantity * cart.product.price}'))),
                                ]))
                            .toList()),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      Text(
                        'Amount Due : \$${_order[index].total}',
                        style: _theme.textTheme.headline6,
                      ),
                    ]),
                  ],
                ),
              ),
            ),
            itemCount: _order.length,
          );
  }
}
