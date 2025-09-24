import 'package:flutter/material.dart';

class StarlaneColors {
  // ========== PRIMARY COLORS ==========
  static const Color navy50 = Color(0xFFF8FAFC);
  static const Color navy100 = Color(0xFFF1F5F9);
  static const Color navy200 = Color(0xFFE2E8F0);
  static const Color navy300 = Color(0xFFCBD5E1);
  static const Color navy400 = Color(0xFF94A3B8);
  static const Color navy500 = Color(0xFF64748B);
  static const Color navy600 = Color(0xFF475569);
  static const Color navy700 = Color(0xFF334155);
  static const Color navy800 = Color(0xFF1E293B);
  static const Color navy900 = Color(0xFF0F172A);

  // ========== GOLD COLORS ==========
  static const Color gold50 = Color(0xFFFEFDF4);
  static const Color gold100 = Color(0xFFFEF7CD);
  static const Color gold200 = Color(0xFFFEED9B);
  static const Color gold300 = Color(0xFFFDE047);
  static const Color gold400 = Color(0xFFFACC15);
  static const Color gold500 = Color(0xFFEAB308);
  static const Color gold600 = Color(0xFFCA8A04);
  static const Color gold700 = Color(0xFFA16207);
  static const Color gold800 = Color(0xFF854D0E);
  static const Color gold900 = Color(0xFF713F12);

  // ========== EMERALD COLORS ==========
  static const Color emerald50 = Color(0xFFECFDF5);
  static const Color emerald100 = Color(0xFFD1FAE5);
  static const Color emerald200 = Color(0xFFA7F3D0);
  static const Color emerald300 = Color(0xFF6EE7B7);
  static const Color emerald400 = Color(0xFF34D399);
  static const Color emerald500 = Color(0xFF10B981);
  static const Color emerald600 = Color(0xFF059669);
  static const Color emerald700 = Color(0xFF047857);
  static const Color emerald800 = Color(0xFF065F46);
  static const Color emerald900 = Color(0xFF064E3B);

  // ========== PURPLE COLORS ==========
  static const Color purple50 = Color(0xFFFAF5FF);
  static const Color purple100 = Color(0xFFF3E8FF);
  static const Color purple200 = Color(0xFFE9D5FF);
  static const Color purple300 = Color(0xFFD8B4FE);
  static const Color purple400 = Color(0xFFC084FC);
  static const Color purple500 = Color(0xFFA855F7);
  static const Color purple600 = Color(0xFF9333EA);
  static const Color purple700 = Color(0xFF7C3AED);
  static const Color purple800 = Color(0xFF6B21A8);
  static const Color purple900 = Color(0xFF581C87);

  // ========== BLUE COLORS ==========
  static const Color blue50 = Color(0xFFEFF6FF);
  static const Color blue100 = Color(0xFFDBEAFE);
  static const Color blue200 = Color(0xFFBFDBFE);
  static const Color blue300 = Color(0xFF93C5FD);
  static const Color blue400 = Color(0xFF60A5FA);
  static const Color blue500 = Color(0xFF3B82F6);
  static const Color blue600 = Color(0xFF2563EB);
  static const Color blue700 = Color(0xFF1D4ED8);
  static const Color blue800 = Color(0xFF1E40AF);
  static const Color blue900 = Color(0xFF1E3A8A);

  // ========== PINK COLORS ==========
  static const Color pink50 = Color(0xFFFDF2F8);
  static const Color pink100 = Color(0xFFFCE7F3);
  static const Color pink200 = Color(0xFFFBCFE8);
  static const Color pink300 = Color(0xFFF9A8D4);
  static const Color pink400 = Color(0xFFF472B6);
  static const Color pink500 = Color(0xFFEC4899);
  static const Color pink600 = Color(0xFFDB2777);
  static const Color pink700 = Color(0xFFBE185D);
  static const Color pink800 = Color(0xFF9D174D);
  static const Color pink900 = Color(0xFF831843);

  // ========== RED COLORS ==========
  static const Color red50 = Color(0xFFFEF2F2);
  static const Color red100 = Color(0xFFFEE2E2);
  static const Color red200 = Color(0xFFFECACA);
  static const Color red300 = Color(0xFFFCA5A5);
  static const Color red400 = Color(0xFFF87171);
  static const Color red500 = Color(0xFFEF4444);
  static const Color red600 = Color(0xFFDC2626);
  static const Color red700 = Color(0xFFB91C1C);
  static const Color red800 = Color(0xFF991B1B);
  static const Color red900 = Color(0xFF7F1D1D);

  // ========== GRAY COLORS ==========
  static const Color gray50 = Color(0xFFF9FAFB);
  static const Color gray100 = Color(0xFFF3F4F6);
  static const Color gray200 = Color(0xFFE5E7EB);
  static const Color gray300 = Color(0xFFD1D5DB);
  static const Color gray400 = Color(0xFF9CA3AF);
  static const Color gray500 = Color(0xFF6B7280);
  static const Color gray600 = Color(0xFF4B5563);
  static const Color gray700 = Color(0xFF374151);
  static const Color gray800 = Color(0xFF1F2937);
  static const Color gray900 = Color(0xFF111827);

  // ========== BASIC COLORS ==========
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color transparent = Color(0x00000000);

  // ========== SEMANTIC COLORS ==========
  static const Color success = emerald500;
  static const Color error = red500;
  static const Color warning = gold500;
  static const Color info = blue500;

  // ========== GRADIENTS ==========
  static const LinearGradient premiumGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      gold400,
      gold600,
      navy700,
    ],
  );

  static const LinearGradient luxuryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      navy700,
      navy800,
      navy900,
    ],
  );

  static const LinearGradient emeraldGradient = LinearGradient(
    colors: [emerald400, emerald600],
  );

  // ========== SHADOWS ==========
  static const List<BoxShadow> luxuryShadow = [
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 10,
      offset: Offset(0, 4),
    ),
  ];

  static const List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Color(0x14000000),
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ];

  static const List<BoxShadow> softShadow = [
    BoxShadow(
      color: Color(0x0F000000),
      blurRadius: 6,
      offset: Offset(0, 2),
    ),
  ];
}