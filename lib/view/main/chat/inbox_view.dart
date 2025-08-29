import 'dart:developer'; // Added for log()
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/base/helpers/db_helper.dart';
import 'package:list_and_life/base/helpers/string_helper.dart';
import 'package:list_and_life/base/network/api_constants.dart';
import 'package:list_and_life/models/inbox_model.dart';
import 'package:list_and_life/res/font_res.dart';
import 'package:list_and_life/routes/app_routes.dart';
import 'package:list_and_life/skeletons/inbox_skeleton.dart';
import 'package:list_and_life/view_model/chat_vm.dart';
import 'package:list_and_life/widgets/app_empty_widget.dart';
import 'package:list_and_life/widgets/app_error_widget.dart';
import 'package:list_and_life/widgets/app_text_field.dart';
import 'package:list_and_life/widgets/image_view.dart';
import 'package:provider/provider.dart';
import '../../../res/assets_res.dart';

class InboxView extends StatefulWidget {
  const InboxView({super.key});

  @override
  State<InboxView> createState() => _InboxViewState();
}

class _InboxViewState extends State<InboxView> {
  late ChatVM viewModel;
  bool isSelectionMode = false;
  Set<int> selectedIndices = {};

  @override
  void initState() {
    super.initState();
    viewModel = Provider.of<ChatVM>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((d) {
      viewModel.initListeners();
      viewModel.getInboxList();
    });
  }

  void _toggleSelectionMode() {
    setState(() {
      isSelectionMode = !isSelectionMode;
      if (!isSelectionMode) {
        selectedIndices.clear();
      }
    });
  }

  void _toggleSelection(int index) {
    setState(() {
      if (selectedIndices.contains(index)) {
        selectedIndices.remove(index);
      } else {
        selectedIndices.add(index);
      }
    });
  }

  void _selectAll() {
    setState(() {
      if (selectedIndices.length == viewModel.filteredInboxList.length) {
        selectedIndices.clear();
      } else {
        selectedIndices = Set<int>.from(
          List.generate(viewModel.filteredInboxList.length, (index) => index),
        );
      }
    });
  }

