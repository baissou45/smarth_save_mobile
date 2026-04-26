import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smarth_save/core/utils/theme/colors.dart';
import 'package:smarth_save/providers/account_provider.dart';
import 'package:smarth_save/services/plaid_service.dart';

class PlaidLinkButton extends StatefulWidget {
  final VoidCallback? onSuccess;
  final VoidCallback? onCancel;

  const PlaidLinkButton({
    super.key,
    this.onSuccess,
    this.onCancel,
  });

  @override
  State<PlaidLinkButton> createState() => _PlaidLinkButtonState();
}

class _PlaidLinkButtonState extends State<PlaidLinkButton> {
  final PlaidLinkService _plaidService = PlaidLinkService();
  bool _isLoading = false;

  void _showPlaidLinkDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Lier votre banque'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pour continuer, vous devez lier votre compte bancaire à SmartSave via Plaid.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            const Text(
              'Plaid supporte :',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
            const SizedBox(height: 8),
            _buildBankItem('BNP Paribas'),
            _buildBankItem('Crédit Agricole'),
            _buildBankItem('Société Générale'),
            _buildBankItem('Revolut'),
            _buildBankItem('Wise'),
            _buildBankItem('N26'),
            const SizedBox(height: 16),
            const Text(
              '💡 Conseil : Utilisez vos identifiants bancaires réels pour accéder à vos vraies données (sandbox mode).',
              style: TextStyle(
                fontSize: 12,
                color: kTextSecondary,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton.icon(
            onPressed: _isLoading ? null : _handlePlaidLink,
            icon: _isLoading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.add),
            label: Text(_isLoading ? 'Connexion...' : 'Lier une banque'),
            style: ElevatedButton.styleFrom(
              backgroundColor: kTeal,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBankItem(String bankName) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.check_circle, size: 16, color: kSuccess),
          const SizedBox(width: 8),
          Text(bankName, style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }

  Future<void> _handlePlaidLink() async {
    setState(() => _isLoading = true);

    try {
      // Simule un lien Plaid réussi pour démo
      // En prod, tu ferais appel à Plaid Link réel
      await Future.delayed(const Duration(milliseconds: 500));

      // Simule un public token
      const publicToken = 'public-sandbox-token-demo';

      // Échange le token
      await _plaidService.exchangePublicToken(publicToken);

      if (!mounted) return;

      // Recharge les comptes
      final accountProvider = context.read<AccountProvider>();
      await accountProvider.loadAccountsGroupedByBank();

      // Ferme le dialog et montre un succès
      Navigator.pop(context);
      _showSuccessSnackbar();
      widget.onSuccess?.call();
    } catch (e) {
      if (!mounted) return;
      _showErrorSnackbar(e.toString());
      Navigator.pop(context);
      widget.onCancel?.call();
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showSuccessSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 12),
            Expanded(child: Text('Banque liée avec succès!')),
          ],
        ),
        backgroundColor: kSuccess,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text('Erreur: $message')),
          ],
        ),
        backgroundColor: kDanger,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: _showPlaidLinkDialog,
      icon: const Icon(Icons.add),
      label: const Text('Lier une banque'),
      style: ElevatedButton.styleFrom(
        backgroundColor: kTeal,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}
