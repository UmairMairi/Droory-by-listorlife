import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/view_model/active_plan_v_m.dart';

class PlansListView extends BaseView<ActivePlanVM> {
  const PlansListView({super.key});

  @override
  Widget build(BuildContext context, ActivePlanVM viewModel) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sell Faster Now'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Feature Ad',
              style: context.textTheme.titleMedium,
            ),
            Gap(10),
            ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Card();
                },
                separatorBuilder: (context, index) {
                  return Gap(20);
                },
                itemCount: viewModel.plansList.length),
            Gap(20),
            Text(
              'Boost to Top',
              style: context.textTheme.titleMedium,
            ),
            Gap(10),
            ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Card();
                },
                separatorBuilder: (context, index) {
                  return Gap(20);
                },
                itemCount: viewModel.boosterList.length),
          ],
        ),
      ),
    );
  }
}
