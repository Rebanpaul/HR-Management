import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';

// ─── Leave & Attendance Screen (4 Tabs) ─────────────────────────
class LeaveAdminScreen extends StatefulWidget {
  const LeaveAdminScreen({super.key});
  @override
  State<LeaveAdminScreen> createState() => _LeaveAdminScreenState();
}

class _LeaveAdminScreenState extends State<LeaveAdminScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }
  @override
  void dispose() { _tabController.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: AppColors.surface,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              LayoutBuilder(
                builder: (context, constraints) {
                  final isMobile = MediaQuery.of(context).size.width < 900;
                  final headerRow = [
                    Expanded(
                      flex: isMobile ? 0 : 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start, 
                        children: [
                          Text('Leave & Attendance', style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.navyDeep, letterSpacing: -0.5)),
                          Text('Track time-off requests and workforce presence', style: GoogleFonts.inter(fontSize: 13, color: AppColors.slateGray)),
                        ]
                      ),
                    ),
                    if (isMobile) const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(color: AppColors.red.withOpacity(0.08), borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.red.withOpacity(0.2))),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.pending_actions_rounded, size: 16, color: AppColors.red),
                          const SizedBox(width: 8),
                          Text('3 pending leave approvals', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.red)),
                        ],
                      ),
                    ),
                  ];
                  return isMobile ? Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: headerRow) : Row(children: headerRow);
                }
              ),
              const SizedBox(height: 20),
              TabBar(
                controller: _tabController,
                isScrollable: false,
                labelStyle: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600),
                unselectedLabelStyle: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500),
                labelColor: AppColors.actionBlue,
                unselectedLabelColor: AppColors.slateGray,
                indicatorColor: AppColors.actionBlue,
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: AppColors.border,
                tabs: const [
                  Tab(text: 'Main'),
                  Tab(text: 'Information'),
                  Tab(text: 'Admin'),
                  Tab(text: 'Setup'),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: const [
              _LeaveMainTab(),
              _LeaveInfoTab(),
              _LeaveAdminTab(),
              _LeaveSetupTab(),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── Main Tab — Who Is In ────────────────────────────────────────
class _LeaveMainTab extends StatelessWidget {
  const _LeaveMainTab();

  final _present = const ['John Smith', 'Aisha Williams', 'Marcus Kim', 'Sara Patel', 'Tom Richards'];
  final _onLeave = const ['Rachel Brown', 'Lily Nguyen'];
  final _absent = const ['David Wilson'];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stats Row
          LayoutBuilder(
            builder: (context, constraints) {
              final isMobile = constraints.maxWidth < 800;
              final stats = [
                const _LeaveStatCard(label: 'Present Today', value: '5', color: AppColors.green, icon: Icons.check_circle_outline_rounded),
                const _LeaveStatCard(label: 'On Leave', value: '2', color: AppColors.amber, icon: Icons.event_busy_rounded),
                const _LeaveStatCard(label: 'Absent', value: '1', color: AppColors.red, icon: Icons.cancel_outlined),
                const _LeaveStatCard(label: 'Total Strength', value: '8', color: AppColors.slateGray, icon: Icons.people_alt_outlined),
              ];

              if (isMobile) {
                return Column(
                  children: [
                    Row(children: [Expanded(child: stats[0]), const SizedBox(width: 12), Expanded(child: stats[1])]),
                    const SizedBox(height: 12),
                    Row(children: [Expanded(child: stats[2]), const SizedBox(width: 12), Expanded(child: stats[3])]),
                  ],
                );
              }

              return Row(children: [
                Expanded(child: stats[0]), const SizedBox(width: 16),
                Expanded(child: stats[1]), const SizedBox(width: 16),
                Expanded(child: stats[2]), const SizedBox(width: 16),
                Expanded(child: stats[3]),
              ]);
            }
          ),
          const SizedBox(height: 24),
          // Who Is In Widget
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Container(width: 10, height: 10, decoration: const BoxDecoration(color: AppColors.green, shape: BoxShape.circle)),
                  const SizedBox(width: 8),
                  Text('Live: Who Is In', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.navyDeep)),
                  const SizedBox(width: 8),
                  Text('Updated just now', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted)),
                ]),
                const SizedBox(height: 20),
                _PresenceGroup('🟢  Present', _present, AppColors.green),
                const Divider(height: 28, color: AppColors.borderSubtle),
                _PresenceGroup('🟡  On Leave', _onLeave, AppColors.amber),
                const Divider(height: 28, color: AppColors.borderSubtle),
                _PresenceGroup('🔴  Absent', _absent, AppColors.red),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Leave Balance Summary
          Text('Leave Balance Summary', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.navyDeep)),
          const SizedBox(height: 12),
          Row(children: const [
            Expanded(child: _BalanceCard(type: 'Annual Leave', used: 5, total: 18, color: AppColors.actionBlue)),
            SizedBox(width: 16),
            Expanded(child: _BalanceCard(type: 'Sick Leave', used: 1, total: 10, color: AppColors.red)),
            SizedBox(width: 16),
            Expanded(child: _BalanceCard(type: 'Casual Leave', used: 2, total: 6, color: AppColors.amber)),
          ]),
        ],
      ),
    );
  }
}

