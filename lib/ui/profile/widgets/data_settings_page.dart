import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:synamyk/generated/l10n.dart';
import 'package:synamyk/ui/core/ui/resources/app_strings.dart';
import 'package:synamyk/ui/core/ui/themes/app_text_styles.dart';
import 'package:synamyk/ui/profile/widgets/change_password_modal.dart';
import 'package:synamyk/ui/profile/widgets/change_phone_modal.dart';
import 'package:synamyk/ui/profile/widgets/change_region_modal.dart';

class DataSettingsPage extends StatelessWidget {
  const DataSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.white,
                leading: BackButton(
                  color: Colors.black,
                  onPressed: () {
                    context.pop();
                  },
                ),
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text(
                    l10n.settingsData,
                    style: AppTextStyles.appBarTitle,
                  ),
                ),
              ),

              SliverList(
                delegate: SliverChildListDelegate([
                  Divider(),
                  GestureDetector(
                    onTap: () {
                      ChangePhoneModal.show(context);
                    },
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        l10n.changePhone,
                        style: AppTextStyles.settingsItem,
                      ),
                      trailing: Icon(Icons.settings, color: Colors.black),
                    ),
                  ),
                  Divider(),
                  GestureDetector(
                    onTap: () {
                      ChangePasswordModal.show(context);
                    },
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        l10n.changePassword,
                        style: AppTextStyles.settingsItem,
                      ),
                      trailing: Icon(Icons.settings, color: Colors.black),
                    ),
                  ),
                  Divider(),
                  GestureDetector(
                    onTap: () {
                      ChangeRegionModal.show(context, null);
                    },
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        l10n.changeRegion,
                        style: AppTextStyles.settingsItem,
                      ),
                      trailing: Icon(Icons.settings, color: Colors.black),
                    ),
                  ),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
