// lib/features/home/offers_sent_page.dart
import 'package:flutter/material.dart';
import 'offer_model.dart';

class OffersSentPage extends StatelessWidget {
  const OffersSentPage({super.key});

  String _formatDate(DateTime d) {
    final day = d.day.toString().padLeft(2, '0');
    final month = d.month.toString().padLeft(2, '0');
    final year = d.year.toString();
    return '$day.$month.$year';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Sahte "benim verdiğim" teklifler
    final List<Offer> offers = [
      Offer(
        id: 's1',
        jobId: '1',
        jobTitle: '2+1 ev için komple boya',
        professionalId: 'currentUser',
        professionalName: 'Ben (Profesyonel)',
        price: 10000,
        estimatedDuration: '3 gün',
        note: 'İşi 3 günde teslim ederim, malzeme bana ait.',
        status: OfferStatus.pending,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      Offer(
        id: 's2',
        jobId: '2',
        jobTitle: 'Mutfak dolabı yenileme',
        professionalId: 'currentUser',
        professionalName: 'Ben (Profesyonel)',
        price: 25000,
        estimatedDuration: '7 gün',
        note: 'Lake kapak, yavaş kapanan menteşe kullanırım.',
        status: OfferStatus.accepted,
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verdiğim Teklifler'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: offers.length,
        itemBuilder: (context, index) {
          final offer = offers[index];
          return Card(
            elevation: 3,
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    offer.jobTitle,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Teklif Sahibi: ${offer.professionalName}',
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.attach_money,
                          size: 18, color: colorScheme.primary),
                      const SizedBox(width: 4),
                      Text(
                        '${offer.price.toStringAsFixed(0)}₺',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Icon(Icons.schedule_outlined, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        offer.estimatedDuration,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    offer.note,
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _StatusChip(status: offer.status),
                      Text(
                        _formatDate(offer.createdAt),
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final OfferStatus status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg;
    String label;

    switch (status) {
      case OfferStatus.pending:
        bg = Colors.amber.withOpacity(0.2);
        label = 'Beklemede';
        break;
      case OfferStatus.accepted:
        bg = Colors.green.withOpacity(0.2);
        label = 'Kabul edildi';
        break;
      case OfferStatus.rejected:
        bg = Colors.red.withOpacity(0.2);
        label = 'Reddedildi';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
