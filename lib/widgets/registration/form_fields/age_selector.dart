import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skool/constants/app_colors.dart';

/// A beautiful age selector widget with a slider and counter buttons.
class AgeSelector extends StatefulWidget {
  final int initialAge;
  final int minAge;
  final int maxAge;
  final ValueChanged<int>? onAgeChanged;

  const AgeSelector({
    super.key,
    this.initialAge = 10,
    this.minAge = 5,
    this.maxAge = 100,
    this.onAgeChanged,
  });

  @override
  State<AgeSelector> createState() => _AgeSelectorState();
}

class _AgeSelectorState extends State<AgeSelector> {
  late int _currentAge;

  @override
  void initState() {
    super.initState();
    _currentAge = widget.initialAge;
  }

  void _updateAge(int newAge) {
    if (newAge >= widget.minAge && newAge <= widget.maxAge) {
      setState(() => _currentAge = newAge);
      widget.onAgeChanged?.call(newAge);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Label Row
          Row(
            children: [
              Icon(
                Icons.cake_outlined,
                color: AppColors.primary,
                size: 22,
              ),
              const SizedBox(width: 8),
              Text(
                'العمر',
                style: GoogleFonts.cairo(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Counter Row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Decrement Button
              _buildCounterButton(
                icon: Icons.remove,
                onTap: () => _updateAge(_currentAge - 1),
                enabled: _currentAge > widget.minAge,
              ),

              // Age Display
              Container(
                width: 100,
                padding: const EdgeInsets.symmetric(vertical: 12),
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary.withValues(alpha: 0.1),
                      AppColors.primary.withValues(alpha: 0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.2),
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      '$_currentAge',
                      style: GoogleFonts.cairo(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                        height: 1,
                      ),
                    ),
                    Text(
                      'سنة',
                      style: GoogleFonts.cairo(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              // Increment Button
              _buildCounterButton(
                icon: Icons.add,
                onTap: () => _updateAge(_currentAge + 1),
                enabled: _currentAge < widget.maxAge,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Slider
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppColors.primary,
              inactiveTrackColor: AppColors.primary.withValues(alpha: 0.15),
              thumbColor: AppColors.primary,
              overlayColor: AppColors.primary.withValues(alpha: 0.1),
              trackHeight: 6,
              thumbShape: const RoundSliderThumbShape(
                enabledThumbRadius: 12,
                elevation: 3,
              ),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 24),
            ),
            child: Slider(
              value: _currentAge.toDouble(),
              min: widget.minAge.toDouble(),
              max: widget.maxAge.toDouble(),
              divisions: widget.maxAge - widget.minAge,
              onChanged: (value) => _updateAge(value.round()),
            ),
          ),

          // Min/Max Labels
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${widget.minAge}',
                  style: GoogleFonts.cairo(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  '${widget.maxAge}',
                  style: GoogleFonts.cairo(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCounterButton({
    required IconData icon,
    required VoidCallback onTap,
    required bool enabled,
  }) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: enabled
              ? AppColors.primary
              : AppColors.primary.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(12),
          boxShadow: enabled
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }
}
