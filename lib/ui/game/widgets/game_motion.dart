import 'package:flutter/material.dart';

/// Scales down slightly on press (springs back on release) and scales up
/// a touch on mouse hover — makes any tappable widget feel alive without
/// changing its look. Hover only ever fires with a real mouse (desktop/web),
/// so touch devices just get the press feedback, unchanged.
class PressableScale extends StatefulWidget {
  const PressableScale({super.key, required this.child, this.onTap});

  final Widget child;
  final VoidCallback? onTap;

  @override
  State<PressableScale> createState() => _PressableScaleState();
}

class _PressableScaleState extends State<PressableScale> {
  bool _pressed = false;
  bool _hovering = false;

  double get _scale => _pressed ? 0.96 : (_hovering ? 1.04 : 1.0);

  void _setPressed(bool value) {
    if (widget.onTap == null) return;
    setState(() => _pressed = value);
  }

  void _setHovering(bool value) => setState(() => _hovering = value);

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _setHovering(true),
      onExit: (_) => _setHovering(false),
      cursor:
          widget.onTap == null
              ? MouseCursor.defer
              : SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        onTapDown: (_) => _setPressed(true),
        onTapUp: (_) => _setPressed(false),
        onTapCancel: () => _setPressed(false),
        child: AnimatedScale(
          scale: _scale,
          duration: const Duration(milliseconds: 140),
          curve: Curves.easeOut,
          child: widget.child,
        ),
      ),
    );
  }
}

/// Hover-only zoom for things that aren't themselves a single tap target —
/// e.g. a whole card that contains its own button. No press feedback, just
/// a gentle scale-up while the mouse is over it.
class HoverZoom extends StatefulWidget {
  const HoverZoom({super.key, required this.child, this.scale = 1.03});

  final Widget child;
  final double scale;

  @override
  State<HoverZoom> createState() => _HoverZoomState();
}

class _HoverZoomState extends State<HoverZoom> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedScale(
        scale: _hovering ? widget.scale : 1.0,
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}

/// Fades + slides a child in shortly after it first builds. Give each item
/// in a list a different [delay] for a staggered entrance.
class FadeSlideIn extends StatefulWidget {
  const FadeSlideIn({
    super.key,
    required this.child,
    this.delay = Duration.zero,
  });

  final Widget child;
  final Duration delay;

  @override
  State<FadeSlideIn> createState() => _FadeSlideInState();
}

class _FadeSlideInState extends State<FadeSlideIn> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(widget.delay, () {
      if (mounted) setState(() => _visible = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _visible ? 1 : 0,
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOut,
      child: AnimatedSlide(
        offset: _visible ? Offset.zero : const Offset(0, 0.08),
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}

/// Gentle, endless pulse — used for "waiting" spinners/badges so the screen
/// doesn't feel static while polling.
class Pulse extends StatefulWidget {
  const Pulse({super.key, required this.child, this.minScale = 0.92});

  final Widget child;
  final double minScale;

  @override
  State<Pulse> createState() => _PulseState();
}

class _PulseState extends State<Pulse> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: Tween(begin: widget.minScale, end: 1.0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
      ),
      child: widget.child,
    );
  }
}

/// Expanding, fading rings behind [child] — a "searching" radar sweep for
/// matchmaking screens that would otherwise just show a static spinner.
class RadarPulse extends StatefulWidget {
  const RadarPulse({
    super.key,
    required this.child,
    this.size = 96,
    this.color = const Color(0xFF7B1FA2),
    this.ringCount = 3,
  });

  final Widget child;
  final double size;
  final Color color;
  final int ringCount;

  @override
  State<RadarPulse> createState() => _RadarPulseState();
}

class _RadarPulseState extends State<RadarPulse>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1800),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return Stack(
            alignment: Alignment.center,
            children: [
              for (var i = 0; i < widget.ringCount; i++)
                _ring((_controller.value + i / widget.ringCount) % 1.0),
              widget.child,
            ],
          );
        },
      ),
    );
  }

  Widget _ring(double t) {
    final scale = 0.45 + t * 0.85;
    final opacity = (1 - t).clamp(0.0, 1.0) * 0.5;
    return Opacity(
      opacity: opacity,
      child: Transform.scale(
        scale: scale,
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: widget.color, width: 2),
          ),
        ),
      ),
    );
  }
}

/// Text with a slowly cycling "." → ".." → "..." suffix, so a waiting
/// message reads as alive rather than frozen.
class AnimatedEllipsisText extends StatefulWidget {
  const AnimatedEllipsisText(this.text, {super.key, required this.style});

  final String text;
  final TextStyle style;

  @override
  State<AnimatedEllipsisText> createState() => _AnimatedEllipsisTextState();
}

class _AnimatedEllipsisTextState extends State<AnimatedEllipsisText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final dots = '.' * (1 + (_controller.value * 3).floor() % 3);
        return Text('${widget.text}$dots', style: widget.style);
      },
    );
  }
}

/// Score text that pops with a little bounce whenever [value] changes —
/// a quick, legible way to draw the eye without a distracting digit roll.
class AnimatedScoreText extends StatefulWidget {
  const AnimatedScoreText({super.key, required this.value, required this.style});

  final int value;
  final TextStyle style;

  @override
  State<AnimatedScoreText> createState() => _AnimatedScoreTextState();
}

class _AnimatedScoreTextState extends State<AnimatedScoreText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 260),
  );
  late final Animation<double> _scale = TweenSequence<double>([
    TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.35), weight: 40),
    TweenSequenceItem(tween: Tween(begin: 1.35, end: 1.0), weight: 60),
  ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

  @override
  void didUpdateWidget(covariant AnimatedScoreText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: Text('${widget.value}', style: widget.style),
    );
  }
}