class _PresenceGroup extends StatelessWidget {
  final String label;
  final List<String> names;
  final Color color;
  const _PresenceGroup(this.label, this.names, this.color);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.navyDeep)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: names.map((n) {
            final initials = n.split(' ').map((w) => w[0]).take(2).join();
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(radius: 16, backgroundColor: color.withOpacity(0.12), child: Text(initials, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: color))),
                const SizedBox(width: 8),
                Text(n, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.navyDeep)),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _LeaveStatCard extends StatelessWidget {
  final String label, value;
  final Color color;
  final IconData icon;
  const _LeaveStatCard({required this.label, required this.value, required this.color, required this.icon});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Icon(icon, size: 22, color: color),
      const SizedBox(height: 12),
      Text(value, style: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.w800, color: color, letterSpacing: -0.5)),
      const SizedBox(height: 4),
      Text(label, style: GoogleFonts.inter(fontSize: 12, color: AppColors.slateGray)),
    ]),
  );
}

class _BalanceCard extends StatelessWidget {
  final String type;
  final int used, total;
  final Color color;
  const _BalanceCard({required this.type, required this.used, required this.total, required this.color});
  @override
  Widget build(BuildContext context) {
    final remaining = total - used;
    final pct = used / total;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(type, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.navyDeep)),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(value: pct, color: color, backgroundColor: color.withOpacity(0.1), minHeight: 6),
            ),
          ),
          const SizedBox(width: 12),
          Text('$remaining left', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: color)),
        ]),
        const SizedBox(height: 6),
        Text('$used used out of $total days', style: GoogleFonts.inter(fontSize: 11, color: AppColors.slateGray)),
      ]),
    );
  }
}

// ─── Information Tab ─────────────────────────────────────────────
class _LeaveInfoTab extends StatelessWidget {
  const _LeaveInfoTab();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Leave History by Employee', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.navyDeep)),
        const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              width: MediaQuery.of(context).size.width < 900 ? 900 : (MediaQuery.of(context).size.width - 300).clamp(900, 2000).toDouble(),
              decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
              child: Column(children: [
                _LeaveInfoHead(),
                ..._leaveHistory.map((l) => _LeaveHistoryRow(data: l)),
              ]),
            ),
          ),
      ]),
    );
  }

  static final _leaveHistory = [
    ('John Smith', 'Annual Leave', 'Mar 5–7', '3 days', 'Approved'),
    ('Rachel Brown', 'Sick Leave', 'Mar 20–21', '2 days', 'Approved'),
    ('Lily Nguyen', 'Casual Leave', 'Mar 25', '1 day', 'Pending'),
    ('Marcus Kim', 'Annual Leave', 'Apr 1–3', '3 days', 'Pending'),
    ('Aisha Williams', 'Comp Off', 'Mar 15', '1 day', 'Approved'),
  ];
}

class _LeaveInfoHead extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    decoration: const BoxDecoration(color: AppColors.bgLight, borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)), border: Border(bottom: BorderSide(color: AppColors.border))),
    child: Row(children: const [
      Expanded(child: _H('Employee'), flex: 2),
      Expanded(child: _H('Type'), flex: 2),
      Expanded(child: _H('Dates'), flex: 2),
      Expanded(child: _H('Duration')),
      Expanded(child: _H('Status')),
    ]),
  );
}

class _H extends StatelessWidget {
  final String t; const _H(this.t);
  @override
  Widget build(BuildContext context) => Text(t, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.slateGray, letterSpacing: 0.4));
}

class _LeaveHistoryRow extends StatelessWidget {
  final (String, String, String, String, String) data;
  const _LeaveHistoryRow({required this.data});
  @override
  Widget build(BuildContext context) {
    final statusColor = data.$5 == 'Approved' ? AppColors.green : AppColors.amber;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.borderSubtle))),
      child: Row(children: [
        Expanded(flex: 2, child: Text(data.$1, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.navyDeep))),
        Expanded(flex: 2, child: Text(data.$2, style: GoogleFonts.inter(fontSize: 13, color: AppColors.slateGray))),
        Expanded(flex: 2, child: Text(data.$3, style: GoogleFonts.inter(fontSize: 13, color: AppColors.navyDeep))),
        Expanded(child: Text(data.$4, style: GoogleFonts.inter(fontSize: 13, color: AppColors.navyDeep))),
        Expanded(child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
          child: Text(data.$5, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: statusColor)),
        )),
      ]),
    );
  }
}

// ─── Admin Tab — Approve/Reject ───────────────────────────────────
class _LeaveAdminTab extends StatefulWidget {
  const _LeaveAdminTab();
  @override
  State<_LeaveAdminTab> createState() => _LeaveAdminTabState();
}

