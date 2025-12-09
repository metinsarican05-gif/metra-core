import 'package:flutter/material.dart';
import '../../core/premium/premium_config.dart';

/// Usta kartı (Keşfet ekranında görünen kart)
class UstaCard extends StatelessWidget {
  final String name;
  final String jobTitle;
  final double rating;
  final int ratingCount;
  final String locationText;
  final String distanceText;

  final String? companyName;
  final String? priceText;
  final String? priceSubtitle;
  final String? description;
  final bool hasPhotoPreview;

  final UstaTier tier;

  final VoidCallback? onTap;
  final VoidCallback? onMessageTap;
  final VoidCallback? onSelectTap;
  final VoidCallback? onCallTap;
  final VoidCallback? onWebsiteTap;

  final String? phone;
  final String? website;

  const UstaCard({
    super.key,
    required this.name,
    required this.jobTitle,
    required this.rating,
    required this.ratingCount,
    required this.locationText,
    required this.distanceText,
    required this.tier,

    this.companyName,
    this.priceText,
    this.priceSubtitle,
    this.description,
    this.hasPhotoPreview = false,

    this.onTap,
    this.onMessageTap,
    this.onSelectTap,
    this.onCallTap,
    this.onWebsiteTap,
    this.phone,
    this.website,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cfg = UstaTierConfig.of(context, tier);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: cfg.badgeColor?.withOpacity(0.08) ?? Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: cfg.borderColor,
              width: 2,
            ),
            boxShadow: [
              if (tier != UstaTier.standard)
                BoxShadow(
                  color: cfg.borderColor.withOpacity(0.25),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ÜST SATIR
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: cfg.borderColor,
                      child: Text(
                        _initials(name),
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (companyName != null && companyName!.isNotEmpty)
                            Text(
                              companyName!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          const SizedBox(height: 2),
                          Text(
                            jobTitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.grey[700],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.star_rounded,
                                  size: 18, color: Colors.amber),
                              const SizedBox(width: 4),
                              Text(
                                rating.toStringAsFixed(1),
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '($ratingCount)',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (cfg.name != 'Standart') ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: cfg.badgeColor,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          cfg.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),

                const SizedBox(height: 8),

                // KONUM – MESAFE
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined,
                        size: 18, color: Colors.grey),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        locationText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.directions_walk_outlined,
                        size: 16, color: Colors.grey),
                    const SizedBox(width: 2),
                    Text(
                      distanceText,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),

                if (priceText != null) ...[
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.payments_outlined,
                          size: 18, color: theme.colorScheme.primary),
                      const SizedBox(width: 4),
                      Text(
                        priceText!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  if (priceSubtitle != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      priceSubtitle!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey[700],
                      ),
                    )
                  ],
                ],

                if (description != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    description!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey[800],
                    ),
                  ),
                ],

                if (hasPhotoPreview) ...[
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      height: 70,
                      color: Colors.grey[200],
                      alignment: Alignment.center,
                      child: const Text(
                        'Öncesi / Sonrası fotoğraf önizlemesi',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 10),
                const Divider(height: 1),

                // ALT BUTONLAR
                Padding(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: onSelectTap ?? onTap,
                        icon: const Icon(Icons.check_circle_outline, size: 18),
                        label: const Text("Seç"),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),

                      OutlinedButton.icon(
                        onPressed: onMessageTap,
                        icon: const Icon(Icons.chat_bubble_outline, size: 18),
                        label: const Text("Mesaj"),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),

                      const Spacer(),

                      if (phone != null)
                        IconButton(
                          tooltip: "Ara",
                          onPressed: onCallTap,
                          icon:
                          const Icon(Icons.call_outlined, color: Colors.blue),
                        ),

                      if (website != null)
                        IconButton(
                          tooltip: "Web sitesi",
                          onPressed: onWebsiteTap,
                          icon: const Icon(Icons.language_outlined),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _initials(String text) {
    final parts = text.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }
    return parts[0].substring(0, 1).toUpperCase() +
        parts[1].substring(0, 1).toUpperCase();
  }
}
