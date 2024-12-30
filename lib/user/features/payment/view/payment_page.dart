import 'package:flutter/material.dart';

class PaymentPage extends StatelessWidget {
  final int totalAmount;
  const PaymentPage({required this.totalAmount, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total Amount: \$ $totalAmount',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              TextFormField(
                decoration: InputDecoration(
                    hintText: 'Card Number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    suffixIcon: IconButton(
                      onPressed: () async {
                        // Navigator.push(context, MaterialPageRoute(builder: (builder) => CardScannerPage()));
                        // await CardScanner.scanCard().then((value) {
                        //   // Access the scanned card information
                        //   print(value!.cardNumber);
                        //   print(value.expiryDate);
                        //   print(value.cardHolderName);
                        // }).catchError((onError) {
                        //   print('==============$onError');
                        // });
                      },
                      icon: const Icon(Icons.document_scanner_outlined),
                    )),
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Card Holder Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                      child: TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Date',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  )),
                  const SizedBox(width: 10),
                  Expanded(
                      child: TextFormField(
                    decoration: InputDecoration(
                      hintText: 'CVV',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  )),
                ],
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.center,
                child: MaterialButton(
                  textColor: Colors.white,
                  color: Colors.blueAccent,
                  child: const Text('Pay'),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
