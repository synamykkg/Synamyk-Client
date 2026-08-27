import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:synamyk/data/repositories/notifications/notifications_repository.dart';
import 'package:synamyk/domain/models/notifications/notification_settings.dart';
import 'package:synamyk/ui/core/ui/themes/app_text_styles.dart';

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  State<NotificationSettingsPage> createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  late Future<NotificationSettings> _future;
  NotificationSettings? _settings;

  @override
  void initState() {
    super.initState();
    _future = GetIt.I<NotificationsRepository>().getSettings();
    _future.then((value) {
      if (mounted) setState(() => _settings = value);
    });
  }

  Future<void> _update({bool? results, bool? reminders, bool? marketing}) async {
    final previous = _settings;
    if (previous == null) return;

    setState(() {
      _settings = NotificationSettings(
        results: results ?? previous.results,
        reminders: reminders ?? previous.reminders,
        marketing: marketing ?? previous.marketing,
      );
    });

    try {
      final updated = await GetIt.I<NotificationsRepository>().updateSettings(
        results: results,
        reminders: reminders,
        marketing: marketing,
      );
      if (mounted) setState(() => _settings = updated);
    } catch (_) {
      if (mounted) setState(() => _settings = previous);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: BackButton(
            color: Colors.black,
            onPressed: () => context.pop(),
          ),
          title: Text(
            'Настройки уведомлений',
            style: AppTextStyles.appBarTitle,
          ),
          centerTitle: true,
        ),
        body: FutureBuilder<NotificationSettings>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done &&
                _settings == null) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError && _settings == null) {
              return Center(
                child: Text(
                  'Не удалось загрузить настройки',
                  style: AppTextStyles.bodyMedium,
                ),
              );
            }

            final settings = _settings!;
            return ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                SwitchListTile(
                  title: const Text('Результаты и разбор ИИ'),
                  subtitle: const Text(
                    'Результаты сессий и готовность ИИ-разбора',
                  ),
                  value: settings.results,
                  onChanged: (value) => _update(results: value),
                ),
                SwitchListTile(
                  title: const Text('Напоминания'),
                  subtitle: const Text('Напоминания о занятиях'),
                  value: settings.reminders,
                  onChanged: (value) => _update(reminders: value),
                ),
                SwitchListTile(
                  title: const Text('Рассылки'),
                  subtitle: const Text('Рассылки и новый контент'),
                  value: settings.marketing,
                  onChanged: (value) => _update(marketing: value),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
