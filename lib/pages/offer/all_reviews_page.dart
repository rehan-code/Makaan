// import 'package:flutter/material.dart';
// import 'package:makaan/models/offer.dart';
// import 'package:intl/intl.dart';

// class AllReviewsPage extends StatelessWidget {
//   final List<StoreReview> reviews;
//   final String shopName;

//   const AllReviewsPage({
//     super.key,
//     required this.reviews,
//     required this.shopName,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     return Scaffold(
//       appBar: AppBar(
//         title: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               shopName,
//               style: theme.textTheme.titleMedium?.copyWith(
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             Text(
//               '${reviews.length} Reviews',
//               style: theme.textTheme.bodySmall?.copyWith(
//                 color: theme.colorScheme.onSurface.withOpacity(0.7),
//               ),
//             ),
//           ],
//         ),
//         leading: Container(
//           margin: const EdgeInsets.all(8),
//           decoration: BoxDecoration(
//             color: theme.colorScheme.surface,
//             shape: BoxShape.circle,
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.1),
//                 blurRadius: 8,
//                 offset: const Offset(0, 2),
//               ),
//             ],
//           ),
//           child: IconButton(
//             icon: const Icon(Icons.arrow_back, color: Colors.black87, size: 20),
//             onPressed: () => Navigator.pop(context),
//           ),
//         ),
//       ),
//       body: ListView.separated(
//         padding: const EdgeInsets.all(16),
//         itemCount: reviews.length,
//         separatorBuilder: (context, index) => Divider(
//           height: 32,
//           color: Colors.grey[200],
//         ),
//         itemBuilder: (context, index) {
//           final review = reviews[index];
//           return Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   CircleAvatar(
//                     backgroundImage: NetworkImage(review.userImage),
//                     radius: 20,
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           review.userName,
//                           style: theme.textTheme.bodyLarge?.copyWith(
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         Row(
//                           children: [
//                             ...List.generate(
//                               5,
//                               (index) => Icon(
//                                 index < review.rating
//                                     ? Icons.star
//                                     : Icons.star_border,
//                                 size: 16,
//                                 color: Colors.amber[600],
//                               ),
//                             ),
//                             const SizedBox(width: 8),
//                             Text(
//                               DateFormat('MMM d, yyyy').format(review.date),
//                               style: theme.textTheme.bodySmall?.copyWith(
//                                 color: Colors.grey[600],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 review.comment,
//                 style: theme.textTheme.bodyMedium,
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }
