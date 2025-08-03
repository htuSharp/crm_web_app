import 'package:flutter/material.dart';
import '../constants/data_management_constants.dart';

class ErrorAnimationWidget extends StatelessWidget {
  final AnimationController animationController;
  final String? errorMessage;

  const ErrorAnimationWidget({
    super.key,
    required this.animationController,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return animationController.value > 0 && errorMessage != null
            ? Opacity(
                opacity: animationController.value,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(
                    vertical: 6,
                    horizontal: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red[100],
                    borderRadius: DataManagementStyles.defaultBorderRadius,
                    border: Border.all(color: Colors.red),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: DataManagementStyles.iconSize,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          errorMessage ?? '',
                          style: DataManagementStyles.errorStyle,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : const SizedBox.shrink();
      },
    );
  }
}
