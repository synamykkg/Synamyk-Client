import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:synamyk/data/repositories/game/game_repository.dart';
import 'package:synamyk/data/repositories/profile/profile_repository.dart';
import 'package:synamyk/data/services/game_socket_service.dart';
import 'package:synamyk/domain/models/game/game_question.dart';
import 'package:synamyk/ui/core/ui/themes/app_text_styles.dart';
import 'package:synamyk/ui/game/bloc/game_bloc.dart';
import 'package:synamyk/ui/game/widgets/game_motion.dart';

class GameRoomPage extends StatelessWidget {
  const GameRoomPage({super.key, required this.gameTestId});

  final int gameTestId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              GameBloc(
                  gameRepository: GetIt.I<GameRepository>(),
                  profileRepository: GetIt.I<ProfileRepository>(),
                  socketService: GetIt.I<GameSocketService>(),
                )
                ..add(GameJoinRequested(gameTestId: gameTestId)),
      child: const _GameRoomView(),
    );
  }
}

class _GameRoomView extends StatelessWidget {
  const _GameRoomView();

  Future<bool> _confirmExit(BuildContext context) async {
    final bloc = context.read<GameBloc>();
    final state = bloc.state;
    if (state is GameWaitingForOpponent || state is GameInProgress) {
      // Awaited so the socket is fully torn down before this route (and its
      // GameBloc/GameSocketService) is disposed — otherwise a fast rejoin
      // can race a live client into existence alongside the dying one.
      await bloc.leaveRoom();
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        if (await _confirmExit(context) && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: SafeArea(
        child: Scaffold(
          body: BlocConsumer<GameBloc, GameBlocState>(
            listener: (context, state) {},
            builder: (context, state) {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 320),
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeIn,
                child: KeyedSubtree(
                  key: ValueKey(state.runtimeType),
                  child: switch (state) {
                GameIdle() || GameJoining() => const _CenteredMessage(
                  child: CircularProgressIndicator(),
                ),
                GameFailure(:final message) => _CenteredMessage(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const _OutcomeBadge(
                        icon: Icons.error_outline_rounded,
                        color: Color(0xFFB3B3B3),
                        background: Color(0xFFF0F0F0),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        message,
                        style: AppTextStyles.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      _PillButton(
                        label: 'Назад',
                        color: const Color(0xFF7B1FA2),
                        background: const Color(0xFFF4E6FA),
                        onTap: () async {
                          await context.read<GameBloc>().leaveRoom();
                          if (context.mounted) Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ),
                GameWaitingForOpponent(:final message) => _CenteredMessage(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const _WaitingVsRow(),
                      const SizedBox(height: 24),
                      AnimatedEllipsisText(
                        message.replaceAll(RegExp(r'\.+$'), ''),
                        style: AppTextStyles.bodyMedium,
                      ),
                      const SizedBox(height: 24),
                      _PillButton(
                        label: 'Отменить',
                        color: const Color(0xFF7B1FA2),
                        background: const Color(0xFFF4E6FA),
                        onTap: () async {
                          await context.read<GameBloc>().leaveRoom();
                          if (context.mounted) Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ),
                GameInProgress() => _GameQuestionView(state: state),
                GameFinished(
                  :final myScore,
                  :final opponentScore,
                  :final won,
                  :final draw,
                  :final forfeitedByMe,
                  :final forfeitedByOpponent,
                ) =>
                  _CenteredMessage(
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: 1),
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeOutBack,
                      builder: (context, value, child) {
                        return Transform.scale(scale: value, child: child);
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _OutcomeBadge(
                            icon:
                                draw || forfeitedByMe
                                    ? Icons.handshake_rounded
                                    : won
                                    ? Icons.emoji_events_rounded
                                    : Icons.sentiment_dissatisfied_rounded,
                            color:
                                won && !forfeitedByMe
                                    ? const Color(0xFF2E7D32)
                                    : draw
                                    ? const Color(0xFF9E9E9E)
                                    : const Color(0xFFC62828),
                            background:
                                won && !forfeitedByMe
                                    ? const Color(0xFFE8F5E9)
                                    : draw
                                    ? const Color(0xFFF0F0F0)
                                    : const Color(0xFFFDEAEA),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            forfeitedByMe
                                ? 'Вы сдались'
                                : forfeitedByOpponent
                                ? 'Соперник сдался — вы победили'
                                : draw
                                ? 'Ничья'
                                : won
                                ? 'Победа!'
                                : 'Поражение',
                            style: AppTextStyles.h1,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '$myScore : $opponentScore',
                            style: AppTextStyles.h2,
                          ),
                          const SizedBox(height: 24),
                          PressableScale(
                            onTap: () async {
                              await context.read<GameBloc>().leaveRoom();
                              if (context.mounted) Navigator.of(context).pop();
                            },
                            child: Container(
                              width: 220,
                              height: 48,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: const Color(0xFF7B1FA2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'На главную',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _CenteredMessage extends StatelessWidget {
  const _CenteredMessage({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: child,
      ),
    );
  }
}

/// "You" vs a searching slot — makes the matchmaking wait read as a real
/// head-to-head setup instead of a bare spinner.
class _WaitingVsRow extends StatelessWidget {
  const _WaitingVsRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF7B1FA2),
              ),
              child: const Icon(Icons.person, color: Colors.white, size: 32),
            ),
            const SizedBox(height: 8),
            Text('Вы', style: AppTextStyles.bodySmall),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text('VS', style: AppTextStyles.h4),
        ),
        Column(
          children: [
            RadarPulse(
              size: 64,
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF7B1FA2).withOpacity(0.4),
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.question_mark_rounded,
                  color: Color(0xFF7B1FA2),
                  size: 28,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text('Соперник', style: AppTextStyles.bodySmall),
          ],
        ),
      ],
    );
  }
}

class _GameQuestionView extends StatelessWidget {
  const _GameQuestionView({required this.state});

  final GameInProgress state;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ScoreHeader(state: state),
          const SizedBox(height: 16),
          Row(
            children: [
              _QuestionTimer(
                key: ValueKey(state.question.id),
                timeLimitSeconds: state.timeLimitSeconds,
                startedAt: state.questionStartedAt,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Вопрос ${state.questionIndex + 1} из ${state.totalQuestions}',
                      style: AppTextStyles.bodySmall,
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value:
                            (state.questionIndex + 1) / state.totalQuestions,
                        minHeight: 6,
                        backgroundColor: const Color(0xFFE0E0E0),
                        valueColor: const AlwaysStoppedAnimation(
                          Color(0xFF7B1FA2),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 260),
              switchInCurve: Curves.easeOut,
              transitionBuilder:
                  (child, animation) => FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween(
                        begin: const Offset(0, 0.04),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  ),
              child: SingleChildScrollView(
                key: ValueKey(state.question.id),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(state.question.text, style: AppTextStyles.h3),
                    if (state.question.imageUrl != null) ...[
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(state.question.imageUrl!),
                      ),
                    ],
                    const SizedBox(height: 24),
                    ...state.question.options.asMap().entries.map(
                      (entry) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _OptionTile(
                          option: entry.value,
                          index: entry.key,
                          state: state,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Center(
            child: _PillButton(
              label: 'Сдаться',
              color: Colors.red,
              background: const Color(0xFFFDEAEA),
              onTap: () => _confirmForfeit(context),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmForfeit(BuildContext context) async {
    final bloc = context.read<GameBloc>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Сдаться?'),
            content: const Text(
              'Игра завершится, и соперник будет объявлен победителем.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Отмена'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Сдаться'),
              ),
            ],
          ),
    );

    if (confirmed == true) {
      bloc.add(GameForfeitRequested());
    }
  }
}

class _ScoreHeader extends StatelessWidget {
  const _ScoreHeader({required this.state});

  final GameInProgress state;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              const _PlayerBadge(icon: Icons.person, color: Color(0xFF7B1FA2)),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state.myName,
                      style: AppTextStyles.bodyMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                    AnimatedScoreText(
                      value: state.myScore,
                      style: AppTextStyles.h2,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFEDF8F2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'VS',
            style: AppTextStyles.bodySmall.copyWith(
              fontWeight: FontWeight.w700,
              color: const Color(0xFF7B1FA2),
            ),
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      state.opponentName,
                      style: AppTextStyles.bodyMedium,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.right,
                    ),
                    AnimatedScoreText(
                      value: state.opponentScore,
                      style: AppTextStyles.h2,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _PlayerBadge(
                icon: state.opponentIsBot ? Icons.smart_toy : Icons.person,
                color: const Color(0xFFEF6C00),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PlayerBadge extends StatelessWidget {
  const _PlayerBadge({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 18),
    );
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.option,
    required this.index,
    required this.state,
  });

  final GameOption option;
  final int index;
  final GameInProgress state;

  @override
  Widget build(BuildContext context) {
    final isSelected = state.selectedOptionId == option.id;
    final answered = state.selectedOptionId != null;

    Color background = const Color(0xFFEDF8F2);
    Color border = const Color(0xFF252525).withOpacity(0.1);
    Color badgeColor = const Color(0xFF7B1FA2);
    Color badgeBackground = const Color(0xFFF4E6FA);
    IconData? statusIcon;

    if (isSelected) {
      if (state.lastAnswerCorrect == true) {
        background = const Color(0xFFD9F7E4);
        border = Colors.green;
        badgeColor = Colors.green;
        badgeBackground = Colors.white;
        statusIcon = Icons.check_rounded;
      } else if (state.lastAnswerCorrect == false) {
        background = const Color(0xFFFCE0E0);
        border = Colors.red;
        badgeColor = Colors.red;
        badgeBackground = Colors.white;
        statusIcon = Icons.close_rounded;
      } else {
        background = const Color(0xFFEDE0F5);
        border = const Color(0xFF7B1FA2);
      }
    }

    final letter = String.fromCharCode(65 + index); // A, B, C, D…

    return PressableScale(
      onTap:
          answered
              ? null
              : () => context.read<GameBloc>().add(
                GameAnswerSubmitted(optionId: option.id),
              ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: background,
          border: Border.all(color: border, width: isSelected ? 2 : 1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: badgeBackground,
                shape: BoxShape.circle,
              ),
              child:
                  statusIcon != null
                      ? Icon(statusIcon, color: badgeColor, size: 16)
                      : Text(
                        letter,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: badgeColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(option.text, style: AppTextStyles.bodyLarge),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuestionTimer extends StatefulWidget {
  const _QuestionTimer({
    super.key,
    required this.timeLimitSeconds,
    required this.startedAt,
  });

  final int timeLimitSeconds;
  final DateTime startedAt;

  @override
  State<_QuestionTimer> createState() => _QuestionTimerState();
}

class _QuestionTimerState extends State<_QuestionTimer> {
  Timer? _timer;
  int _remaining = 0;

  @override
  void initState() {
    super.initState();
    _tick();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _tick() {
    final elapsed = DateTime.now().difference(widget.startedAt).inSeconds;
    final remaining = (widget.timeLimitSeconds - elapsed).clamp(
      0,
      widget.timeLimitSeconds,
    );
    if (mounted) setState(() => _remaining = remaining);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final urgent = _remaining <= 5;
    final color = urgent ? Colors.red : const Color(0xFF7B1FA2);
    final progress =
        widget.timeLimitSeconds == 0
            ? 0.0
            : _remaining / widget.timeLimitSeconds;

    final ring = SizedBox(
      width: 44,
      height: 44,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 44,
            height: 44,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 3,
              backgroundColor: const Color(0xFFE0E0E0),
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
          Text(
            '$_remaining',
            style: AppTextStyles.bodyMedium.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
    return urgent ? Pulse(minScale: 0.9, child: ring) : ring;
  }
}

/// Big circular icon used on the game's terminal screens (finished/error) —
/// mirrors the colored-badge language used on the redesigned Profile screen.
class _OutcomeBadge extends StatelessWidget {
  const _OutcomeBadge({
    required this.icon,
    required this.color,
    required this.background,
  });

  final IconData icon;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(color: background, shape: BoxShape.circle),
      child: Icon(icon, color: color, size: 36),
    );
  }
}

/// A filled pill button — used in place of plain [TextButton]s so actions
/// like "Сдаться"/"Отменить"/"Назад" read as real buttons.
class _PillButton extends StatelessWidget {
  const _PillButton({
    required this.label,
    required this.color,
    required this.background,
    required this.onTap,
  });

  final String label;
  final Color color;
  final Color background;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
