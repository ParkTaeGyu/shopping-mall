import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../products/domain/product.dart';
import '../../products/data/supabase_product_repository.dart';

class AdminProductEditScreen extends ConsumerStatefulWidget {
  final String? productId;

  const AdminProductEditScreen({super.key, this.productId});

  @override
  ConsumerState<AdminProductEditScreen> createState() => _AdminProductEditScreenState();
}

class _AdminProductEditScreenState extends ConsumerState<AdminProductEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _categoryController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.productId != null) {
      _loadProduct();
    }
  }

  Future<void> _loadProduct() async {
    // You might want to use a provider here, but fetching directly is also fine for edit
    final product = await ref.read(supabaseProductRepositoryProvider).getProduct(widget.productId!);
    if (product != null) {
      _titleController.text = product.title;
      _descriptionController.text = product.description;
      _priceController.text = product.price.toString();
      _imageUrlController.text = product.imageUrl;
      _categoryController.text = product.category;
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final product = Product(
        id: widget.productId ?? '', // ID ignored on insert
        title: _titleController.text,
        description: _descriptionController.text,
        price: double.parse(_priceController.text),
        imageUrl: _imageUrlController.text,
        category: _categoryController.text,
      );

      final repo = ref.read(supabaseProductRepositoryProvider);
      if (widget.productId == null) {
        await repo.addProduct(product);
      } else {
        await repo.updateProduct(product);
      }

      if (mounted) context.pop();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('오류: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.productId == null ? '상품 추가' : '상품 수정')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(labelText: '상품명'),
                      validator: (v) => v!.isEmpty ? '필수 입력' : null,
                    ),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(labelText: '설명'),
                      maxLines: 3,
                    ),
                    TextFormField(
                      controller: _priceController,
                      decoration: const InputDecoration(labelText: '가격'),
                      keyboardType: TextInputType.number,
                      validator: (v) => double.tryParse(v!) == null ? '올바른 숫자를 입력해주세요' : null,
                    ),
                    TextFormField(
                      controller: _imageUrlController,
                      decoration: const InputDecoration(labelText: '이미지 주소'),
                    ),
                    TextFormField(
                      controller: _categoryController,
                      decoration: const InputDecoration(labelText: '카테고리'),
                      validator: (v) => v!.isEmpty ? '필수 입력' : null,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _save,
                      child: const Text('저장'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
