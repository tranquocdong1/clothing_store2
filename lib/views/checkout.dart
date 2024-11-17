import 'package:clothing_store/views/shop_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:clothing_store/views/cart_provider.dart';

class CheckoutPage extends StatefulWidget {
  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  int _currentStep = 0;
  String _selectedPayment = 'Credit Card';
  String _selectedShipping = 'Standard Delivery';

  final _formKey = GlobalKey<FormState>();

  // Form Controllers
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Checkout',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          return Stepper(
            currentStep: _currentStep,
            onStepContinue: () {
              if (_currentStep < 2) {
                setState(() => _currentStep++);
              } else {
                _showOrderConfirmation();
              }
            },
            onStepCancel: () {
              if (_currentStep > 0) {
                setState(() => _currentStep--);
              }
            },
            steps: [
              // Shipping Information Step
              Step(
                title: Text('Shipping Information'),
                content: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: _inputDecoration('Full Name'),
                        validator: (value) =>
                            value!.isEmpty ? 'Please enter your name' : null,
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _phoneController,
                        decoration: _inputDecoration('Phone Number'),
                        keyboardType: TextInputType.phone,
                        validator: (value) => value!.isEmpty
                            ? 'Please enter your phone number'
                            : null,
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _emailController,
                        decoration: _inputDecoration('Email'),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) =>
                            value!.isEmpty ? 'Please enter your email' : null,
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _addressController,
                        decoration: _inputDecoration('Delivery Address'),
                        maxLines: 3,
                        validator: (value) =>
                            value!.isEmpty ? 'Please enter your address' : null,
                      ),
                      SizedBox(height: 16),
                      _buildShippingOptions(),
                    ],
                  ),
                ),
                isActive: _currentStep >= 0,
              ),

              // Payment Step
              Step(
                title: Text('Payment'),
                content: Column(
                  children: [
                    _buildPaymentOptions(),
                    SizedBox(height: 20),
                    if (_selectedPayment == 'Credit Card') ...[
                      TextFormField(
                        controller: _cardNumberController,
                        decoration: _inputDecoration('Card Number'),
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _expiryController,
                              decoration: _inputDecoration('MM/YY'),
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _cvvController,
                              decoration: _inputDecoration('CVV'),
                              obscureText: true,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
                isActive: _currentStep >= 1,
              ),

              // Order Summary Step
              Step(
                title: Text('Order Summary'),
                content: Column(
                  children: [
                    // Order Items
                    ...cartProvider.items
                        .map((item) => ListTile(
                              leading: Image.asset(
                                'assets/images/${item.product.imageUrl}',
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                              title: Text(item.product.name),
                              subtitle: Text('Size: ${item.size}'),
                              trailing: Text(
                                'RM ${(item.product.price * item.quantity).toStringAsFixed(2)}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ))
                        .toList(),

                    Divider(thickness: 1),

                    // Price Summary
                    _buildPriceSummaryRow('Subtotal',
                        'RM ${cartProvider.totalAmount.toStringAsFixed(2)}'),
                    _buildPriceSummaryRow('Voucher', '-RM 100.00',
                        isDiscount: true),
                    _buildPriceSummaryRow('Delivery Fee', 'RM 20.00'),
                    Divider(thickness: 1),
                    _buildPriceSummaryRow('Total',
                        'RM ${(cartProvider.totalAmount - 100 + 20).toStringAsFixed(2)}',
                        isBold: true),
                  ],
                ),
                isActive: _currentStep >= 2,
              ),
            ],
          );
        },
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      filled: true,
      fillColor: Colors.grey[50],
    );
  }

  Widget _buildShippingOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Delivery Method',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        SizedBox(height: 8),
        Card(
          child: RadioListTile(
            title: Text('Standard Delivery'),
            subtitle: Text('2-3 Business Days'),
            value: 'Standard Delivery',
            groupValue: _selectedShipping,
            onChanged: (value) =>
                setState(() => _selectedShipping = value.toString()),
          ),
        ),
        Card(
          child: RadioListTile(
            title: Text('Express Delivery'),
            subtitle: Text('Next Day Delivery'),
            value: 'Express Delivery',
            groupValue: _selectedShipping,
            onChanged: (value) =>
                setState(() => _selectedShipping = value.toString()),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment Method',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        SizedBox(height: 8),
        Card(
          child: RadioListTile(
            title: Text('Credit Card'),
            subtitle: Text('Visa, MasterCard, American Express'),
            value: 'Credit Card',
            groupValue: _selectedPayment,
            onChanged: (value) =>
                setState(() => _selectedPayment = value.toString()),
          ),
        ),
        Card(
          child: RadioListTile(
            title: Text('Online Banking'),
            subtitle: Text('Direct bank transfer'),
            value: 'Online Banking',
            groupValue: _selectedPayment,
            onChanged: (value) =>
                setState(() => _selectedPayment = value.toString()),
          ),
        ),
      ],
    );
  }

  Widget _buildPriceSummaryRow(String label, String amount,
      {bool isDiscount = false, bool isBold = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              color: isDiscount ? Colors.green : null,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  void _showOrderConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Order'),
        content: Text('Would you like to place this order?'),
        actions: [
          TextButton(
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: Text(
              'Place Order',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            onPressed: () {
              // Implement order placement logic here
              Navigator.pop(context); // Close dialog
              _showOrderSuccess();
            },
          ),
        ],
      ),
    );
  }

  void _showOrderSuccess() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Order Placed Successfully!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 64,
            ),
            SizedBox(height: 16),
            Text('Thank you for your purchase!'),
            Text('Your order has been confirmed.'),
          ],
        ),
        actions: [
          ElevatedButton(
            child: Text('Continue Shopping',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => ShopView()),
                (route) => false, // Xóa tất cả các route trước đó
              );
            },
          ),
        ],
      ),
    );
  }
}
