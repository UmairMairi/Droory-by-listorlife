import 'package:flutter/material.dart';
import 'package:list_and_life/base/base.dart';

import '../../../view_model/sell_v_m.dart';

class SellView extends BaseView<SellVM> {
  const SellView({super.key});

  @override
  Widget build(BuildContext context, SellVM viewModel) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sell'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        child: Column(
          children: [
            Text(
              "What are you offering?",
              style: context.textTheme.titleLarge,
            ),
            const SizedBox(
              height: 20,
            ),
            GridView.builder(
                shrinkWrap: true,
                itemCount: viewModel.data.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15.0,
                    mainAxisSpacing: 15.0,
                    mainAxisExtent: 130),
                itemBuilder: (buildContext, index) {
                  return GestureDetector(
                    onTap: () {
                      viewModel.handelSellCat(index: index);
                    },
                    child: Card(
                      color: Color(0xffFCFCFD),
                      elevation: 0.3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            viewModel.data[index].image,
                            height: 38,
                            width: 46,
                          ),
                          SizedBox(
                            height: 13,
                          ),
                          Text(
                            viewModel.data[index].title,
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }
}
