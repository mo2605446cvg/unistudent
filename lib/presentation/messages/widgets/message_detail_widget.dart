import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MessageDetailWidget extends StatefulWidget {
  final Map<String, dynamic> message;
  final Function(int messageId, String? reaction) onReactionChanged;

  const MessageDetailWidget({
    super.key,
    required this.message,
    required this.onReactionChanged,
  });

  @override
  State<MessageDetailWidget> createState() => _MessageDetailWidgetState();
}

class _MessageDetailWidgetState extends State<MessageDetailWidget> {
  String? _userReaction;
  late Map<String, int> _reactions;

  @override
  void initState() {
    super.initState();
    _userReaction = widget.message['userReaction'];
    _reactions = Map<String, int>.from(widget.message['reactions'] ?? {});
  }

  String _formatTimestamp(DateTime timestamp) {
    return '${timestamp.day}/${timestamp.month}/${timestamp.year} - ${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
  }

  void _toggleReaction(String reactionType) {
    setState(() {
      if (_userReaction == reactionType) {
        // Remove reaction
        _reactions[reactionType] = (_reactions[reactionType] ?? 1) - 1;
        _userReaction = null;
      } else {
        // Add new reaction
        if (_userReaction != null) {
          // Remove previous reaction
          _reactions[_userReaction!] = (_reactions[_userReaction!] ?? 1) - 1;
        }
        _reactions[reactionType] = (_reactions[reactionType] ?? 0) + 1;
        _userReaction = reactionType;
      }
    });

    widget.onReactionChanged(widget.message['id'], _userReaction);
  }

