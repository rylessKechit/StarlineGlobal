import 'package:flutter/material.dart';

/// Starlane Global Color System
/// Palette de couleurs premium pour l'écosystème luxury
class StarlaneColors {
  // Primary - Luxe doré
  static const Color gold50 = Color(0xFFFEFDF4);
  static const Color gold100 = Color(0xFFFEF7CD);
  static const Color gold200 = Color(0xFFFEED9B);
  static const Color gold300 = Color(0xFFFDE047);
  static const Color gold400 = Color(0xFFFACC15);
  static const Color gold500 = Color(0xFFD4AF37); // Primary Gold
  static const Color gold600 = Color(0xFFCA8A04);
  static const Color gold700 = Color(0xFFA16207);
  static const Color gold800 = Color(0xFF854D0E);
  static const Color gold900 = Color(0xFF744210);

  // Secondary - Bleu professionnel
  static const Color navy50 = Color(0xFFF8FAFC);
  static const Color navy100 = Color(0xFFF1F5F9);
  static const Color navy200 = Color(0xFFE2E8F0);
  static const Color navy300 = Color(0xFFCBD5E1);
  static const Color navy400 = Color(0xFF94A3B8);
  static const Color navy500 = Color(0xFF0F172A); // Primary Navy
  static const Color navy600 = Color(0xFF475569);
  static const Color navy700 = Color(0xFF334155);
  static const Color navy800 = Color(0xFF1E293B);
  static const Color navy900 = Color(0xFF020617);

  // Accent - Diversité
  static const Color emerald50 = Color(0xFFF0FDF4);
  static const Color emerald100 = Color(0xFFDCFCE7);
  static const Color emerald200 = Color(0xFFBBF7D0);
  static const Color emerald300 = Color(0xFF86EFAC);
  static const Color emerald400 = Color(0xFF4ADE80);
  static const Color emerald500 = Color(0xFF10B981); // Accent Green
  static const Color emerald600 = Color(0xFF059669);
  static const Color emerald700 = Color(0xFF047857);
  static const Color emerald800 = Color(0xFF065F46);
  static const Color emerald900 = Color(0xFF064E3B);

  static const Color purple50 = Color(0xFFFAF5FF);
  static const Color purple100 = Color(0xFFF3E8FF);
  static const Color purple200 = Color(0xFFE9D5FF);
  static const Color purple300 = Color(0xFFD8B4FE);
  static const Color purple400 = Color(0xFFC084FC);
  static const Color purple500 = Color(0xFF8B5CF6); // Accent Purple
  static const Color purple600 = Color(0xFF7C3AED);
  static const Color purple700 = Color(0xFF6D28D9);
  static const Color purple800 = Color(0xFF5B21B6);
  static const Color purple900 = Color(0xFF4C1D95);

  // Status Colors
  static const Color success = emerald500;
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Neutral - Grays
  static const Color white = Color(0xFFFFFFFF);
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
  static const Color black = Color(0xFF000000);

  // Gradients
  static const Gradient luxuryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [gold400, gold600],
  );

  static const Gradient nightGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [navy800, navy900],
  );

  static const Gradient diversityGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [emerald500, purple500],
  );

  static const Gradient premiumGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [navy500, purple600, emerald600],
    stops: [0.0, 0.5, 1.0],
  );

  // Shadows
  static const List<BoxShadow> luxuryShadow = [
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 20.0,
      offset: Offset(0, 8),
    ),
    BoxShadow(
      color: Color(0x0D000000),
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ];

  static const List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Color(0x0F000000),
      blurRadius: 10.0,
      offset: Offset(0, 4),
    ),
  ];

  static const List<BoxShadow> softShadow = [
    BoxShadow(
      color: Color(0x08000000),
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ];
}