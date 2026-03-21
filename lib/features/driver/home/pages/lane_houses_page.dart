import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/utils/responsive.dart';
import 'driver_voice_record_page.dart';

class LaneHousesPage extends StatefulWidget {
  final String laneName;
  final int totalHouses;

  const LaneHousesPage({super.key, required this.laneName, required this.totalHouses});

  @override
  State<LaneHousesPage> createState() => _LaneHousesPageState();
}

class _LaneHousesPageState extends State<LaneHousesPage> {
  // This Set keeps track of which houses have been marked with an issue.
  final Set<int> _housesWithIssues = {};

  Future<void> _reportIssue(int houseNumber) async {
    // 1. Navigate to the Voice page and WAIT for the result
    final bool? issueConfirmed = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VoiceRecordPage(
          laneName: widget.laneName,
          houseNumber: houseNumber,
        ),
      ),
    );

    // 2. If the driver clicked 'Confirm & Submit', it returns true. 
    // ONLY THEN do we turn the house red.
    if (issueConfirmed == true) {
      setState(() {
        _housesWithIssues.add(houseNumber);
      });
      
      // Optional: Show a quick success snackbar on the grid page!
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Issue reported for House $houseNumber"),
            backgroundColor: AppTheme.accentColor,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBackground,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryBackground,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppTheme.secondaryColor1),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            SizedBox(height: Responsive.h(context, 24)),

            // The Grid of Houses
            Expanded(child: _buildHouseGrid(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Responsive.w(context, 24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.laneName,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(color: AppTheme.textColor, fontSize: Responsive.sp(context, 32)),
          ),
          SizedBox(height: Responsive.h(context, 8)),
          Text(
            "${widget.totalHouses} Houses  •  ${_housesWithIssues.length} Issues",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.textColor.withValues(alpha: 0.7), fontSize: Responsive.sp(context, 16)),
          ),
        ],
      ),
    );
  }

  Widget _buildHouseGrid(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.fromLTRB(
        Responsive.w(context, 24), // left
        Responsive.h(context, 0), // top
        Responsive.w(context, 24), // right
        Responsive.h(context, 48), // bottom
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // 3 columns exactly like your mockup
        crossAxisSpacing: Responsive.w(context, 16),
        mainAxisSpacing: Responsive.h(context, 16),
        childAspectRatio: 1.0, // Perfect squares
      ),
      itemCount: widget.totalHouses,
      itemBuilder: (context, index) {
        final int houseNumber = index + 1;
        final bool hasIssue = _housesWithIssues.contains(houseNumber);

        return GestureDetector(
          onTap: () => _reportIssue(houseNumber),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              // Green if normal, Red if issue reported
              color: hasIssue ? Colors.red.shade500 : AppTheme.accentColor,
              borderRadius: BorderRadius.circular(Responsive.r(context, 20)),
              boxShadow: [BoxShadow(color: (hasIssue ? Colors.red : AppTheme.accentColor).withValues(alpha: 0.2), blurRadius: 8, offset: const Offset(0, 4))],
            ),
            child: Center(
              child: Text(
                "$houseNumber",
                style: Theme.of(context).textTheme.displaySmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w900),
              ),
            ),
          ),
        );
      },
    );
  }
}
