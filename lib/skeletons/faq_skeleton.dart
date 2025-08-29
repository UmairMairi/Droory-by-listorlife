import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class FaqSkeleton extends StatelessWidget {
  final bool isLoading;
  const FaqSkeleton({super.key, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    int selected = -1;
    return Skeletonizer(
      enabled: isLoading,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        key: Key('builder ${selected.toString()}'), //attention
        itemCount: 10,
        itemBuilder: (context, index) {
          return Card(
            child: ExpansionTile(
                key: Key(index.toString()), //attention
                initiallyExpanded: index == selected, //attention
                shape: const Border(),
                title: Text("$index. This is faq question?"),
                onExpansionChanged: ((newState) {}),
                children: const [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                        "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here'"),
                  )
                ]),
          );
        },
      ),
    );
  }
}
