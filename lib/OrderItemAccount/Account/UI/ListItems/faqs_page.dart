import 'package:flutter/material.dart';

class FaqsPage extends StatefulWidget {
  const FaqsPage({super.key});

  @override
  State<FaqsPage> createState() => _FaqsPageState();
}

class _FaqsPageState extends State<FaqsPage> {
  final List<Map<String, String>> _faqs = [
    {
      'question': 'How can I sign up with phone number?',
      'answer':
          'To sign up, go to the registration page and enter your phone number. You will receive an OTP to verify your number and complete the sign-up process.'
    },
    {
      'question': 'How to book a cab or ride?',
      'answer':
          'This feature is not available in our application. We are a product delivery service.'
    },
    {
      'question': 'How to order a product?',
      'answer':
          'To place an order for a product seen in a reel, tap on the tagged product link in the reel, add it to your cart, and proceed to checkout.'
    },
    {
      'question': 'How do I place an order for a product seen in a reel?',
      'answer':
          'Simply tap on the product tagged in the reel, which will take you to the product page. From there, you can add it to your cart and check out.'
    },
    {
      'question': 'What payment methods are accepted for purchases?',
      'answer':
          'We accept a variety of payment methods including credit/debit cards, net banking, and major digital wallets.'
    },
    {
      'question': 'How can I track my order status?',
      'answer':
          'You can track the status of your order in the "My Orders" section of your account. You will also receive notifications at each stage of the delivery process.'
    },
    {
      'question': 'How do I follow other users and view their reels?',
      'answer':
          'To follow a user, visit their profile and tap the "Follow" button. Their reels will then appear in your feed.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'FAQs',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        itemCount: _faqs.length,
        itemBuilder: (context, index) {
          return Card(
            color: theme.cardColor,
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ExpansionTile(
              title: Text(
                _faqs[index]['question']!,
                style: theme.textTheme.bodyLarge
                    ?.copyWith(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Text(
                    _faqs[index]['answer']!,
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(fontSize: 14, fontWeight: FontWeight.w400),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
