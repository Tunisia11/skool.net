import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skool/constants/app_colors.dart';
import 'package:skool/cubits/locale/locale_cubit.dart';
import 'package:skool/l10n/app_localizations.dart';

class AdminSettingsTab extends StatefulWidget {
  const AdminSettingsTab({super.key});

  @override
  State<AdminSettingsTab> createState() => _AdminSettingsTabState();
}

class _AdminSettingsTabState extends State<AdminSettingsTab> {
  bool _notificationsEnabled = true;
  bool _darkMode = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentLocale = Localizations.localeOf(context);
    final languageName = currentLocale.languageCode == 'ar' ? 'العربية' : 'English';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.settings,
            style: GoogleFonts.cairo(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 24),

          _buildSection('App', [
            SwitchListTile(
              title: Text(l10n.notifications, style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
              subtitle: Text(l10n.enableNotifications, style: GoogleFonts.cairo(fontSize: 12)),
              value: _notificationsEnabled,
              onChanged: (val) => setState(() => _notificationsEnabled = val),
            ),
            SwitchListTile(
              title: Text(l10n.darkMode, style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
              subtitle: Text(l10n.changeTheme, style: GoogleFonts.cairo(fontSize: 12)),
              value: _darkMode,
              onChanged: (val) => setState(() => _darkMode = val),
            ),
             ListTile(
              title: Text(l10n.language, style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
              subtitle: Text(languageName, style: GoogleFonts.cairo(fontSize: 12, color: AppColors.primary)),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                context.read<LocaleCubit>().toggleLocale();
              },
            ),
          ]),

          const SizedBox(height: 24),
          _buildSection('Support', [
             ListTile(
              title: Text(l10n.helpCenter, style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
              leading: const Icon(Icons.help_outline),
              trailing: const Icon(Icons.open_in_new, size: 16),
              onTap: () {},
            ),
             ListTile(
              title: Text(l10n.privacyPolicy, style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
              leading: const Icon(Icons.privacy_tip_outlined),
              trailing: const Icon(Icons.open_in_new, size: 16),
              onTap: () {},
            ),
             ListTile(
              title: Text(l10n.aboutApp, style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
              leading: const Icon(Icons.info_outline),
              subtitle: Text('${l10n.version} 1.0.0', style: GoogleFonts.cairo(fontSize: 12)),
              onTap: () {},
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: GoogleFonts.cairo(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey)),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.05),
                blurRadius: 10,
              ),
            ],
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }
}
