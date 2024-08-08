import 'package:flutter/material.dart';

import '../../../../base/helpers/string_helper.dart';
import '../../../../models/prodect_detail_model.dart';

class EditProductForm extends StatelessWidget {
  final ProductDetailModel? product;
  const EditProductForm({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(StringHelper.editProduct),
      ),
      body: const SizedBox(),
    );
  }
}
