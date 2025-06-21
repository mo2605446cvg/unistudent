import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MessageCardWidget extends StatelessWidget {
  final Map<String, dynamic> message;
  final VoidCallback onTap;
  final VoidCallback onMarkRead;
  final VoidCallback onToggleImportant;
  final VoidCallback onArchive;

  const MessageCardWidget({
    super.key,
    required this.message,
    required this.onTap,
    required this.onMarkRead,
    required this.onToggleImportant,
    required this.onArchive,
  });

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return 'منذ ${difference.inMinutes} دقيقة';
    } else if (difference.inHours < 24) {
      return 'منذ ${difference.inHours} ساعة';
    } else if (difference.inDays < 7) {
      return 'منذ ${difference.inDays} يوم';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }

  void _showContextMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.symmetric(vertical: 2.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 2.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: message['isImportant'] ? 'star_border' : 'star',
                color: message['isImportant']
                    ? AppTheme.lightTheme.colorScheme.tertiary
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 24,
              ),
              title: Text(
                message['isImportant'] ? 'إلغاء التمييز كمهم' : 'تمييز كمهم',
                style: TextStyle(fontSize: 14.sp),
              ),
              onTap: () {
                Navigator.pop(context);
                onToggleImportant();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'share',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 24,
              ),
              title: Text(
                'مشاركة',
                style: TextStyle(fontSize: 14.sp),
              ),
              onTap: () {
                Navigator.pop(context);
                // Implement share functionality
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'report',
                color: AppTheme.lightTheme.colorScheme.error,
                size: 24,
              ),
              title: Text(
                'الإبلاغ عن مشكلة',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppTheme.lightTheme.colorScheme.error,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                // Implement report functionality
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isRead = message['isRead'] ?? false;
    final bool isImportant = message['isImportant'] ?? false;
    final bool hasAttachments = message['hasAttachments'] ?? false;
    final List attachments = message['attachments'] ?? [];

    return Dismissible(
      key: Key('message_${message['id']}'),
      background: Container(
        color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: CustomIconWidget(
          iconName: isRead ? 'mark_email_unread' : 'mark_email_read',
          color: AppTheme.lightTheme.primaryColor,
          size: 24,
        ),
      ),
      secondaryBackground: Container(
        color: AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.1),
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: CustomIconWidget(
          iconName: 'archive',
          color: AppTheme.lightTheme.colorScheme.error,
          size: 24,
        ),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          onMarkRead();
          return false;
        } else if (direction == DismissDirection.endToStart) {
          return await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('أرشفة الرسالة'),
                  content: Text('هل تريد أرشفة هذه الرسالة؟'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text('إلغاء'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: Text('أرشفة'),
                    ),
                  ],
                ),
              ) ??
              false;
        }
        return false;
      },
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          onArchive();
        }
      },
      child: GestureDetector(
        onTap: onTap,
        onLongPress: () => _showContextMenu(context),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isRead
                  ? AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.2)
                  : AppTheme.lightTheme.primaryColor.withValues(alpha: 0.3),
              width: isRead ? 1 : 2,
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.lightTheme.colorScheme.shadow
                    .withValues(alpha: 0.1),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with sender info and timestamp
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            message['senderName'] ?? '',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.lightTheme.colorScheme.onSurface,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            message['senderRole'] ?? '',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          _formatTimestamp(message['timestamp']),
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (isImportant)
                              CustomIconWidget(
                                iconName: 'star',
                                color: AppTheme.lightTheme.colorScheme.tertiary,
                                size: 16,
                              ),
                            if (isImportant && !isRead) SizedBox(width: 1.w),
                            if (!isRead)
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: AppTheme.lightTheme.primaryColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 1.5.h),

                // Subject
                Text(
                  message['subject'] ?? '',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 1.h),

                // Preview text
                Text(
                  message['previewText'] ?? '',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),

                // Attachments and reactions
                if (hasAttachments || (message['reactions'] != null)) ...[
                  SizedBox(height: 1.5.h),
                  Row(
                    children: [
                      // Attachments
                      if (hasAttachments) ...[
                        Row(
                          children:
                              attachments.take(2).map<Widget>((attachment) {
                            final String type = attachment['type'] ?? '';
                            return Container(
                              margin: EdgeInsets.only(left: 1.w),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 2.w, vertical: 0.5.h),
                              decoration: BoxDecoration(
                                color: AppTheme.lightTheme.colorScheme.primary
                                    .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomIconWidget(
                                    iconName: type == 'pdf'
                                        ? 'picture_as_pdf'
                                        : 'image',
                                    color: AppTheme.lightTheme.primaryColor,
                                    size: 16,
                                  ),
                                  SizedBox(width: 1.w),
                                  Text(
                                    type.toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w500,
                                      color: AppTheme.lightTheme.primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                        if (attachments.length > 2) ...[
                          SizedBox(width: 1.w),
                          Text(
                            '+${attachments.length - 2}',
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ],

                      Spacer(),

                      // Reactions summary
                      if (message['reactions'] != null) ...[
                        Row(
                          children: [
                            if ((message['reactions']['like'] ?? 0) > 0) ...[
                              CustomIconWidget(
                                iconName: 'thumb_up',
                                color: message['userReaction'] == 'like'
                                    ? AppTheme.lightTheme.primaryColor
                                    : AppTheme.lightTheme.colorScheme
                                        .onSurfaceVariant,
                                size: 16,
                              ),
                              SizedBox(width: 0.5.w),
                              Text(
                                '${message['reactions']['like']}',
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                              SizedBox(width: 2.w),
                            ],
                            if ((message['reactions']['acknowledge'] ?? 0) >
                                0) ...[
                              CustomIconWidget(
                                iconName: 'check_circle',
                                color: message['userReaction'] == 'acknowledge'
                                    ? AppTheme.lightTheme.colorScheme.tertiary
                                    : AppTheme.lightTheme.colorScheme
                                        .onSurfaceVariant,
                                size: 16,
                              ),
                              SizedBox(width: 0.5.w),
                              Text(
                                '${message['reactions']['acknowledge']}',
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
