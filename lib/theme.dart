import 'package:flutter/material.dart';

const sensoGold = Color(0xFFE7B64E);
const sensoBlack = Color(0xFF101010);
const sensoPanel = Color(0xFF1C1C1C);
const sensoMuted = Color(0xFFB7B7B7);

ThemeData sensoTheme() => ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  scaffoldBackgroundColor: sensoBlack,
  colorScheme: const ColorScheme.dark(
    primary: sensoGold,
    secondary: sensoGold,
    surface: sensoPanel,
  ),
  fontFamily: 'Roboto',
  appBarTheme: const AppBarTheme(
    backgroundColor: sensoBlack,
    foregroundColor: Colors.white,
    centerTitle: true,
    elevation: 0,
  ),
  cardTheme: CardThemeData(
    color: sensoPanel,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18),
    ),
  ),
);

Widget sensoBrand({double size = 27}) => Column(
  mainAxisSize: MainAxisSize.min,
  children: [
    Icon(
      Icons.local_cafe_rounded,
      color: sensoGold,
      size: size + 8,
    ),
    Text(
      'SENSO',
      style: TextStyle(
        color: sensoGold,
        fontSize: size,
        fontWeight: FontWeight.w800,
        letterSpacing: 2.4,
      ),
    ),
    const Text(
      'حس خوب',
      style: TextStyle(
        color: sensoGold,
        fontSize: 12,
      ),
    ),
  ],
);

Widget sectionTitle(String title, {String? trailing}) =>
    Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (trailing != null)
            Text(
              trailing,
              style: const TextStyle(
                color: sensoGold,
                fontSize: 12,
              ),
            ),
        ],
      ),
    );

Widget metricCard(
  String title,
  String value,
  IconData icon, {
  String? hint,
}) =>
    Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: sensoGold, size: 25),
            const SizedBox(height: 13),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                color: sensoMuted,
                fontSize: 12,
              ),
            ),
            if (hint != null)
              Text(
                hint,
                style: const TextStyle(
                  color: sensoGold,
                  fontSize: 11,
                ),
              ),
          ],
        ),
      ),
    );