  void _downloadAttachment(Map<String, dynamic> attachment) {
    // Simulate download
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('جاري تحميل ${attachment['name']}...'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _previewAttachment(Map<String, dynamic> attachment) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          constraints: BoxConstraints(
            maxHeight: 70.h,
            maxWidth: 90.w,
          ),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.primaryColor,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        attachment['name'] ?? '',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: CustomIconWidget(
                        iconName: 'close',
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(4.w),
                  child: attachment['type'] == 'image'
                      ? CustomImageWidget(
                          imageUrl: attachment['url'] ?? '',
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.contain,
                        )
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomIconWidget(
                                iconName: 'picture_as_pdf',
                                color: AppTheme.lightTheme.colorScheme.error,
                                size: 64,
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                attachment['name'] ?? '',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 1.h),
                              Text(
                                attachment['size'] ?? '',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
              ),

              // Actions
              Container(
                padding: EdgeInsets.all(4.w),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _downloadAttachment(attachment),
                        icon: CustomIconWidget(
                          iconName: 'download',
                          color: Colors.white,
                          size: 20,
                        ),
                        label: Text('تحميل'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List attachments = widget.message['attachments'] ?? [];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: AppTheme.lightTheme.primaryColor,
          foregroundColor: Colors.white,
          elevation: 2.0,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: CustomIconWidget(
              iconName: 'arrow_back',
              color: Colors.white,
              size: 24,
            ),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.message['senderName'] ?? '',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              Text(
                widget.message['senderRole'] ?? '',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              onPressed: () {
                // Share functionality
              },
              icon: CustomIconWidget(
                iconName: 'share',
                color: Colors.white,
                size: 24,
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Message header
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  border: Border(
                    bottom: BorderSide(
                      color: AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.message['subject'] ?? '',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      _formatTimestamp(widget.message['timestamp']),
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),

              // Message content
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(4.w),
                child: Text(
                  widget.message['fullContent'] ?? '',
                  style: TextStyle(
                    fontSize: 15.sp,
                    height: 1.6,
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                ),
              ),

              // Attachments
              if (attachments.isNotEmpty) ...[
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'المرفقات',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.lightTheme.colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      ...attachments.map<Widget>((attachment) {
                        return Container(
                          margin: EdgeInsets.only(bottom: 1.h),
                          padding: EdgeInsets.all(3.w),
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppTheme.lightTheme.colorScheme.outline
                                  .withValues(alpha: 0.2),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(2.w),
                                decoration: BoxDecoration(
                                  color: attachment['type'] == 'pdf'
                                      ? AppTheme.lightTheme.colorScheme.error
                                          .withValues(alpha: 0.1)
                                      : AppTheme.lightTheme.primaryColor
                                          .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: CustomIconWidget(
                                  iconName: attachment['type'] == 'pdf'
                                      ? 'picture_as_pdf'
                                      : 'image',
                                  color: attachment['type'] == 'pdf'
                                      ? AppTheme.lightTheme.colorScheme.error
                                      : AppTheme.lightTheme.primaryColor,
                                  size: 24,
                                ),
                              ),
                              SizedBox(width: 3.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      attachment['name'] ?? '',
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                        color: AppTheme
                                            .lightTheme.colorScheme.onSurface,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      attachment['size'] ?? '',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: AppTheme.lightTheme.colorScheme
                                            .onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () =>
                                        _previewAttachment(attachment),
                                    icon: CustomIconWidget(
                                      iconName: 'visibility',
                                      color: AppTheme.lightTheme.primaryColor,
                                      size: 20,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () =>
                                        _downloadAttachment(attachment),
                                    icon: CustomIconWidget(
                                      iconName: 'download',
                                      color: AppTheme.lightTheme.primaryColor,
                                      size: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                SizedBox(height: 2.h),
              ],

              // Reactions section
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  border: Border(
                    top: BorderSide(
                      color: AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'التفاعلات',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      children: [
                        // Like reaction
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _toggleReaction('like'),
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 1.5.h),
                              decoration: BoxDecoration(
                                color: _userReaction == 'like'
                                    ? AppTheme.lightTheme.primaryColor
                                        .withValues(alpha: 0.1)
                                    : AppTheme.lightTheme.colorScheme.surface,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: _userReaction == 'like'
                                      ? AppTheme.lightTheme.primaryColor
                                      : AppTheme.lightTheme.colorScheme.outline
                                          .withValues(alpha: 0.3),
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                children: [
                                  CustomIconWidget(
                                    iconName: 'thumb_up',
                                    color: _userReaction == 'like'
                                        ? AppTheme.lightTheme.primaryColor
                                        : AppTheme.lightTheme.colorScheme
                                            .onSurfaceVariant,
                                    size: 24,
                                  ),
                                  SizedBox(height: 0.5.h),
                                  Text(
                                    'إعجاب',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                      color: _userReaction == 'like'
                                          ? AppTheme.lightTheme.primaryColor
                                          : AppTheme.lightTheme.colorScheme
                                              .onSurfaceVariant,
                                    ),
                                  ),
                                  Text(
                                    '${_reactions['like'] ?? 0}',
                                    style: TextStyle(
                                      fontSize: 11.sp,
                                      color: AppTheme.lightTheme.colorScheme
                                          .onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 2.w),

                        // Important reaction
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _toggleReaction('important'),
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 1.5.h),
                              decoration: BoxDecoration(
                                color: _userReaction == 'important'
                                    ? AppTheme.lightTheme.colorScheme.tertiary
                                        .withValues(alpha: 0.1)
                                    : AppTheme.lightTheme.colorScheme.surface,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: _userReaction == 'important'
                                      ? AppTheme.lightTheme.colorScheme.tertiary
                                      : AppTheme.lightTheme.colorScheme.outline
                                          .withValues(alpha: 0.3),
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                children: [
                                  CustomIconWidget(
                                    iconName: 'star',
                                    color: _userReaction == 'important'
                                        ? AppTheme
                                            .lightTheme.colorScheme.tertiary
                                        : AppTheme.lightTheme.colorScheme
                                            .onSurfaceVariant,
                                    size: 24,
                                  ),
                                  SizedBox(height: 0.5.h),
                                  Text(
                                    'مهم',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                      color: _userReaction == 'important'
                                          ? AppTheme
                                              .lightTheme.colorScheme.tertiary
                                          : AppTheme.lightTheme.colorScheme
                                              .onSurfaceVariant,
                                    ),
                                  ),
                                  Text(
                                    '${_reactions['important'] ?? 0}',
                                    style: TextStyle(
                                      fontSize: 11.sp,
                                      color: AppTheme.lightTheme.colorScheme
                                          .onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 2.w),

                        // Acknowledge reaction
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _toggleReaction('acknowledge'),
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 1.5.h),
                              decoration: BoxDecoration(
                                color: _userReaction == 'acknowledge'
                                    ? AppTheme.lightTheme.colorScheme.tertiary
                                        .withValues(alpha: 0.1)
                                    : AppTheme.lightTheme.colorScheme.surface,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: _userReaction == 'acknowledge'
                                      ? AppTheme.lightTheme.colorScheme.tertiary
                                      : AppTheme.lightTheme.colorScheme.outline
                                          .withValues(alpha: 0.3),
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                children: [
                                  CustomIconWidget(
                                    iconName: 'check_circle',
                                    color: _userReaction == 'acknowledge'
                                        ? AppTheme
                                            .lightTheme.colorScheme.tertiary
                                        : AppTheme.lightTheme.colorScheme
                                            .onSurfaceVariant,
                                    size: 24,
                                  ),
                                  SizedBox(height: 0.5.h),
                                  Text(
                                    'تأكيد',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                      color: _userReaction == 'acknowledge'
                                          ? AppTheme
                                              .lightTheme.colorScheme.tertiary
                                          : AppTheme.lightTheme.colorScheme
                                              .onSurfaceVariant,
                                    ),
                                  ),
                                  Text(
                                    '${_reactions['acknowledge'] ?? 0}',
                                    style: TextStyle(
                                      fontSize: 11.sp,
                                      color: AppTheme.lightTheme.colorScheme
                                          .onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
    );
  }
}
