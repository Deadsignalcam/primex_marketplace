import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/primex_job_opportunity.dart';
import '../../services/primex_jobs_service.dart';

class JobsServicesPage extends StatefulWidget {
  const JobsServicesPage({super.key});

  @override
  State<JobsServicesPage> createState() => _JobsServicesPageState();
}

class _JobsServicesPageState extends State<JobsServicesPage> {
  final TextEditingController _searchController = TextEditingController();

  String _selectedType = 'all';
  String _selectedEmployment = 'all';
  String _selectedCategory = 'All';
  bool _remoteOnly = false;
  bool _urgentOnly = false;
  bool _sameDayPayOnly = false;
  String _sortMode = 'newest';

  static const List<String> _categories = <String>[
    'All',
    'Property Inspections',
    'Insurance Adjusting',
    'CAT Deployments',
    'Construction',
    'Delivery',
    'Cleaning',
    'Healthcare',
    'Hospitality',
    'Landscaping',
    'Snow Removal',
    'Roofing',
    'Electrical',
    'Plumbing',
    'Painting',
    'Auto Repair',
    'Real Estate',
    'Photography',
    'Administrative',
    'Technology',
    'AI Services',
    'Other',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<PrimeXJobOpportunity> _filter(
    List<PrimeXJobOpportunity> opportunities,
  ) {
    final query = _searchController.text.trim().toLowerCase();

    final filtered = opportunities.where((opportunity) {
      if (_selectedType != 'all' &&
          opportunity.opportunityType != _selectedType) {
        return false;
      }

      if (_selectedEmployment != 'all' &&
          opportunity.employmentType != _selectedEmployment) {
        return false;
      }

      if (_selectedCategory != 'All' &&
          opportunity.category != _selectedCategory) {
        return false;
      }

      if (_remoteOnly && !opportunity.remote) return false;
      if (_urgentOnly && !opportunity.urgent) return false;
      if (_sameDayPayOnly && !opportunity.sameDayPay) return false;

      if (query.isEmpty) return true;

      final searchable = <String>[
        opportunity.title,
        opportunity.companyName,
        opportunity.description,
        opportunity.category,
        opportunity.location,
        opportunity.employmentType,
        opportunity.opportunityType,
        ...opportunity.skills,
      ].join(' ').toLowerCase();

      return searchable.contains(query);
    }).toList();

    switch (_sortMode) {
      case 'highest_pay':
        filtered.sort(
          (a, b) =>
              (b.maxPay ?? b.minPay ?? 0).compareTo(a.maxPay ?? a.minPay ?? 0),
        );
        break;
      case 'most_applied':
        filtered.sort(
          (a, b) => b.applicantCount.compareTo(a.applicantCount),
        );
        break;
      case 'urgent':
        filtered.sort((a, b) {
          if (a.urgent == b.urgent) {
            return b.createdAt.compareTo(a.createdAt);
          }
          return a.urgent ? -1 : 1;
        });
        break;
      default:
        filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }

    return filtered;
  }

  Future<void> _openPostOpportunityDialog() async {
    if (FirebaseAuth.instance.currentUser == null) {
      _message('Please sign in before posting.');
      return;
    }

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const _PostOpportunityDialog(),
    );

    if (result == true && mounted) {
      _message('Opportunity posted to PrimeX Jobs & Services.');
    }
  }

