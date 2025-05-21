import 'package:flutter/material.dart';
import 'package:money_manager/l10n/gen/app_localizations.dart';
import 'package:money_manager/models/transaction.dart';
import 'package:money_manager/widgets/edit_tx_sheet.dart';
import 'package:money_manager/utils/category_utils.dart';
import 'package:money_manager/view_models/tx_list_model.dart';
import 'package:provider/provider.dart';

class ManageTransactionSheet extends StatelessWidget {
  final Transaction tx; 

  const ManageTransactionSheet({super.key, required this.tx});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // category info
            CircleAvatar(
              radius: 30,
              backgroundColor: Color(tx.category.colorValue),
              child: Icon(
                tx.category.icon,
                size: 28,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              CategoryUtils.getLocalizedName(context, tx.category.id, tx.category.name),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
                                
            // delete button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                onPressed: () {
                  
                  // dialog with animation
                  showGeneralDialog(
                    context: context,
                    barrierDismissible: true,
                    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
                    barrierColor: Colors.black54,
                    transitionDuration: const Duration(milliseconds: 200),
                    pageBuilder: (context, _, __) => AlertDialog(
                      // add trash icon to the title
                      title: Row(
                        children: [
                          Icon(Icons.delete, color: Colors.grey),
                          SizedBox(width: 8),
                          Text(l10n.delete),
                        ],
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(l10n.confirmDeleteTransaction),                                  
                          Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: Text(
                              l10n.deleteTransaction,
                              style: TextStyle(
                                color: Colors.red.shade700,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(l10n.cancel),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            context.read<TxListModel>().remove(tx.id);
                            Navigator.pop(context);
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.red,
                          ),
                          child: Text(l10n.delete),
                        ),
                      ],
                    ),
                    transitionBuilder: (context, animation, secondaryAnimation, child) {
                      // simple animation fade + scale 
                      return FadeTransition(
                        opacity: animation,
                        child: ScaleTransition(
                          scale: animation,
                          child: child,
                        ),
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(48),
                  // shape: RoundedRectangleBorder(
                  //   borderRadius: BorderRadius.circular(8),
                  // ),
                ),
                child: Text(
                  l10n.delete,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            
            // edit button
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => EditTransactionSheet(category: tx.category, tx: tx),
                  );
                },
                style: TextButton.styleFrom(
                  backgroundColor: Color(tx.category.colorValue).withValues(alpha: 0.8),
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(48),
                ),
                child: Text(
                  l10n.edit,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            
            // cancel
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: TextButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                ),
                child: Text(
                  l10n.cancel,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}