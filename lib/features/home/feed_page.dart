// lib/features/home/feed_page.dart
import 'package:flutter/material.dart';

/// Akıştaki her gönderiyi temsil eden model
class Post {
  final String id;
  final String userName;
  final String profession;
  final String location;
  final bool isPremium;
  final String mediaType; // "image", "before_after", "video" gibi
  final String description;
  final String imageUrl;

  const Post({
    required this.id,
    required this.userName,
    required this.profession,
    required this.location,
    required this.isPremium,
    required this.mediaType,
    required this.description,
    required this.imageUrl,
  });
}

/// Hem usta hem müşteri için kullanılacak ortak akış sayfası
class FeedPage extends StatelessWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Sahte veriler (fake data)
    final List<Post> posts = [
      const Post(
        id: '1',
        userName: 'Ahmet Usta',
        profession: 'Marangoz',
        location: 'İstanbul / Kadıköy',
        isPremium: true,
        mediaType: 'before_after',
        description:
        'Eski bir masayı tamamen yeniledim. Müşterinin istediği renge ve tarza göre yeniden tasarladım.',
        imageUrl: 'https://picsum.photos/seed/nexira1/800/450',
      ),
      const Post(
        id: '2',
        userName: 'Merve İçmimar',
        profession: 'İç Mimar',
        location: 'Ankara / Çankaya',
        isPremium: true,
        mediaType: 'image',
        description:
        '2+1 daireyi minimal ve sıcak bir tarza dönüştürdüm. Özellikle salon aydınlatmasını güçlendirdik.',
        imageUrl: 'https://picsum.photos/seed/nexira2/800/450',
      ),
      const Post(
        id: '3',
        userName: 'Ali Elektrik',
        profession: 'Elektrik Tesisatı',
        location: 'İzmir / Karşıyaka',
        isPremium: false,
        mediaType: 'image',
        description:
        'Tüm dairenin elektrik tesisatını yeniledim. Kaçak akım rölesi ve yeni sigorta panosu dahil.',
        imageUrl: 'https://picsum.photos/seed/nexira3/800/450',
      ),
      const Post(
        id: '4',
        userName: 'Seda Boya & Dekorasyon',
        profession: 'Boyacı',
        location: 'Bursa / Nilüfer',
        isPremium: true,
        mediaType: 'video',
        description:
        'Ofis katında kurumsal renklere uygun bir boya ve duvar dekorasyonu uygulaması yaptım.',
        imageUrl: 'https://picsum.photos/seed/nexira4/800/450',
      ),
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        return _PostCard(post: post);
      },
    );
  }
}

class _PostCard extends StatelessWidget {
  final Post post;

  const _PostCard({required this.post});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Üst kısım: avatar + isim + meslek + konum + rozet
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: colorScheme.primary.withOpacity(0.1),
                  child: Text(
                    _getInitials(post.userName),
                    style: TextStyle(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.userName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        post.profession,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            post.location,
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (post.isPremium)
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: colorScheme.primary.withOpacity(0.4),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.star,
                          size: 14,
                          color: colorScheme.primary,
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          'Premium Üye',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          // Ortadaki görsel (şimdilik tek foto)
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.network(
                    post.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
                // Sağ üstte küçük etiket: mediaType
                Positioned(
                  right: 8,
                  top: 8,
                  child: _MediaTypeChip(mediaType: post.mediaType),
                ),
              ],
            ),
          ),

          // Alt açıklama kısmı
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Text(
              post.description,
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }
    final first = parts.first.substring(0, 1).toUpperCase();
    final last = parts.last.substring(0, 1).toUpperCase();
    return '$first$last';
  }
}

class _MediaTypeChip extends StatelessWidget {
  final String mediaType;

  const _MediaTypeChip({required this.mediaType});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    String label;
    IconData icon;

    switch (mediaType) {
      case 'before_after':
        label = 'Öncesi / Sonrası';
        icon = Icons.compare_arrows_outlined;
        break;
      case 'video':
        label = 'Video';
        icon = Icons.play_circle_outline;
        break;
      case 'image':
      default:
        label = 'Fotoğraf';
        icon = Icons.image_outlined;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.45),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
