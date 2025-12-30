import 'package:flutter/material.dart';
import 'package:nexira/core/premium/premium_config.dart';

class UstaCard extends StatelessWidget {
  final String name;
  final String jobTitle;
  final double rating;
  final int ratingCount;
  final String locationText;
  final String distanceText;
  final UstaTier tier;

  final VoidCallback onTap;
  final VoidCallback onFollow;
  final VoidCallback onMessage;

  const UstaCard({
    super.key,
    required this.name,
    required this.jobTitle,
    required this.rating,
    required this.ratingCount,
    required this.locationText,
    required this.distanceText,
    required this.tier,
    required this.onTap,
    required this.onFollow,
    required this.onMessage,
  });

  @override
  Widget build(BuildContext context) {
    final cfg = UstaTierConfig.of(context, tier);
    final isDark = cfg.darkCard;

    final primary = isDark ? Colors.white : Colors.black87;
    final secondary = isDark ? Colors.white70 : (Colors.grey[700] ?? Colors.black54);

    // Paket rengi: hem outline hem ikonlar için ana renk gibi kullanalım
    final accent = cfg.borderColor;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: cfg.backgroundColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: cfg.borderColor, width: 1.5),
              boxShadow: cfg.highlightCard
                  ? [
                BoxShadow(
                  color: cfg.borderColor.withOpacity(0.14),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                )
              ]
                  : null,
            ),
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // İsim
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                    color: primary,
                  ),
                ),

                const SizedBox(height: 2),

                // Meslek
                Text(
                  jobTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 11.5, color: secondary),
                ),

                const SizedBox(height: 4),

                // Puan
                Row(
                  children: [
                    const Icon(Icons.star_rounded, size: 16, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(
                      rating.toStringAsFixed(1),
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                        color: primary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '($ratingCount)',
                      style: TextStyle(fontSize: 11, color: secondary),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                // Konum + Mesafe
                Row(
                  children: [
                    Icon(Icons.place_outlined, size: 14, color: secondary),
                    const SizedBox(width: 2),
                    Expanded(
                      child: Text(
                        locationText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 11, color: secondary),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      distanceText,
                      style: TextStyle(fontSize: 11, color: secondary),
                    ),
                  ],
                ),

                const Spacer(),

                // Aksiyonlar (daha kompakt)
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 30,
                        child: OutlinedButton(
                          onPressed: onFollow,
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: accent.withOpacity(0.85), width: 1.2),
                            foregroundColor: accent,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text(
                            'Takip',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),

                    // Mesaj ikonu: görünür olsun diye paket rengi + hafif bubble
                    InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: onMessage,
                      child: Container(
                        height: 30,
                        width: 40,
                        decoration: BoxDecoration(
                          color: accent.withOpacity(isDark ? 0.12 : 0.08),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: accent.withOpacity(0.35)),
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.chat_bubble_outline,
                          size: 18,
                          color: accent,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ROZET – Positioned (layout bozmaz)
          if (cfg.name != 'Standart')
            Positioned(
              top: 6,
              right: 6,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: cfg.badgeColor,
                  borderRadius: BorderRadius.circular(99),
                  border: Border.all(
                    color: (cfg.badgeTextColor ?? Colors.white).withOpacity(0.18),
                  ),
                ),
                child: Text(
                  cfg.name,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: cfg.badgeTextColor ?? Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
