import 'package:flutter/material.dart';
import '../../core/premium/premium_config.dart';

/// Gönderi türü: tek fotoğraf, öncesi/sonrası, kısa video (şimdilik dummy)
enum PostType { singlePhoto, beforeAfter, shortVideo }

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({
    super.key,
    this.tier = UstaTier.standard,
  });

  /// Ustanın paketi (Standart / Pro / Vitrin / Sponsor)
  final UstaTier tier;

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  PostType _selectedType = PostType.singlePhoto;

  final TextEditingController _descriptionController = TextEditingController();
  String? _selectedCategory;

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  // ----------------------------------------------------------
  //  YARDIMCI: Paket limit metinleri
  // ----------------------------------------------------------

  int _beforeAfterLimit(UstaTier tier) {
    switch (tier) {
      case UstaTier.standard:
        return 3;
      case UstaTier.pro:
        return 8;
      case UstaTier.vitrin:
        return 20;
      case UstaTier.sponsor:
        return 9999; // pratikte sınırsız
    }
  }

  String _beforeAfterLimitText(UstaTier tier) {
    switch (tier) {
      case UstaTier.standard:
        return 'Standart pakette en fazla 3 öncesi / sonrası gönderisi.';
      case UstaTier.pro:
        return 'Pro pakette en fazla 8 öncesi / sonrası gönderisi.';
      case UstaTier.vitrin:
        return 'Vitrin pakette en fazla 20 öncesi / sonrası gönderisi.';
      case UstaTier.sponsor:
        return 'Sponsor pakette öncesi / sonrası gönderi sınırı yok.';
    }
  }

  String _tierLabel(UstaTier tier) {
    switch (tier) {
      case UstaTier.standard:
        return 'Standart';
      case UstaTier.pro:
        return 'Pro';
      case UstaTier.vitrin:
        return 'Vitrin';
      case UstaTier.sponsor:
        return 'Sponsor';
    }
  }

  Color _tierColor(UstaTier tier, BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    switch (tier) {
      case UstaTier.standard:
        return scheme.outline;
      case UstaTier.pro:
        return scheme.primary;
      case UstaTier.vitrin:
        return Colors.amber.shade700;
      case UstaTier.sponsor:
        return Colors.purple.shade600;
    }
  }

  // ----------------------------------------------------------
  //  BUILD
  // ----------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gönderi Oluştur'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTierInfo(context),
              const SizedBox(height: 24),
              _buildPostTypeSelector(primary),
              const SizedBox(height: 16),
              _buildMediaPlaceholder(),
              const SizedBox(height: 24),
              _buildCategoryField(),
              const SizedBox(height: 16),
              _buildDescriptionField(),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _onSubmit,
                  child: const Text('Gönderiyi Paylaş'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  //  WIDGET PARÇALARI
  // ----------------------------------------------------------

  Widget _buildTierInfo(BuildContext context) {
    final color = _tierColor(widget.tier, context);
    final label = _tierLabel(widget.tier);
    final limitText = _beforeAfterLimitText(widget.tier);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.7), width: 1.4),
        color: color.withOpacity(0.06),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.workspace_premium, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$label paket aktifsin',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  limitText,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.grey.shade700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostTypeSelector(Color primary) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Gönderi Türü',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            _buildTypeChip(
              label: 'Tek Fotoğraf',
              type: PostType.singlePhoto,
              icon: Icons.image_outlined,
              primary: primary,
            ),
            _buildTypeChip(
              label: 'Öncesi / Sonrası',
              type: PostType.beforeAfter,
              icon: Icons.compare_outlined,
              primary: primary,
            ),
            _buildTypeChip(
              label: 'Kısa Video',
              type: PostType.shortVideo,
              icon: Icons.videocam_outlined,
              primary: primary,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTypeChip({
    required String label,
    required PostType type,
    required IconData icon,
    required Color primary,
  }) {
    final bool isSelected = _selectedType == type;

    return ChoiceChip(
      selected: isSelected,
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 6),
          Text(label),
        ],
      ),
      selectedColor: primary.withOpacity(0.15),
      onSelected: (_) {
        setState(() {
          _selectedType = type;
        });
      },
    );
  }

  Widget _buildMediaPlaceholder() {
    String title;
    String subtitle;

    switch (_selectedType) {
      case PostType.singlePhoto:
        title = 'Fotoğraf Seç (Yer Tutucu)';
        subtitle = 'Şimdilik sadece taslak alan; ileride gerçek seçim gelecek.';
        break;
      case PostType.beforeAfter:
        final limit = _beforeAfterLimit(widget.tier);
        title = 'Öncesi / Sonrası Fotoğraf(lar)';
        if (widget.tier == UstaTier.sponsor) {
          subtitle =
          'Sponsor pakette öncesi / sonrası gönderi sınırı yok. İstediğin kadar ekleyebilirsin.';
        } else {
          subtitle =
          'Maksimum $limit öncesi / sonrası gönderisi ekleyebilirsin (paket limitin).';
        }
        break;
      case PostType.shortVideo:
        title = 'Kısa Video (Yer Tutucu)';
        subtitle =
        'İlk sürümde sadece görsel alan; video yükleme altyapısı 2. fazda gelecek.';
        break;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
        color: Colors.grey.shade100,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.image_outlined, size: 40),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryField() {
    // Şimdilik dummy kategori listesi – backend gelince dolduracağız
    const categories = <String>[
      'Genel',
      'Boya & Dekorasyon',
      'Marangoz',
      'Elektrik',
      'Tesisat',
    ];

    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        labelText: 'Meslek / Kategori',
        border: OutlineInputBorder(),
      ),
      value: _selectedCategory,
      items: categories
          .map((c) => DropdownMenuItem<String>(
        value: c,
        child: Text(c),
      ))
          .toList(),
      onChanged: (value) {
        setState(() {
          _selectedCategory = value;
        });
      },
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      controller: _descriptionController,
      maxLines: 4,
      decoration: const InputDecoration(
        labelText: 'Açıklama',
        alignLabelWithHint: true,
        hintText:
        'Bu işi nasıl yaptığını, müşterinin isteğini ve sonucu kısaca anlat...',
        border: OutlineInputBorder(),
      ),
    );
  }

  void _onSubmit() {
    // Şimdilik sadece debug için basit bir print ve geri dönüş.
    // Sonra backend bağlanınca buraya gerçek kayıt işlemi gelecek.
    debugPrint('Gönderi türü: $_selectedType');
    debugPrint('Kategori: $_selectedCategory');
    debugPrint('Açıklama: ${_descriptionController.text}');
    debugPrint('Tier: ${_tierLabel(widget.tier)}');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Gönderi taslak olarak oluşturuldu (mock).'),
      ),
    );

    Navigator.pop(context);
  }
}
