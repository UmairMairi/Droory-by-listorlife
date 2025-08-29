import 'package:flutter/material.dart';
import 'package:list_and_life/base/base.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SubCategoryLoadingWidget extends StatelessWidget {
  final bool isLoading;
  const SubCategoryLoadingWidget({super.key, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: isLoading,
      child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(
                'Alok Dubey',
                style: context.textTheme.titleSmall,
              ),
            );
          },
          separatorBuilder: (context, index) {
            return const Divider();
          },
          itemCount: 10),
    );
  }
}
