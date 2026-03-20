import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/employees_provider.dart';
import '../providers/payslips_admin_provider.dart';

class PayrollAdminScreen extends ConsumerWidget {
  const PayrollAdminScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final state = ref.watch(payslipsAdminProvider);

    Future<void> openCreateDialog() async {
      await showDialog(
        context: context,
        builder: (context) => const _CreatePayslipDialog(),
      );
    }

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Payslips',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Create and review employee payslips.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            FilledButton.icon(
              onPressed: state.isLoading ? null : openCreateDialog,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Create'),
            ),
            const SizedBox(width: 10),
            IconButton.filledTonal(
              tooltip: 'Refresh',
              onPressed: state.isLoading
                  ? null
                  : () => ref.read(payslipsAdminProvider.notifier).fetchPayslips(),
              icon: const Icon(Icons.refresh_rounded),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (state.error != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              state.error!,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: colorScheme.error),
            ),
          ),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: state.isLoading
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: CircularProgressIndicator(),
                    ),
                  )
                : state.payslips.isEmpty
                    ? Text(
                        'No payslips found.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: const [
                            DataColumn(label: Text('Period')),
                            DataColumn(label: Text('Employee')),
                            DataColumn(label: Text('Basic')),
                            DataColumn(label: Text('Deductions')),
                            DataColumn(label: Text('Net')),
                          ],
                          rows: state.payslips.map((p) {
                            return DataRow(
                              cells: [
                                DataCell(Text(p.periodFormatted)),
                                DataCell(Text(
                                  p.employeeName == null
                                      ? (p.employeeCode ?? p.employeeId)
                                      : '${p.employeeName} (${p.employeeCode ?? '-'})',
                                )),
                                DataCell(Text(NumberFormat.compactCurrency(
                                  symbol: '',
                                  decimalDigits: 0,
                                ).format(p.basicSalary))),
                                DataCell(Text(NumberFormat.compactCurrency(
                                  symbol: '',
                                  decimalDigits: 0,
                                ).format(p.deductions))),
                                DataCell(Text(NumberFormat.compactCurrency(
                                  symbol: '',
                                  decimalDigits: 0,
                                ).format(p.netSalary))),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
          ),
        ),
      ],
    );
  }
}

class _CreatePayslipDialog extends ConsumerStatefulWidget {
  const _CreatePayslipDialog();

  @override
  ConsumerState<_CreatePayslipDialog> createState() =>
      _CreatePayslipDialogState();
}

class _CreatePayslipDialogState extends ConsumerState<_CreatePayslipDialog> {
  final _formKey = GlobalKey<FormState>();

  String? _employeeId;
  int _month = DateTime.now().month;
  int _year = DateTime.now().year;
  final _basicController = TextEditingController();
  final _deductionsController = TextEditingController(text: '0');
  final _pdfUrlController = TextEditingController();

  @override
  void dispose() {
    _basicController.dispose();
    _deductionsController.dispose();
    _pdfUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final employeesState = ref.watch(employeesProvider);
    final payslipsState = ref.watch(payslipsAdminProvider);

    return AlertDialog(
      title: const Text('Create Payslip'),
      content: SizedBox(
        width: 520,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  initialValue: _employeeId,
                  items: employeesState.employees
                      .map(
                        (e) => DropdownMenuItem(
                          value: e.id,
                          child: Text('${e.fullName} (${e.employeeCode})'),
                        ),
                      )
                      .toList(),
                  onChanged: payslipsState.isLoading ? null : (v) => _employeeId = v,
                  decoration: const InputDecoration(
                    labelText: 'Employee',
                  ),
                  validator: (v) => (v == null || v.isEmpty)
                      ? 'Select an employee'
                      : null,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        initialValue: _month,
                        items: List.generate(12, (i) => i + 1)
                            .map((m) => DropdownMenuItem(
                                  value: m,
                                  child: Text(m.toString().padLeft(2, '0')),
                                ))
                            .toList(),
                        onChanged: payslipsState.isLoading
                            ? null
                            : (v) => _month = v ?? _month,
                        decoration: const InputDecoration(labelText: 'Month'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        initialValue: _year,
                        items: List.generate(6, (i) => DateTime.now().year - i)
                            .map((y) => DropdownMenuItem(
                                  value: y,
                                  child: Text(y.toString()),
                                ))
                            .toList(),
                        onChanged: payslipsState.isLoading
                            ? null
                            : (v) => _year = v ?? _year,
                        decoration: const InputDecoration(labelText: 'Year'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _basicController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Basic Salary'),
                  validator: (v) {
                    final parsed = double.tryParse((v ?? '').trim());
                    if (parsed == null || parsed <= 0) {
                      return 'Enter a valid basic salary';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _deductionsController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Deductions'),
                  validator: (v) {
                    final parsed = double.tryParse((v ?? '').trim());
                    if (parsed == null || parsed < 0) {
                      return 'Enter valid deductions';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _pdfUrlController,
                  decoration: const InputDecoration(
                    labelText: 'PDF URL (optional)',
                  ),
                ),
                if (payslipsState.error != null) ...[
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      payslipsState.error!,
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: colorScheme.error),
                    ),
                  ),
                ]
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: payslipsState.isLoading ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: payslipsState.isLoading
              ? null
              : () async {
                  if (!_formKey.currentState!.validate()) return;

                  final basic = double.parse(_basicController.text.trim());
                  final deductions =
                      double.parse(_deductionsController.text.trim());

                  await ref.read(payslipsAdminProvider.notifier).createPayslip(
                        employeeId: _employeeId!,
                        month: _month,
                        year: _year,
                        basicSalary: basic,
                        deductions: deductions,
                        pdfUrl: _pdfUrlController.text.trim().isEmpty
                            ? null
                            : _pdfUrlController.text.trim(),
                      );

                  if (context.mounted) Navigator.pop(context);
                },
          child: const Text('Create'),
        ),
      ],
    );
  }
}