  void _deleteSelected() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(StringHelper.deleteSelectedChats),
        content: Text(
            '${StringHelper.deleteChat} ${selectedIndices.length} ${StringHelper.deleteChatsConfirm}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(StringHelper.cancel),
          ),
          TextButton(
            onPressed: () {
              // Get the selected chats
              List<InboxModel> chatsToDelete = selectedIndices
                  .map((i) => viewModel.filteredInboxList[i])
                  .toList();

              Navigator.pop(context); // Close dialog first

              // Delete them
              viewModel.deleteChats(chatsToDelete);

              // Exit selection mode
              _toggleSelectionMode();

              // Simple success message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      '${chatsToDelete.length} ${StringHelper.chatsDeletedSuccessfully}'),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: Text(StringHelper.deleteChat,
                style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _markAsRead() {
    // Get the selected chats
    List<InboxModel> chatsToMark =
        selectedIndices.map((i) => viewModel.filteredInboxList[i]).toList();

    // Mark them as read
    viewModel.markChatsAsRead(chatsToMark);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
              '${StringHelper.markedAsRead} ${selectedIndices.length} ${StringHelper.markedAsRead}')),
    );
    _toggleSelectionMode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          isSelectionMode
              ? '${selectedIndices.length} ${StringHelper.selectedChats}'
              : StringHelper.myChats,
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: !isSelectionMode,
        leading: isSelectionMode
            ? IconButton(
                icon: Icon(Icons.close, color: Colors.black),
                onPressed: _toggleSelectionMode,
              )
            : null,
        actions: [
          if (isSelectionMode) ...[
            IconButton(
              icon: Icon(
                selectedIndices.length == viewModel.filteredInboxList.length
                    ? Icons.check_box
                    : Icons.check_box_outline_blank,
                color: Colors.black,
              ),
              onPressed: _selectAll,
              tooltip: StringHelper.selectAll,
            ),
            IconButton(
              icon: Icon(Icons.mark_email_read, color: Colors.black),
              onPressed: selectedIndices.isNotEmpty ? _markAsRead : null,
              tooltip: StringHelper.markAsRead,
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: selectedIndices.isNotEmpty ? _deleteSelected : null,
              tooltip: StringHelper.deleteChat,
            ),
          ] else ...[
            IconButton(
              icon: Icon(Icons.checklist, color: Colors.black),
              onPressed: _toggleSelectionMode,
              tooltip: StringHelper.selectChats,
            ),
          ],
        ],
      ),
      body: StreamBuilder<List<InboxModel>>(
          stream: viewModel.inboxStreamController.stream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              // Apply search filter if needed
              viewModel.filteredInboxList =
                  viewModel.inboxSearchTextController.text.isEmpty
                      ? viewModel.inboxList
                      : viewModel.filteredInboxList;

              return viewModel.filteredInboxList.isEmpty
                  ? AppEmptyWidget(
                      text: StringHelper.noChats,
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemBuilder: (context, index) {
                        InboxModel data = viewModel.filteredInboxList[index];
                        bool isSelected = selectedIndices.contains(index);

                        if (data.productDetail != null) {
                          log("[InboxView DEBUG]   Raw CategoryId: ${data.productDetail?.categoryId}, Type: ${data.productDetail?.categoryId.runtimeType}",
                              name: "InboxView");
                        } else {
                          log("[InboxView DEBUG]   ProductDetail is NULL for ProductId: ${data.productId}",
                              name: "InboxView");
                        }

                        String placeholderPath =
                            viewModel.getPlaceholderForChat(data);
                        log("[InboxView DEBUG]   Attempting to use placeholder: $placeholderPath for ProductId: ${data.productId}",
                            name: "InboxView");

                        SenderDetail? sender = data.senderDetail;
                        SenderDetail? receiver = data.receiverDetail;
                        var userImage =
                            data.senderId == DbHelper.getUserModel()?.id
                                ? receiver?.profilePic ?? ''
                                : sender?.profilePic ?? '';

                        return InkWell(
                          onTap: () {
                            if (isSelectionMode) {
                              _toggleSelection(index);
                            } else {
                              context
                                  .push(Routes.message,
                                      extra: viewModel.filteredInboxList[index])
                                  .then((value) {
                                viewModel.updateChatScreenId(roomId: null);
                              });
                            }
                          },
                          onLongPress: () {
                            if (!isSelectionMode) {
                              _toggleSelectionMode();
                              _toggleSelection(index);
                            }
                          },
                          child: Container(
                            color: isSelected
                                ? Colors.blue.withOpacity(0.1)
                                : null,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                if (isSelectionMode) ...[
                                  Checkbox(
                                    value: isSelected,
                                    onChanged: (value) =>
                                        _toggleSelection(index),
                                    activeColor: Colors.blue,
                                  ),
                                  const Gap(8),
                                ],
                                // Product Image with User Avatar Overlay
                                Stack(
                                  alignment: Alignment.bottomRight,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: ImageView.rect(
                                        height: 56,
                                        width: 56,
                                        placeholder: placeholderPath,
                                        image:
                                            "${ApiConstants.imageUrl}/${data.productDetail?.image}",
                                      ),
                                    ),
                                    Positioned(
                                      right: -2,
                                      bottom: -2,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 2,
                                          ),
                                        ),
                                        child: ImageView.circle(
                                          height: 24,
                                          width: 24,
                                          placeholder: AssetsRes.IC_USER_ICON,
                                          image: getImageUrl(url: userImage),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const Gap(12),
                                // Message Content
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Name and Time Row
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              data.senderId ==
                                                      DbHelper.getUserModel()
                                                          ?.id
                                                  ? "${receiver?.name} ${receiver?.lastName}"
                                                  : "${sender?.name} ${sender?.lastName}",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black87,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          const Gap(8),
                                          Text(
                                            viewModel.getCreatedAt(
                                                time: data.updatedAt),
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey[600],
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Gap(4),
                                      // Product Name
                                      Text(
                                        data.productDetail?.name ?? '',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[700],
                                          fontWeight: FontWeight.w500,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const Gap(4),
                                      // Last Message and Badge Row
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              "${viewModel.getLastMessage(message: data.lastMessageDetail)}",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.start,
                                              textDirection:
                                                  null, // Let Flutter auto-detect
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: data.unread_count != 0
                                                    ? Colors.black87
                                                    : Colors.grey[600],
                                                fontWeight:
                                                    data.unread_count != 0
                                                        ? FontWeight.w500
                                                        : FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                          if (data.unread_count != 0) ...[
                                            const Gap(8),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 7,
                                                      vertical: 3),
                                              decoration: BoxDecoration(
                                                color: Colors.black87,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Text(
                                                "${(data.unread_count ?? 0) > 99 ? '99+' : data.unread_count}",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Divider(
                            height: 1,
                            thickness: 1,
                            color: Colors.grey[300],
                          ),
                        );
                      },
                      itemCount: viewModel.filteredInboxList.length);
            }
            if (snapshot.hasError) {
              log("[InboxView ERROR] Stream snapshot error: ${snapshot.error}",
                  name: "InboxView");
              return const AppErrorWidget();
            }

            return InboxSkeleton(
              isLoading: snapshot.connectionState == ConnectionState.waiting,
            );
          }),
    );
  }

  String getImageUrl({required String url}) {
    if (url.contains('http')) {
      return url;
    }
    if (!url.contains('http')) {
      return "${ApiConstants.imageUrl}/$url";
    }
    return AssetsRes.IC_USER_ICON;
  }
}
