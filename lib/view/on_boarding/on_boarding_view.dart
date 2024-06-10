import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/routes/app_routes.dart';
import 'package:list_and_life/view_model/on_boarding_vm.dart';
import 'package:list_and_life/widgets/app_elevated_button.dart';

import '../../helpers/db_helper.dart';

class OnBoardingView extends BaseView<OnBoardingVM> {
  const OnBoardingView({super.key});

  @override
  Widget build(BuildContext context, OnBoardingVM viewModel) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              Expanded(
                  child: PageView.builder(
                      controller: viewModel.pageViewController,
                      itemCount: viewModel.itemsList.length,
                      onPageChanged: (index) {
                        viewModel.currentIndexPage = index;
                      },
                      itemBuilder: (context, index) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flexible(
                                child: Image.asset(
                                    viewModel.itemsList[index].image)),
                            const Gap(50),
                            Text(
                              viewModel.itemsList[index].title,
                              style: context.textTheme.titleLarge,
                              textAlign: TextAlign.center,
                            ),
                            const Gap(15),
                            Text(
                              viewModel.itemsList[index].description,
                              style: context.textTheme.bodyMedium,
                              textAlign: TextAlign.center,
                            )
                          ],
                        );
                      })),
              const Gap(20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DotsIndicator(
                    dotsCount: 3,
                    onTap: (index) {
                      viewModel.currentIndexPage = index;
                    },
                    position: viewModel.currentIndexPage,
                    decorator: DotsDecorator(
                      size: const Size.square(9.0),
                      activeSize: const Size(25.0, 9.0),
                      activeShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                    ),
                  ),
                  AppElevatedButton(
                    onTap: () {
                      if (viewModel.currentIndexPage < 2) {
                        viewModel.currentIndexPage++;
                        viewModel.pageViewController.animateToPage(
                          viewModel
                              .currentIndexPage, // Index of the page to navigate to
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.ease,
                        );
                      } else {
                        DbHelper.saveIsGuest(true);
                        context.go(Routes.main);
                        // context.go(Routes.login);
                      }
                    },
                    title: viewModel.currentIndexPage != 2
                        ? "Next"
                        : "Get Started",
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
