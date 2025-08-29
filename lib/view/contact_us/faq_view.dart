import 'package:flutter/material.dart';
import 'package:list_and_life/base/helpers/string_helper.dart';
import 'package:list_and_life/base/network/api_constants.dart';
import 'package:list_and_life/base/network/api_request.dart';
import 'package:list_and_life/base/network/base_client.dart';
import 'package:list_and_life/models/common/list_response.dart';
import 'package:list_and_life/skeletons/faq_skeleton.dart';
import 'package:list_and_life/widgets/app_error_widget.dart';

import '../../models/faq_model.dart';

class FaqView extends StatefulWidget {
  const FaqView({super.key});

  @override
  State<FaqView> createState() => _FaqViewState();
}

class _FaqViewState extends State<FaqView> {
  int selected = -1;

  Future<List<FaqModel>> getFaqList() async {
    ApiRequest apiRequest =
        ApiRequest(url: ApiConstants.getFaqUrl(), requestType: RequestType.get);

    var response = await BaseClient.handleRequest(apiRequest);

    ListResponse<FaqModel> model =
        ListResponse.fromJson(response, (json) => FaqModel.fromJson(json));
    return model.body ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(StringHelper.faqs),
        centerTitle: true,
      ),
      body: FutureBuilder<List<FaqModel>>(
          future: getFaqList(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<FaqModel> data = snapshot.data ?? [];
              return ListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                key: Key(selected.toString()), //attention
                itemCount: data.length,
                itemBuilder: (context, index) {
                  FaqModel item = data[index];
                  return Card(
                    child: ExpansionTile(
                        key: Key(index.toString()),
                        expandedAlignment: Alignment.topLeft,
                        initiallyExpanded: index == selected, //attention
                        shape: const Border(),
                        title: Text("${index + 1}. ${item.question}"),
                        onExpansionChanged: ((newState) {
                          if (newState) {
                            setState(() {
                              selected = index;
                            });
                          } else {
                            setState(() {
                              selected = -1;
                            });
                          }
                        }),
                        children: [
                          Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '${item.answer}',
                                textAlign: TextAlign.start,
                              ))
                        ]),
                  );
                },
              );
            }
            if (snapshot.hasError) {
              return const AppErrorWidget();
            }
            return FaqSkeleton(
                isLoading: snapshot.connectionState == ConnectionState.waiting);
          }),
    );
  }
}