class _LeaveAdminTabState extends State<_LeaveAdminTab> {
  final _requests = [
    ['Lily Nguyen', 'Casual Leave', 'Mar 25', '1 day', 'Pending'],
    ['Marcus Kim', 'Annual Leave', 'Apr 1–3', '3 days', 'Pending'],
    ['Tom Richards', 'Sick Leave', 'Mar 28', '1 day', 'Pending'],
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Text('Pending Leave Requests', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.navyDeep)),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(color: AppColors.red, borderRadius: BorderRadius.circular(10)),
              child: Text('${_requests.length}', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.white)),
            ),
            const Spacer(),
            OutlinedButton.icon(
              onPressed: () {
                setState(() { for (var r in _requests) r[4] = 'Approved'; });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Bulk approved all pending requests!')),
                );
              },
              icon: const Icon(Icons.done_all_rounded, size: 16),
              label: const Text('Bulk Approve'),
              style: OutlinedButton.styleFrom(foregroundColor: AppColors.green, side: const BorderSide(color: AppColors.green), textStyle: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600)),
            ),
          ]),
          const SizedBox(height: 16),
          ..._requests.asMap().entries.map((entry) {
            final i = entry.key;
            final r = entry.value;
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
              child: Row(children: [
                CircleAvatar(radius: 20, backgroundColor: AppColors.actionBlue.withOpacity(0.1), child: Text(r[0].split(' ').map((w) => w[0]).take(2).join(), style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.actionBlue))),
                const SizedBox(width: 16),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(r[0], style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.navyDeep)),
                  const SizedBox(height: 2),
                  Text('${r[1]} • ${r[2]} • ${r[3]}', style: GoogleFonts.inter(fontSize: 12, color: AppColors.slateGray)),
                ])),
                if (r[4] == 'Pending') ...[
                  OutlinedButton(
                    onPressed: () {
                      setState(() => _requests[i][4] = 'Rejected');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Rejected request for ${r[0]}')),
                      );
                    },
                    style: OutlinedButton.styleFrom(foregroundColor: AppColors.red, side: const BorderSide(color: AppColors.red), padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8), textStyle: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600)),
                    child: const Text('Reject'),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: () {
                      setState(() => _requests[i][4] = 'Approved');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Approved request for ${r[0]}')),
                      );
                    },
                    style: FilledButton.styleFrom(backgroundColor: AppColors.green, padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8), textStyle: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600)),
                    child: const Text('Approve'),
                  ),
                ] else
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: (r[4] == 'Approved' ? AppColors.green : AppColors.red).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(r[4], style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: r[4] == 'Approved' ? AppColors.green : AppColors.red)),
                  ),
              ]),
            );
          }),
        ],
      ),
    );
  }
}

// ─── Setup Tab ────────────────────────────────────────────────────
class _LeaveSetupTab extends StatefulWidget {
  const _LeaveSetupTab();
  @override
  State<_LeaveSetupTab> createState() => _LeaveSetupTabState();
}

class _LeaveSetupTabState extends State<_LeaveSetupTab> {
  bool _carryForward = true;
  bool _halfDayLeave = true;
  bool _encashment = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Leave & Attendance Setup', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.navyDeep)),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Policy Config', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.navyDeep)),
            const SizedBox(height: 16),
            _Toggle('Carry Forward Leave', 'Unused leave carries over to next year', _carryForward, (v) => setState(() => _carryForward = v)),
            _Toggle('Half-Day Leave', 'Allow employees to apply for half days', _halfDayLeave, (v) => setState(() => _halfDayLeave = v)),
            _Toggle('Leave Encashment', 'Allow cash payout of unused leaves', _encashment, (v) => setState(() => _encashment = v)),
          ]),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Text('Holiday Calendar 2025', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.navyDeep)),
              const Spacer(),
              TextButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Holiday management portal is now open.')),
                  );
                }, 
                icon: const Icon(Icons.add_rounded, size: 16), 
                label: const Text('Add Holiday'), 
                style: TextButton.styleFrom(foregroundColor: AppColors.actionBlue)
              ),
            ]),
            const SizedBox(height: 12),
            ...[('Jan 26', "Republic Day"), ('Aug 15', "Independence Day"), ('Oct 2', "Gandhi Jayanti"), ('Nov 1', "Kannada Rajyotsava"), ('Dec 25', "Christmas Day")]
              .map((h) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: AppColors.actionBlue.withOpacity(0.08), borderRadius: BorderRadius.circular(6)),
                    child: Text(h.$1, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.actionBlue)),
                  ),
                  const SizedBox(width: 12),
                  Text(h.$2, style: GoogleFonts.inter(fontSize: 13, color: AppColors.navyDeep)),
                ]),
              )),
          ]),
        ),
      ]),
    );
  }
}

class _Toggle extends StatelessWidget {
  final String label, subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  const _Toggle(this.label, this.subtitle, this.value, this.onChanged);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Row(children: [
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.navyDeep)),
        Text(subtitle, style: GoogleFonts.inter(fontSize: 11, color: AppColors.slateGray)),
      ])),
      Switch.adaptive(value: value, onChanged: onChanged, activeColor: AppColors.actionBlue),
    ]),
  );
}
