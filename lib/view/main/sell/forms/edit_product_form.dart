import 'package:flutter/material.dart';

import '../../../../models/prodect_detail_model.dart';

class EditProductForm extends StatelessWidget {
  final ProductDetailModel? product;
  const EditProductForm({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Product"),
      ),
      body: const SizedBox(),
    );
  }
}
