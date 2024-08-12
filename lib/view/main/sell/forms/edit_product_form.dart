import 'dart:developer';

import 'package:flutter/material.dart';

import '../../../../base/helpers/string_helper.dart';
import '../../../../models/prodect_detail_model.dart';

class EditProductForm extends StatefulWidget {
  final ProductDetailModel? product;
  const EditProductForm({super.key, required this.product});

  @override
  State<EditProductForm> createState() => _EditProductFormState();
}

class _EditProductFormState extends State<EditProductForm> {
  @override
  void initState() {
    // TODO: implement initState
    log("${widget.product?.toJson()}");
    super.initState();
  }

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
