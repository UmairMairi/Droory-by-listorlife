import 'package:flutter/material.dart';
import 'package:list_and_life/base/html_text.dart';
import 'package:list_and_life/widgets/app_error_widget.dart';
import 'package:list_and_life/widgets/app_loading_widget.dart';

import '../../../models/cms_model.dart';
import '../../../models/common/map_response.dart';
import '../../../network/api_constants.dart';
import '../../../network/api_request.dart';
import '../../../network/base_client.dart';

class TermsOfUseView extends StatefulWidget {
  final int? type;
  const TermsOfUseView({super.key, this.type = 1});

  @override
  State<TermsOfUseView> createState() => _TermsOfUseViewState();
}

class _TermsOfUseViewState extends State<TermsOfUseView> {
  Future<CmsModel?> getCms({int? type}) async {
    ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.getCmsUrl(id: '$type'), requestType: RequestType.get);
    var response = await BaseClient.handleRequest(apiRequest);
    MapResponse<CmsModel> model =
        MapResponse.fromJson(response, (json) => CmsModel.fromJson(json));
    return model.body;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:
              Text(widget.type == 1 ? 'Privacy Policy' : 'Terms & Conditions'),
        ),
        body: FutureBuilder<CmsModel?>(
            future: getCms(type: widget.type),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: HtmlText(html: snapshot.data?.description ?? ''));
              }
              if (snapshot.hasError) {
                return const AppErrorWidget();
              }
              return const AppLoadingWidget();
            }));
  }
}
