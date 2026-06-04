import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales/models/category.dart';
import 'package:sales/models/product.dart';
import 'package:sales/providers/category_provider.dart';
import 'package:sales/providers/product_provider.dart';

class ProductFormScreen extends StatefulWidget {
  final Product? product;

  const ProductFormScreen({super.key, this.product});

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerDescription = TextEditingController();
  TextEditingController controllerPrice = TextEditingController();
  int? selectedCategoryId;

  @override
  void initState() {
    super.initState();
    context.read<CategoryProvider>().loadAll();
    final product = widget.product;
    if (product != null) {
      controllerName.text = product.name;
      controllerDescription.text = product.description;
      controllerPrice.text = product.price.toString();
      selectedCategoryId = product.category.id;
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = context.watch<CategoryProvider>().categories;

    if (selectedCategoryId == null && categories.isNotEmpty) {
      selectedCategoryId = categories.first.id;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Formulario de Producto"),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            if (categories.isEmpty)
              const CircularProgressIndicator()
            else
              DropdownButton<int>(
                value: selectedCategoryId,
                isExpanded: true,
                items: categories
                    .map((cat) => DropdownMenuItem<int>(
                  value: cat.id,
                  child: Text(cat.name),
                ))
                    .toList(),
                onChanged: (id) => setState(() {
                  selectedCategoryId = id;
                }),
              ),
            const SizedBox(height: 10),
            TextField(
              controller: controllerName,
              decoration: const InputDecoration(
                labelText: "Nombre",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: controllerPrice,
              decoration: const InputDecoration(
                labelText: "Precio",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: controllerDescription,
              decoration: const InputDecoration(
                labelText: "Descripción",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: selectedCategoryId == null
                  ? null
                  : () async {
                final cat = categories.firstWhere(
                        (c) => c.id == selectedCategoryId);
                if (widget.product == null) {
                  await context.read<ProductProvider>().save(
                    Product(0, controllerName.text,
                        double.parse(controllerPrice.text),
                        controllerDescription.text, cat),
                  );
                } else {
                  await context.read<ProductProvider>().edit(
                    widget.product!.id,
                    Product(
                        widget.product!.id,
                        controllerName.text,
                        double.parse(controllerPrice.text),
                        controllerDescription.text,
                        cat),
                  );
                }
                if (!mounted) return;
                Navigator.pop(context);
              },
              child: Text(widget.product == null ? "Crear" : "Editar"),
            ),
          ],
        ),
      ),
    );
  }
}