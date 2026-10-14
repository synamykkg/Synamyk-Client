import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:synamyk/data/repositories/catalog/catalog_repository.dart';
import 'package:synamyk/domain/models/catalog/catalog_models.dart';
import 'package:synamyk/ui/core/ui/themes/app_colors.dart';
import 'package:synamyk/ui/core/ui/themes/app_text_styles.dart';
import 'package:synamyk/ui/core/ui/tr.dart';
import 'package:synamyk/ui/core/ui/widgets/sy_components.dart';
import 'package:synamyk/widgets/math_text.dart';

class TextDetailPage extends StatefulWidget {
  const TextDetailPage({super.key, required this.textId});

  final int textId;

  @override
  State<TextDetailPage> createState() => _TextDetailPageState();
}

class _TextDetailPageState extends State<TextDetailPage> {
  ReadingTextDetail? _text;
  Object? _error;
  bool _openingPdf = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _error = null);
    try {
      final text = await GetIt.I<CatalogRepository>().getText(widget.textId);
      if (mounted) setState(() => _text = text);
    } catch (e) {
      if (mounted) setState(() => _error = e);
    }
  }

  /// The presigned link expires in an hour, so always fetch a fresh one
  /// right before opening instead of reusing the one from page load.
  Future<void> _openPdf() async {
    setState(() => _openingPdf = true);
    try {
      final fresh = await GetIt.I<CatalogRepository>().getText(widget.textId);
      final url = fresh.pdfUrl;
      if (url == null) return;
      final ok = await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      );
      if (!ok && mounted) {
        showSySnack(
          context,
          context.tr('Не удалось открыть PDF', 'PDF ачылган жок'),
          error: true,
        );
      }
    } catch (e) {
      if (mounted) showSySnack(context, errorMessage(context, e), error: true);
    } finally {
      if (mounted) setState(() => _openingPdf = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final text = _text;
    final hasPdf = text?.pdfUrl != null;
    return Scaffold(
      appBar: SyAppBar(title: text?.title ?? ''),
      body: SyCanvas(
        child: text == null
            ? (_error != null
                  ? SyStateView.error(error: _error, onRetry: _load)
                  : const SyStateView.loading())
            : ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                children: [
                  if (text.content?.trim().isNotEmpty == true)
                    SyCard(
                      padding: const EdgeInsets.all(18),
                      child: MathText(
                        text.content!,
                        textAlign: TextAlign.justify,
                        style: AppTextStyles.bodyLarge.copyWith(
                          height: 1.6,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    )
                  else if (hasPdf)
                    SyCard(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          const SyIconTile(
                            icon: Icons.picture_as_pdf_rounded,
                            size: 64,
                            color: AppColors.danger,
                            background: AppColors.dangerSoft,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            context.tr(
                              'Текст доступен в формате PDF',
                              'Текст PDF форматында',
                            ),
                            style: AppTextStyles.bodyLarge.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
      ),
      bottomNavigationBar: hasPdf
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: SyButton(
                  label: context.tr('Открыть PDF', 'PDF ачуу'),
                  icon: Icons.picture_as_pdf_outlined,
                  loading: _openingPdf,
                  onPressed: _openPdf,
                ),
              ),
            )
          : null,
    );
  }
}
