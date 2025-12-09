// lib/features/home/create_job_page.dart
import 'package:flutter/material.dart';

class CreateJobPage extends StatefulWidget {
  const CreateJobPage({super.key});

  @override
  State<CreateJobPage> createState() => _CreateJobPageState();
}

class _CreateJobPageState extends State<CreateJobPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _budgetMinController = TextEditingController();
  final TextEditingController _budgetMaxController = TextEditingController();

  String? _selectedCategory;
  String? _selectedCity;
  String? _selectedDistrict;
  String _selectedUrgency = 'Acil';

  final List<String> _categories = const [
    'Marangoz',
    'Elektrik',
    'Su Tesisatı',
    'Boya & Dekorasyon',
    'İç Mimarlık',
    'Klima / Isıtma',
    'Temizlik',
    'Diğer',
  ];

  final List<String> _cities = const [
    'İstanbul',
    'Ankara',
    'İzmir',
    'Bursa',
    'Adana',
  ];

  final List<String> _districtsSample = const [
    'Merkez',
    'Kadıköy',
    'Çankaya',
    'Karşıyaka',
    'Nilüfer',
  ];

  final List<String> _urgencyOptions = const [
    'Acil',
    'Bugün',
    'Bu hafta içinde',
    'Bu ay içinde',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _budgetMinController.dispose();
    _budgetMaxController.dispose();
    super.dispose();
  }

  void _submitJob() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Normalde burada Job modeli oluşturup backend'e gönderirdik.
    // Şimdilik sadece "başarılı" mesajı veriyoruz.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('İlan oluşturuldu (şimdilik sahte).'),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('İlan / İhale Aç'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'İhtiyacını veya işini tarif et',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Bu ilanı hem profesyoneller hem de hizmet arayanlar kullanabilir. '
                    'Ne istediğini net yazarsan doğru kişilerden daha iyi teklifler alırsın.',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),

              // Başlık
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Başlık',
                  border: OutlineInputBorder(),
                  hintText: 'Ör: 2+1 ev için laminant döşeme',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Lütfen bir başlık yaz.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Açıklama
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Açıklama',
                  border: OutlineInputBorder(),
                  hintText:
                  'İşin detayını, metrekaresini, mevcut durumunu ve özel isteklerini yaz...',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Lütfen bir açıklama yaz.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Kategori
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Meslek / Kategori',
                  border: OutlineInputBorder(),
                ),
                items: _categories
                    .map(
                      (c) => DropdownMenuItem(
                    value: c,
                    child: Text(c),
                  ),
                )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen bir kategori seç.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Şehir ve ilçe
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedCity,
                      decoration: const InputDecoration(
                        labelText: 'İl',
                        border: OutlineInputBorder(),
                      ),
                      items: _cities
                          .map(
                            (c) => DropdownMenuItem(
                          value: c,
                          child: Text(c),
                        ),
                      )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCity = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'İl seç.';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedDistrict,
                      decoration: const InputDecoration(
                        labelText: 'İlçe',
                        border: OutlineInputBorder(),
                      ),
                      items: _districtsSample
                          .map(
                            (d) => DropdownMenuItem(
                          value: d,
                          child: Text(d),
                        ),
                      )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedDistrict = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'İlçe seç.';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Bütçe
              Text(
                'Bütçe (opsiyonel)',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _budgetMinController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Min (₺)',
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _budgetMaxController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Max (₺)',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Zaman / aciliyet
              DropdownButtonFormField<String>(
                value: _selectedUrgency,
                decoration: const InputDecoration(
                  labelText: 'Zaman / Aciliyet',
                  border: OutlineInputBorder(),
                ),
                items: _urgencyOptions
                    .map(
                      (u) => DropdownMenuItem(
                    value: u,
                    child: Text(u),
                  ),
                )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedUrgency = value ?? 'Acil';
                  });
                },
              ),
              const SizedBox(height: 16),

              // Fotoğraf butonu (yer tutucu)
              OutlinedButton.icon(
                onPressed: () {
                  // Şimdilik sadece yer tutucu
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          'Fotoğraf ekleme daha sonra eklenecek (şu an yer tutucu).'),
                    ),
                  );
                },
                icon: const Icon(Icons.photo_outlined),
                label: const Text('Fotoğraf Ekle (Yer Tutucu)'),
              ),
              const SizedBox(height: 24),

              // İlanı aç butonu
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitJob,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'İlanı Aç',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