  void _message(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF030A17),
      appBar: AppBar(
        backgroundColor: const Color(0xFF071426),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'PrimeX Jobs & Services',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
            Text(
              'Find work • Hire talent • Book services',
              style: TextStyle(fontSize: 11, color: Colors.white70),
            ),
          ],
        ),
        actions: <Widget>[
          IconButton(
            tooltip: 'Post opportunity',
            onPressed: _openPostOpportunityDialog,
            icon: const Icon(Icons.add_business),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openPostOpportunityDialog,
        icon: const Icon(Icons.add),
        label: const Text('Post'),
      ),
      body: StreamBuilder<List<PrimeXJobOpportunity>>(
        stream: PrimeXJobsService.watchActiveOpportunities(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return _ErrorPanel(
              error: snapshot.error.toString(),
            );
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final filtered = _filter(snapshot.data!);

          return LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth >= 1050;

              if (wide) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      width: 260,
                      child: _FilterPanel(
                        selectedEmployment: _selectedEmployment,
                        selectedCategory: _selectedCategory,
                        remoteOnly: _remoteOnly,
                        urgentOnly: _urgentOnly,
                        sameDayPayOnly: _sameDayPayOnly,
                        categories: _categories,
                        onEmploymentChanged: (value) {
                          setState(() => _selectedEmployment = value);
                        },
                        onCategoryChanged: (value) {
                          setState(() => _selectedCategory = value);
                        },
                        onRemoteChanged: (value) {
                          setState(() => _remoteOnly = value);
                        },
                        onUrgentChanged: (value) {
                          setState(() => _urgentOnly = value);
                        },
                        onSameDayPayChanged: (value) {
                          setState(() => _sameDayPayOnly = value);
                        },
                      ),
                    ),
                    Expanded(
                      child: _MainOpportunityFeed(
                        controller: _searchController,
                        selectedType: _selectedType,
                        sortMode: _sortMode,
                        opportunities: filtered,
                        onSearchChanged: (_) => setState(() {}),
                        onTypeChanged: (value) {
                          setState(() => _selectedType = value);
                        },
                        onSortChanged: (value) {
                          setState(() => _sortMode = value);
                        },
                        onMessage: _message,
                      ),
                    ),
                    SizedBox(
                      width: 245,
                      child: _OpportunityInsightPanel(
                        opportunities: snapshot.data!,
                        onFilter: (filter) {
                          setState(() {
                            if (filter == 'urgent') {
                              _urgentOnly = true;
                              _sortMode = 'urgent';
                            } else if (filter == 'highest_pay') {
                              _sortMode = 'highest_pay';
                            } else if (filter == 'newest') {
                              _sortMode = 'newest';
                            } else if (filter == 'remote') {
                              _remoteOnly = true;
                            }
                          });
                        },
                      ),
                    ),
                  ],
                );
              }

              return _MainOpportunityFeed(
                controller: _searchController,
                selectedType: _selectedType,
                sortMode: _sortMode,
                opportunities: filtered,
                onSearchChanged: (_) => setState(() {}),
                onTypeChanged: (value) {
                  setState(() => _selectedType = value);
                },
                onSortChanged: (value) {
                  setState(() => _sortMode = value);
                },
                onMessage: _message,
                mobileFilter: IconButton(
                  tooltip: 'Filters',
                  onPressed: () {
                    showModalBottomSheet<void>(
                      context: context,
                      backgroundColor: const Color(0xFF071426),
                      isScrollControlled: true,
                      builder: (_) => SafeArea(
                        child: SizedBox(
                          height: MediaQuery.sizeOf(context).height * .75,
                          child: _FilterPanel(
                            selectedEmployment: _selectedEmployment,
                            selectedCategory: _selectedCategory,
                            remoteOnly: _remoteOnly,
                            urgentOnly: _urgentOnly,
                            sameDayPayOnly: _sameDayPayOnly,
                            categories: _categories,
                            onEmploymentChanged: (value) {
                              setState(() => _selectedEmployment = value);
                            },
                            onCategoryChanged: (value) {
                              setState(() => _selectedCategory = value);
                            },
                            onRemoteChanged: (value) {
                              setState(() => _remoteOnly = value);
                            },
                            onUrgentChanged: (value) {
                              setState(() => _urgentOnly = value);
                            },
                            onSameDayPayChanged: (value) {
                              setState(() => _sameDayPayOnly = value);
                            },
                          ),
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.tune),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _MainOpportunityFeed extends StatelessWidget {
  const _MainOpportunityFeed({
    required this.controller,
    required this.selectedType,
    required this.sortMode,
    required this.opportunities,
    required this.onSearchChanged,
    required this.onTypeChanged,
    required this.onSortChanged,
    required this.onMessage,
    this.mobileFilter,
  });

  final TextEditingController controller;
  final String selectedType;
  final String sortMode;
  final List<PrimeXJobOpportunity> opportunities;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onTypeChanged;
  final ValueChanged<String> onSortChanged;
  final ValueChanged<String> onMessage;
  final Widget? mobileFilter;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 8),
          color: const Color(0xFF030A17),
          child: Column(
            children: <Widget>[
              TextField(
                controller: controller,
                onChanged: onSearchChanged,
                decoration: InputDecoration(
                  // PRIMEX_RC4_FORM_LABEL_FIX
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  floatingLabelStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    backgroundColor: Color(0xFF071E33),
                  ),
                  labelStyle: const TextStyle(
                    color: Colors.white70,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    backgroundColor: Color(0xFF071E33),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 21,
                  ),
                  isDense: false,

                  hintText:
                      'Search jobs, gigs, services, skills or companies...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: mobileFilter,
                  filled: true,
                  fillColor: const Color(0xFF0A1930),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Color(0xFF1B8DFF)),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: <Widget>[
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: <Widget>[
                          _TypeChip(
                            label: 'All',
                            value: 'all',
                            selected: selectedType,
                            onSelected: onTypeChanged,
                          ),
                          _TypeChip(
                            label: 'Jobs',
                            value: 'job',
                            selected: selectedType,
                            onSelected: onTypeChanged,
                          ),
                          _TypeChip(
                            label: 'Services',
                            value: 'service',
                            selected: selectedType,
                            onSelected: onTypeChanged,
                          ),
                          _TypeChip(
                            label: 'Gigs',
                            value: 'gig',
                            selected: selectedType,
                            onSelected: onTypeChanged,
                          ),
                        ],
                      ),
                    ),
                  ),
                  DropdownButton<String>(
                    value: sortMode,
                    dropdownColor: const Color(0xFF0A1930),
                    underline: const SizedBox.shrink(),
                    items: const <DropdownMenuItem<String>>[
                      DropdownMenuItem(
                        value: 'newest',
                        child: Text('Newest'),
                      ),
                      DropdownMenuItem(
                        value: 'highest_pay',
                        child: Text('Highest pay'),
                      ),
                      DropdownMenuItem(
                        value: 'most_applied',
                        child: Text('Most applied'),
                      ),
                      DropdownMenuItem(
                        value: 'urgent',
                        child: Text('Urgent'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) onSortChanged(value);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: opportunities.isEmpty
              ? const _EmptyOpportunities()
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(14, 4, 14, 110),
                  itemCount: opportunities.length,
                  itemBuilder: (context, index) {
                    return _OpportunityCard(
                      opportunity: opportunities[index],
                      onMessage: onMessage,
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _OpportunityCard extends StatefulWidget {
  const _OpportunityCard({
    required this.opportunity,
    required this.onMessage,
  });

  final PrimeXJobOpportunity opportunity;
  final ValueChanged<String> onMessage;

  @override
  State<_OpportunityCard> createState() => _OpportunityCardState();
}

class _OpportunityCardState extends State<_OpportunityCard> {
  bool _saved = false;
  bool _busy = false;

  PrimeXJobOpportunity get opportunity => widget.opportunity;

  @override
  void initState() {
    super.initState();
    PrimeXJobsService.recordView(opportunity.id);
    _loadSaved();
  }

  Future<void> _loadSaved() async {
    final saved = await PrimeXJobsService.isSaved(opportunity.id);
    if (mounted) setState(() => _saved = saved);
  }

  Future<void> _toggleSave() async {
    if (_busy) return;

    setState(() => _busy = true);

    try {
      await PrimeXJobsService.saveOpportunity(opportunity.id);
      if (mounted) setState(() => _saved = !_saved);
    } catch (error) {
      widget.onMessage(error.toString());
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _apply() async {
    final noteController = TextEditingController();

    final submit = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Apply for ${opportunity.title}'),
        content: TextField(
          controller: noteController,
          maxLines: 5,
          decoration: const InputDecoration(
            // PRIMEX_RC4_FORM_LABEL_FIX
            floatingLabelBehavior: FloatingLabelBehavior.always,
            floatingLabelStyle: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w700,
              backgroundColor: Color(0xFF071E33),
            ),
            labelStyle: const TextStyle(
              color: Colors.white70,
              fontSize: 15,
              fontWeight: FontWeight.w600,
              backgroundColor: Color(0xFF071E33),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 21,
            ),
            isDense: false,

            labelText: 'Message to employer',
            hintText:
                'Introduce yourself and briefly describe your experience.',
            border: OutlineInputBorder(),
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Submit application'),
          ),
        ],
      ),
    );

    if (submit != true) {
      noteController.dispose();
      return;
    }

    try {
      await PrimeXJobsService.apply(
        opportunity: opportunity,
        note: noteController.text,
      );

      widget.onMessage(
        'Application submitted to ${opportunity.companyName}.',
      );
    } catch (error) {
      widget.onMessage(error.toString());
    } finally {
      noteController.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    final age = DateTime.now().difference(opportunity.createdAt);
    final posted = age.inMinutes < 60
        ? '${age.inMinutes.clamp(1, 59)}m ago'
        : age.inHours < 24
            ? '${age.inHours}h ago'
            : '${age.inDays}d ago';

    return Card(
      color: const Color(0xFF08172C),
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(
          color: opportunity.urgent
              ? Colors.orangeAccent.withValues(alpha: .7)
              : const Color(0xFF154579),
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          showDialog<void>(
            context: context,
            builder: (_) => _OpportunityDetailsDialog(
              opportunity: opportunity,
              onApply: _apply,
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CircleAvatar(
                    radius: 27,
                    backgroundColor: const Color(0xFF102A4D),
                    backgroundImage: opportunity.companyLogoUrl.isNotEmpty
                        ? NetworkImage(opportunity.companyLogoUrl)
                        : null,
                    child: opportunity.companyLogoUrl.isEmpty
                        ? const Icon(Icons.business, color: Colors.cyanAccent)
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          opportunity.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Row(
                          children: <Widget>[
                            Flexible(
                              child: Text(
                                opportunity.companyName,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            if (opportunity.verified) ...<Widget>[
                              const SizedBox(width: 5),
                              const Icon(
                                Icons.verified,
                                size: 17,
                                color: Colors.lightBlueAccent,
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: _saved ? 'Remove saved job' : 'Save',
                    onPressed: _busy ? null : _toggleSave,
                    icon: Icon(
                      _saved ? Icons.bookmark : Icons.bookmark_border,
                      color: _saved ? Colors.amberAccent : Colors.white70,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 7,
                runSpacing: 7,
                children: <Widget>[
                  _InfoBadge(
                    icon: Icons.payments_outlined,
                    label: opportunity.payLabel,
                  ),
                  _InfoBadge(
                    icon: Icons.location_on_outlined,
                    label: opportunity.remote
                        ? 'Remote'
                        : opportunity.hybrid
                            ? 'Hybrid • ${opportunity.location}'
                            : opportunity.location,
                  ),
                  _InfoBadge(
                    icon: Icons.work_outline,
                    label: opportunity.employmentType
                        .replaceAll('_', ' ')
                        .toUpperCase(),
                  ),
                  _InfoBadge(
                    icon: opportunity.opportunityType == 'service'
                        ? Icons.handyman
                        : opportunity.opportunityType == 'gig'
                            ? Icons.bolt
                            : Icons.badge_outlined,
                    label: opportunity.opportunityType.toUpperCase(),
                  ),
                  if (opportunity.urgent)
                    const _InfoBadge(
                      icon: Icons.local_fire_department,
                      label: 'URGENT HIRING',
                    ),
                  if (opportunity.sameDayPay)
                    const _InfoBadge(
                      icon: Icons.savings_outlined,
                      label: 'SAME-DAY PAY',
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                opportunity.description.isEmpty
                    ? 'Open this opportunity to view more information.'
                    : opportunity.description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white70,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 13),
              Row(
                children: <Widget>[
                  Text(
                    'Posted $posted',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white54,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Text(
                    '${opportunity.applicantCount} applicants',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white54,
                    ),
                  ),
                  const Spacer(),
                  OutlinedButton.icon(
                    onPressed: () {
                      widget.onMessage(
                        'Employer messaging will open through PrimeX Messages.',
                      );
                    },
                    icon: const Icon(Icons.chat_bubble_outline, size: 17),
                    label: const Text('Message'),
                  ),
                  const SizedBox(width: 7),
                  FilledButton(
                    onPressed: _apply,
                    child: const Text('Apply'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FilterPanel extends StatelessWidget {
  const _FilterPanel({
    required this.selectedEmployment,
    required this.selectedCategory,
    required this.remoteOnly,
    required this.urgentOnly,
    required this.sameDayPayOnly,
    required this.categories,
    required this.onEmploymentChanged,
    required this.onCategoryChanged,
    required this.onRemoteChanged,
    required this.onUrgentChanged,
    required this.onSameDayPayChanged,
  });

  final String selectedEmployment;
  final String selectedCategory;
  final bool remoteOnly;
  final bool urgentOnly;
  final bool sameDayPayOnly;
  final List<String> categories;
  final ValueChanged<String> onEmploymentChanged;
  final ValueChanged<String> onCategoryChanged;
  final ValueChanged<bool> onRemoteChanged;
  final ValueChanged<bool> onUrgentChanged;
  final ValueChanged<bool> onSameDayPayChanged;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF071426),
      child: ListView(
        padding: const EdgeInsets.all(14),
        children: <Widget>[
          const Text(
            'Filters',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 18),
          const Text(
            'Employment type',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            initialValue: selectedEmployment,
            decoration: const InputDecoration(
              // PRIMEX_RC4_FORM_LABEL_FIX
              floatingLabelBehavior: FloatingLabelBehavior.always,
              floatingLabelStyle: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w700,
                backgroundColor: Color(0xFF071E33),
              ),
              labelStyle: const TextStyle(
                color: Colors.white70,
                fontSize: 15,
                fontWeight: FontWeight.w600,
                backgroundColor: Color(0xFF071E33),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 21,
              ),
              isDense: false,

              border: OutlineInputBorder(),
            ),
            dropdownColor: const Color(0xFF0A1930),
            items: const <DropdownMenuItem<String>>[
              DropdownMenuItem(value: 'all', child: Text('All types')),
              DropdownMenuItem(value: 'fulltime', child: Text('Full-time')),
              DropdownMenuItem(value: 'parttime', child: Text('Part-time')),
              DropdownMenuItem(value: 'contract', child: Text('Contract')),
              DropdownMenuItem(value: 'temporary', child: Text('Temporary')),
              DropdownMenuItem(value: 'one_time', child: Text('One-time')),
            ],
            onChanged: (value) {
              if (value != null) onEmploymentChanged(value);
            },
          ),
          const SizedBox(height: 18),
          const Text(
            'Category',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            initialValue: selectedCategory,
            decoration: const InputDecoration(
              // PRIMEX_RC4_FORM_LABEL_FIX
              floatingLabelBehavior: FloatingLabelBehavior.always,
              floatingLabelStyle: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w700,
                backgroundColor: Color(0xFF071E33),
              ),
              labelStyle: const TextStyle(
                color: Colors.white70,
                fontSize: 15,
                fontWeight: FontWeight.w600,
                backgroundColor: Color(0xFF071E33),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 21,
              ),
              isDense: false,

              border: OutlineInputBorder(),
            ),
            dropdownColor: const Color(0xFF0A1930),
            isExpanded: true,
            items: categories
                .map(
                  (category) => DropdownMenuItem<String>(
                    value: category,
                    child: Text(
                      category,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value != null) onCategoryChanged(value);
            },
          ),
          const SizedBox(height: 14),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: remoteOnly,
            onChanged: onRemoteChanged,
            title: const Text('Remote only'),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: urgentOnly,
            onChanged: onUrgentChanged,
            title: const Text('Urgent hiring'),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: sameDayPayOnly,
            onChanged: onSameDayPayChanged,
            title: const Text('Same-day pay'),
          ),
          const Divider(height: 30),
          const Text(
            'Inspector & Adjuster Opportunities',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          const Text(
            'Property inspections, loss control, field adjusting, CAT deployment, roof inspections, occupancy inspections and disaster response.',
            style: TextStyle(color: Colors.white60, height: 1.35),
          ),
        ],
      ),
    );
  }
}

class _OpportunityInsightPanel extends StatelessWidget {
  const _OpportunityInsightPanel({
    required this.opportunities,
    required this.onFilter,
  });

  final List<PrimeXJobOpportunity> opportunities;
  final ValueChanged<String> onFilter;

  @override
  Widget build(BuildContext context) {
    final urgent = opportunities.where((item) => item.urgent).length;
    final remote = opportunities.where((item) => item.remote).length;
    final verified = opportunities.where((item) => item.verified).length;

    return Material(
      color: const Color(0xFF071426),
      child: ListView(
        padding: const EdgeInsets.all(14),
        children: <Widget>[
          const Text(
            'Opportunity Center',
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 14),
          _InsightTile(
            icon: Icons.local_fire_department,
            title: 'Urgent Hiring',
            value: '$urgent available',
            onTap: () => onFilter('urgent'),
          ),
          _InsightTile(
            icon: Icons.payments,
            title: 'Highest Paying',
            value: 'View top pay',
            onTap: () => onFilter('highest_pay'),
          ),
          _InsightTile(
            icon: Icons.new_releases,
            title: 'New Opportunities',
            value: '${opportunities.length} listed',
            onTap: () => onFilter('newest'),
          ),
          _InsightTile(
            icon: Icons.home_work,
            title: 'Remote Work',
            value: '$remote available',
            onTap: () => onFilter('remote'),
          ),
          _InsightTile(
            icon: Icons.verified,
            title: 'Verified Companies',
            value: '$verified verified',
            onTap: () {},
          ),
          const SizedBox(height: 18),
          const Card(
            color: Color(0xFF0B2444),
            child: Padding(
              padding: EdgeInsets.all(14),
              child: Column(
                children: <Widget>[
                  Icon(
                    Icons.auto_awesome,
                    color: Colors.cyanAccent,
                    size: 30,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'PrimeX AI Matching',
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Candidate matching based on experience, skills, certifications, location and availability.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: 12,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PostOpportunityDialog extends StatefulWidget {
  const _PostOpportunityDialog();

  @override
  State<_PostOpportunityDialog> createState() => _PostOpportunityDialogState();
}

class _PostOpportunityDialogState extends State<_PostOpportunityDialog> {
  final _formKey = GlobalKey<FormState>();

  final _title = TextEditingController();
  final _company = TextEditingController();
  final _description = TextEditingController();
  final _location = TextEditingController();
  final _minPay = TextEditingController();
  final _maxPay = TextEditingController();
  final _skills = TextEditingController();

  String _opportunityType = 'job';
  String _employmentType = 'contract';
  String _payType = 'hourly';
  String _category = 'Property Inspections';

  bool _remote = false;
  bool _hybrid = false;
  bool _urgent = false;
  bool _sameDayPay = false;
  bool _saving = false;

  @override
  void dispose() {
    _title.dispose();
    _company.dispose();
    _description.dispose();
    _location.dispose();
    _minPay.dispose();
    _maxPay.dispose();
    _skills.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_saving || !_formKey.currentState!.validate()) return;

    setState(() => _saving = true);

    try {
      final user = FirebaseAuth.instance.currentUser!;

      final opportunity = PrimeXJobOpportunity(
        id: '',
        ownerId: user.uid,
        title: _title.text,
        companyName: _company.text,
        description: _description.text,
        category: _category,
        opportunityType: _opportunityType,
        employmentType: _employmentType,
        location: _remote && _location.text.trim().isEmpty
            ? 'Remote'
            : _location.text,
        payType: _payType,
        currency: 'USD',
        minPay: double.tryParse(_minPay.text.trim()),
        maxPay: double.tryParse(_maxPay.text.trim()),
        remote: _remote,
        hybrid: _hybrid,
        urgent: _urgent,
        sameDayPay: _sameDayPay,
        status: 'active',
        skills: _skills.text
            .split(',')
            .map((skill) => skill.trim())
            .where((skill) => skill.isNotEmpty)
            .toList(),
        createdAt: DateTime.now(),
      );

      await PrimeXJobsService.createOpportunity(opportunity);

      if (mounted) Navigator.pop(context, true);
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );

      setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const categories = <String>[
      'Property Inspections',
      'Insurance Adjusting',
      'CAT Deployments',
      'Construction',
      'Delivery',
      'Cleaning',
      'Healthcare',
      'Hospitality',
      'Landscaping',
      'Snow Removal',
      'Roofing',
      'Electrical',
      'Plumbing',
      'Painting',
      'Auto Repair',
      'Real Estate',
      'Photography',
      'Administrative',
      'Technology',
      'AI Services',
      'Other',
    ];

    return AlertDialog(
      backgroundColor: const Color(0xFF071426),
      title: const Text('Post a Job, Service or Gig'),
      content: SizedBox(
        width: 650,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: _opportunityType,
                        decoration: const InputDecoration(
                          // PRIMEX_RC4_FORM_LABEL_FIX
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          floatingLabelStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            backgroundColor: Color(0xFF071E33),
                          ),
                          labelStyle: const TextStyle(
                            color: Colors.white70,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            backgroundColor: Color(0xFF071E33),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 21,
                          ),
                          isDense: false,

                          labelText: 'Opportunity type',
                          border: OutlineInputBorder(),
                        ),
                        items: const <DropdownMenuItem<String>>[
                          DropdownMenuItem(
                            value: 'job',
                            child: Text('Job'),
                          ),
                          DropdownMenuItem(
                            value: 'service',
                            child: Text('Service'),
                          ),
                          DropdownMenuItem(
                            value: 'gig',
                            child: Text('Gig'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _opportunityType = value);
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: _employmentType,
                        decoration: const InputDecoration(
                          // PRIMEX_RC4_FORM_LABEL_FIX
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          floatingLabelStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            backgroundColor: Color(0xFF071E33),
                          ),
                          labelStyle: const TextStyle(
                            color: Colors.white70,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            backgroundColor: Color(0xFF071E33),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 21,
                          ),
                          isDense: false,

                          labelText: 'Employment type',
                          border: OutlineInputBorder(),
                        ),
                        items: const <DropdownMenuItem<String>>[
                          DropdownMenuItem(
                            value: 'fulltime',
                            child: Text('Full-time'),
                          ),
                          DropdownMenuItem(
                            value: 'parttime',
                            child: Text('Part-time'),
                          ),
                          DropdownMenuItem(
                            value: 'contract',
                            child: Text('Contract'),
                          ),
                          DropdownMenuItem(
                            value: 'temporary',
                            child: Text('Temporary'),
                          ),
                          DropdownMenuItem(
                            value: 'one_time',
                            child: Text('One-time'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _employmentType = value);
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _title,
                  decoration: const InputDecoration(
                    // PRIMEX_RC4_FORM_LABEL_FIX
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    floatingLabelStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      backgroundColor: Color(0xFF071E33),
                    ),
                    labelStyle: const TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      backgroundColor: Color(0xFF071E33),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 21,
                    ),
                    isDense: false,

                    labelText: 'Job or service title',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.trim().length < 3
                      ? 'Enter a valid title.'
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _company,
                  decoration: const InputDecoration(
                    // PRIMEX_RC4_FORM_LABEL_FIX
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    floatingLabelStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      backgroundColor: Color(0xFF071E33),
                    ),
                    labelStyle: const TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      backgroundColor: Color(0xFF071E33),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 21,
                    ),
                    isDense: false,

                    labelText: 'Company or business name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.trim().length < 2
                      ? 'Enter the employer or business name.'
                      : null,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _category,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    // PRIMEX_RC4_FORM_LABEL_FIX
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    floatingLabelStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      backgroundColor: Color(0xFF071E33),
                    ),
                    labelStyle: const TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      backgroundColor: Color(0xFF071E33),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 21,
                    ),
                    isDense: false,

                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                  items: categories
                      .map(
                        (category) => DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) setState(() => _category = value);
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _location,
                  decoration: const InputDecoration(
                    // PRIMEX_RC4_FORM_LABEL_FIX
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    floatingLabelStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      backgroundColor: Color(0xFF071E33),
                    ),
                    labelStyle: const TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      backgroundColor: Color(0xFF071E33),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 21,
                    ),
                    isDense: false,

                    labelText: 'Location',
                    hintText: 'City, State or service area',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (_remote) return null;

                    return value == null || value.trim().length < 2
                        ? 'Enter a location or select Remote.'
                        : null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _description,
                  minLines: 4,
                  maxLines: 7,
                  decoration: const InputDecoration(
                    // PRIMEX_RC4_FORM_LABEL_FIX
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    floatingLabelStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      backgroundColor: Color(0xFF071E33),
                    ),
                    labelStyle: const TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      backgroundColor: Color(0xFF071E33),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 21,
                    ),
                    isDense: false,

                    labelText: 'Description',
                    hintText:
                        'Describe responsibilities, schedule, experience and requirements.',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value == null || value.trim().length < 20
                          ? 'Add at least 20 characters.'
                          : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _skills,
                  decoration: const InputDecoration(
                    // PRIMEX_RC4_FORM_LABEL_FIX
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    floatingLabelStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      backgroundColor: Color(0xFF071E33),
                    ),
                    labelStyle: const TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      backgroundColor: Color(0xFF071E33),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 21,
                    ),
                    isDense: false,

                    labelText: 'Skills',
                    hintText:
                        'Inspection, Xactimate, roofing, customer service',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: _payType,
                        decoration: const InputDecoration(
                          // PRIMEX_RC4_FORM_LABEL_FIX
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          floatingLabelStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            backgroundColor: Color(0xFF071E33),
                          ),
                          labelStyle: const TextStyle(
                            color: Colors.white70,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            backgroundColor: Color(0xFF071E33),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 21,
                          ),
                          isDense: false,

                          labelText: 'Pay type',
                          border: OutlineInputBorder(),
                        ),
                        items: const <DropdownMenuItem<String>>[
                          DropdownMenuItem(
                            value: 'hourly',
                            child: Text('Hourly'),
                          ),
                          DropdownMenuItem(
                            value: 'salary',
                            child: Text('Salary'),
                          ),
                          DropdownMenuItem(
                            value: 'fixed',
                            child: Text('Fixed amount'),
                          ),
                          DropdownMenuItem(
                            value: 'commission',
                            child: Text('Commission'),
                          ),
                          DropdownMenuItem(
                            value: 'negotiable',
                            child: Text('Negotiable'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _payType = value);
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        controller: _minPay,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        decoration: const InputDecoration(
                          // PRIMEX_RC4_FORM_LABEL_FIX
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          floatingLabelStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            backgroundColor: Color(0xFF071E33),
                          ),
                          labelStyle: const TextStyle(
                            color: Colors.white70,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            backgroundColor: Color(0xFF071E33),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 21,
                          ),
                          isDense: false,

                          labelText: 'Minimum pay',
                          prefixText: r'$',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        controller: _maxPay,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        decoration: const InputDecoration(
                          // PRIMEX_RC4_FORM_LABEL_FIX
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          floatingLabelStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            backgroundColor: Color(0xFF071E33),
                          ),
                          labelStyle: const TextStyle(
                            color: Colors.white70,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            backgroundColor: Color(0xFF071E33),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 21,
                          ),
                          isDense: false,

                          labelText: 'Maximum pay',
                          prefixText: r'$',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 12,
                  children: <Widget>[
                    FilterChip(
                      label: const Text('Remote'),
                      selected: _remote,
                      onSelected: (value) {
                        setState(() {
                          _remote = value;
                          if (value) _hybrid = false;
                        });
                      },
                    ),
                    FilterChip(
                      label: const Text('Hybrid'),
                      selected: _hybrid,
                      onSelected: (value) {
                        setState(() {
                          _hybrid = value;
                          if (value) _remote = false;
                        });
                      },
                    ),
                    FilterChip(
                      label: const Text('Urgent hiring'),
                      selected: _urgent,
                      onSelected: (value) {
                        setState(() => _urgent = value);
                      },
                    ),
                    FilterChip(
                      label: const Text('Same-day pay'),
                      selected: _sameDayPay,
                      onSelected: (value) {
                        setState(() => _sameDayPay = value);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: _saving ? null : () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        FilledButton.icon(
          onPressed: _saving ? null : _submit,
          icon: _saving
              ? const SizedBox.square(
                  dimension: 17,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.publish),
          label: Text(_saving ? 'Posting...' : 'Post opportunity'),
        ),
      ],
    );
  }
}

class _OpportunityDetailsDialog extends StatelessWidget {
  const _OpportunityDetailsDialog({
    required this.opportunity,
    required this.onApply,
  });

  final PrimeXJobOpportunity opportunity;
  final VoidCallback onApply;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF071426),
      title: Text(opportunity.title),
      content: SizedBox(
        width: 650,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                opportunity.companyName,
                style: const TextStyle(
                  color: Colors.lightBlueAccent,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: <Widget>[
                  _InfoBadge(
                    icon: Icons.payments,
                    label: opportunity.payLabel,
                  ),
                  _InfoBadge(
                    icon: Icons.location_on,
                    label: opportunity.location,
                  ),
                  _InfoBadge(
                    icon: Icons.work,
                    label: opportunity.employmentType,
                  ),
                  _InfoBadge(
                    icon: Icons.category,
                    label: opportunity.category,
                  ),
                ],
              ),
              const SizedBox(height: 18),
              const Text(
                'Opportunity Description',
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 7),
              Text(
                opportunity.description,
                style: const TextStyle(height: 1.45),
              ),
              if (opportunity.skills.isNotEmpty) ...<Widget>[
                const SizedBox(height: 18),
                const Text(
                  'Skills',
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 7),
                Wrap(
                  spacing: 7,
                  runSpacing: 7,
                  children: opportunity.skills
                      .map((skill) => Chip(label: Text(skill)))
                      .toList(),
                ),
              ],
              if (opportunity.requirements.isNotEmpty) ...<Widget>[
                const SizedBox(height: 18),
                const Text(
                  'Requirements',
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 7),
                ...opportunity.requirements.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Text('• $item'),
                  ),
                ),
              ],
              if (opportunity.benefits.isNotEmpty) ...<Widget>[
                const SizedBox(height: 18),
                const Text(
                  'Benefits',
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 7),
                ...opportunity.benefits.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Text('• $item'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
        FilledButton.icon(
          onPressed: () {
            Navigator.pop(context);
            onApply();
          },
          icon: const Icon(Icons.send),
          label: const Text('Apply'),
        ),
      ],
    );
  }
}

class _TypeChip extends StatelessWidget {
  const _TypeChip({
    required this.label,
    required this.value,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final String value;
  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 7),
      child: ChoiceChip(
        label: Text(label),
        selected: selected == value,
        onSelected: (_) => onSelected(value),
      ),
    );
  }
}

class _InfoBadge extends StatelessWidget {
  const _InfoBadge({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF102B4F),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF1D5D96)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 15, color: Colors.cyanAccent),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InsightTile extends StatelessWidget {
  const _InsightTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: const Color(0xFF102A4D),
        child: Icon(icon, color: Colors.cyanAccent),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w800),
      ),
      subtitle: Text(value),
      trailing: const Icon(Icons.chevron_right),
    );
  }
}

class _EmptyOpportunities extends StatelessWidget {
  const _EmptyOpportunities();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.work_outline,
              size: 62,
              color: Colors.white38,
            ),
            SizedBox(height: 12),
            Text(
              'No matching opportunities',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(height: 6),
            Text(
              'Change your filters or post the first opportunity.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white60),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorPanel extends StatelessWidget {
  const _ErrorPanel({required this.error});

  final String error;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(24),
        color: const Color(0xFF32131A),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SelectableText(
            'PrimeX Jobs & Services could not load.\n\n$error\n\n'
            'Check that Firestore allows signed-in users to read '
            'the jobs_services collection.',
          ),
        ),
      ),
    );
  }
}
