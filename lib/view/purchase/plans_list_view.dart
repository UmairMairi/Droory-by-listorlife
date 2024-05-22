import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/routes/app_routes.dart';
import 'package:list_and_life/view_model/active_plan_v_m.dart';
import 'package:list_and_life/widgets/app_elevated_button.dart';

class PlansListView extends BaseView<ActivePlanVM> {
  const PlansListView({super.key});

  @override
  Widget build(BuildContext context, ActivePlanVM viewModel) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sell Faster Now'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Feature Ad',
              style: context.textTheme.titleMedium,
            ),
            ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                viewModel.plansList[index].title ?? '',
                                style: context.textTheme.titleLarge,
                              ),
                              Text(viewModel.plansList[index].subTitle ?? ''),
                            ],
                          ),
                          const Gap(10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                viewModel.plansList[index].description ?? '',
                                style: context.textTheme.labelMedium,
                              ),
                              InkWell(
                                onTap: () {
                                  viewModel.activateFeaturePlan(index);
                                },
                                child: viewModel.selectedFeaturePlan == index
                                    ? const Icon(Icons.check_circle)
                                    : const Icon(
                                        Icons.circle,
                                        color: Colors.grey,
                                      ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return const Gap(20);
                },
                itemCount: viewModel.plansList.length),
            Text(
              'Boost to Top',
              style: context.textTheme.titleMedium,
            ),
            ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                viewModel.boosterList[index].title ?? '',
                                style: context.textTheme.titleLarge,
                              ),
                              Text(viewModel.boosterList[index].subTitle ?? ''),
                            ],
                          ),
                          const Gap(10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                viewModel.boosterList[index].description ?? '',
                                style: context.textTheme.labelMedium,
                              ),
                              InkWell(
                                onTap: () {
                                  viewModel.activateBoosterPlan(index);
                                },
                                child: viewModel.selectedBoosterPlan == index
                                    ? const Icon(Icons.check_circle)
                                    : const Icon(
                                        Icons.circle,
                                        color: Colors.grey,
                                      ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return const Gap(20);
                },
                itemCount: viewModel.boosterList.length),
            AppElevatedButton(
              width: context.width,
              onTap: () {
                context.go(Routes.main);
              },
              title: 'Buy Now',
            ),
            const Gap(20),
          ],
        ),
      ),
    );
  }
}
