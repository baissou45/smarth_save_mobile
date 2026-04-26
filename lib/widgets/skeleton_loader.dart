import 'package:flutter/material.dart';
import 'package:smarth_save/core/utils/theme/colors.dart';

class SkeletonLoader extends StatefulWidget {
  final Widget child;
  final bool isLoading;
  final double borderRadius;

  const SkeletonLoader({
    required this.child,
    required this.isLoading,
    this.borderRadius = 8,
    super.key,
  });

  @override
  State<SkeletonLoader> createState() => _SkeletonLoaderState();
}

class _SkeletonLoaderState extends State<SkeletonLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isLoading) {
      return widget.child;
    }

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return ShimmerWidget(
          child: widget.child,
          progress: _animationController.value,
          borderRadius: widget.borderRadius,
        );
      },
    );
  }
}

class ShimmerWidget extends StatelessWidget {
  final Widget child;
  final double progress;
  final double borderRadius;

  const ShimmerWidget({
    required this.child,
    required this.progress,
    required this.borderRadius,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Opacity(opacity: 0.5, child: child),
        Positioned.fill(
          child: ShaderMask(
            shaderCallback: (bounds) {
              return LinearGradient(
                begin: Alignment(-1.0 - (progress * 2), 0),
                end: Alignment(1.0 + (progress * 2), 0),
                colors: [
                  Colors.transparent,
                  Colors.white.withValues(alpha: 0.3),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.5, 1.0],
              ).createShader(bounds);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(borderRadius),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Skeleton cards pour la page budget
class BudgetSkeleton extends StatelessWidget {
  const BudgetSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kBgCard,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: kNavyDark.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: kBgPage,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 120,
                      height: 16,
                      decoration: BoxDecoration(
                        color: kBgPage,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 80,
                      height: 12,
                      decoration: BoxDecoration(
                        color: kBgPage,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 40,
                height: 20,
                decoration: BoxDecoration(
                  color: kBgPage,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            height: 8,
            decoration: BoxDecoration(
              color: kBgPage,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ],
      ),
    );
  }
}

class SummarySkeleton extends StatelessWidget {
  const SummarySkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kBgCard,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: kNavyDark.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: kBgPage,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 80,
                height: 12,
                decoration: BoxDecoration(
                  color: kBgPage,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: 120,
                height: 20,
                decoration: BoxDecoration(
                  color: kBgPage,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
