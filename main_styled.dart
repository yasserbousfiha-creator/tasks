import 'package:flutter/material.dart';
import 'dart:async';

final ValueNotifier<ThemeMode> globalThemeNotifier = ValueNotifier(ThemeMode.light);

void main() {
  runApp(const MyTasksApp());
}

String getCurrentFormattedDate() {
  final now = DateTime.now();
  final hour = now.hour == 0 ? 12 : (now.hour > 12 ? now.hour - 12 : now.hour);
  final period = now.hour >= 12 ? 'م' : 'ص';
  final minute = now.minute.toString().padLeft(2, '0');
  return '${now.year}/${now.month}/${now.day} - $hour:$minute $period';
}

// ==========================================
// ألوان النظام الكاملة
// ==========================================
class AppColors {
  // وضع نهاري
  static const lightBg         = Color(0xFFF5F7FA);
  static const lightSurface    = Color(0xFFFFFFFF);
  static const lightAppBar     = Color(0xFFFFFFFF);
  static const lightNavBar     = Color(0xFFFFFFFF);
  static const lightText       = Color(0xFF1E3A5F);
  static const lightSubText    = Color(0xFF6B7C93);
  static const lightDivider    = Color(0xFFDDE3EC);
  static const lightCardBorder = Color(0xFFE4EAF2);

  // وضع ليلي — خلفية موحدة، لكل تبويب لونه
  static const darkBg          = Color(0xFF0D1117);
  static const darkSurface     = Color(0xFF161B22);
  static const darkAppBar      = Color(0xFF0D1117);
  static const darkNavBar      = Color(0xFF0D1117);
  static const darkText        = Color(0xFFE6EDF3);
  static const darkSubText     = Color(0xFF8B949E);

  // اللون الأساسي المشترك (كحلي)
  static const primary         = Color(0xFF1E3A5F);
  static const primaryLight    = Color(0xFF2563EB);

  // ألوان التبويبات في الوضع الليلي
  static const tabWork         = Color(0xFF1A56DB); // أزرق نيلي
  static const tabPersonal     = Color(0xFF059669); // أخضر زمردي
  static const tabExpenses     = Color(0xFFBE185D); // وردي/فوشيا
  static const tabNotes        = Color(0xFF7C3AED); // بنفسجي

  // ألوان التبويبات في الوضع النهاري
  static const tabWorkLight     = Color(0xFF1E3A5F);
  static const tabPersonalLight = Color(0xFF065F46);
  static const tabExpensesLight = Color(0xFF9B1C4E);
  static const tabNotesLight    = Color(0xFF5B21B6);
}

final List<Map<String, dynamic>> globalPracticalTasks  = [];
final List<Map<String, dynamic>> globalPersonalTasks   = [];
final List<Map<String, dynamic>> globalPersonalExpenses = [];
final List<Map<String, dynamic>> globalPracticalExpenses = [];
final List<Map<String, dynamic>> globalNotes           = [];
final List<Map<String, dynamic>> globalTrash           = [];

class MyTasksApp extends StatelessWidget {
  const MyTasksApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: globalThemeNotifier,
      builder: (context, currentMode, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'مهامي',
          themeMode: currentMode,
          // ---- وضع نهاري ----
          theme: ThemeData(
            fontFamily: 'Tajawal',
            brightness: Brightness.light,
            primaryColor: AppColors.primaryLight,
            scaffoldBackgroundColor: AppColors.lightBg,
            cardColor: AppColors.lightSurface,
            dividerColor: AppColors.lightDivider,
            appBarTheme: const AppBarTheme(
              backgroundColor: AppColors.lightAppBar,
              foregroundColor: AppColors.lightText,
              elevation: 0,
              centerTitle: true,
              titleTextStyle: TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppColors.lightText,
                letterSpacing: 0.3,
              ),
            ),
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              backgroundColor: AppColors.lightNavBar,
              selectedItemColor: AppColors.primaryLight,
              unselectedItemColor: AppColors.lightSubText,
              elevation: 8,
              selectedLabelStyle: TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.w700, fontSize: 11),
              unselectedLabelStyle: TextStyle(fontFamily: 'Tajawal', fontSize: 10),
            ),
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: AppColors.lightCardBorder.withOpacity(0.5),
              hintStyle: const TextStyle(color: AppColors.lightSubText, fontSize: 13),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
          ),
          // ---- وضع ليلي ----
          darkTheme: ThemeData(
            fontFamily: 'Tajawal',
            brightness: Brightness.dark,
            primaryColor: AppColors.tabWork,
            scaffoldBackgroundColor: AppColors.darkBg,
            cardColor: AppColors.darkSurface,
            dividerColor: const Color(0xFF21262D),
            appBarTheme: const AppBarTheme(
              backgroundColor: AppColors.darkAppBar,
              foregroundColor: AppColors.darkText,
              elevation: 0,
              centerTitle: true,
              titleTextStyle: TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppColors.darkText,
                letterSpacing: 0.3,
              ),
            ),
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              backgroundColor: AppColors.darkNavBar,
              selectedItemColor: AppColors.tabWork,
              unselectedItemColor: AppColors.darkSubText,
              elevation: 8,
              selectedLabelStyle: TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.w700, fontSize: 11),
              unselectedLabelStyle: TextStyle(fontFamily: 'Tajawal', fontSize: 10),
            ),
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: AppColors.darkSurface,
              hintStyle: const TextStyle(color: AppColors.darkSubText, fontSize: 13),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
          ),
          home: const SplashScreen(),
        );
      },
    );
  }
}

// ==========================================
// دالة مساعدة: لون التبويب حسب الوضع
// ==========================================
Color tabColor(int index, bool isDark) {
  if (isDark) {
    return [AppColors.tabWork, AppColors.tabPersonal, AppColors.tabExpenses, AppColors.tabNotes][index];
  } else {
    return [AppColors.tabWorkLight, AppColors.tabPersonalLight, AppColors.tabExpensesLight, AppColors.tabNotesLight][index];
  }
}

// ==========================================
// الشاشة الترحيبية
// ==========================================
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final List<String> quotes = [
    "إن لم تبدأ اليوم، فلن تنتهي غداً. السر يكمن دائماً في البداية.",
    "إنجازك اليوم هو الحجر الأساس لبناء نجاحات الغد العظيمة.",
    "لا تنتظر الظروف المثالية لتنجز، اصنع ظروفك الخاصة وانطلق.",
    "التخطيط الجيد والخطوات الصغيرة المستمرة تصنع فارقاً مهولاً.",
    "المفاتيح الأساسية للإنتاجية: التركيز المطلق وتحديد الأولويات."
  ];
  late String selectedQuote;

  @override
  void initState() {
    super.initState();
    selectedQuote = (quotes..shuffle()).first;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg1 = isDark ? AppColors.darkBg : AppColors.lightSurface;
    final bg2 = isDark ? const Color(0xFF0A0F1E) : const Color(0xFFEEF2F7);
    final accent = isDark ? AppColors.tabWork : AppColors.primaryLight;
    final textMain = isDark ? AppColors.darkText : AppColors.lightText;
    final textSub = isDark ? AppColors.darkSubText : AppColors.lightSubText;

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [bg1, bg2],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
            child: Column(
              children: [
                const Spacer(flex: 2),
                // الأيقونة والعنوان
                Container(
                  width: 100, height: 100,
                  decoration: BoxDecoration(
                    color: accent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: accent.withOpacity(0.35), width: 1.5),
                    boxShadow: [BoxShadow(color: accent.withOpacity(0.15), blurRadius: 24, offset: const Offset(0, 8))],
                  ),
                  child: Icon(Icons.task_alt_rounded, size: 52, color: accent),
                ),
                const SizedBox(height: 22),
                Text(
                  'مهامي',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w800,
                    color: textMain,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'نظّم يومك، حقّق أهدافك',
                  style: TextStyle(fontSize: 14, color: textSub, fontWeight: FontWeight.w400),
                ),
                const SizedBox(height: 4),
                Text(
                  'By Yasser',
                  style: TextStyle(
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                    color: accent,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                  ),
                ),
                const Spacer(flex: 3),
                // بطاقة الحكمة
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: isDark ? const Color(0xFF21262D) : AppColors.lightCardBorder),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(isDark ? 0.3 : 0.06), blurRadius: 16, offset: const Offset(0, 4))],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.format_quote_rounded, color: accent, size: 16),
                          const SizedBox(width: 6),
                          Text('حكمة اليوم', style: TextStyle(fontSize: 12, color: accent, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Text(
                        '"$selectedQuote"',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13.5,
                          color: textSub,
                          fontStyle: FontStyle.italic,
                          height: 1.7,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(flex: 3),
                // زر البدء
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 4,
                      shadowColor: accent.withOpacity(0.4),
                    ),
                    onPressed: () => Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (_) => const MainLayout()),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('ابدأ الآن', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
                        SizedBox(width: 10),
                        Icon(Icons.arrow_forward_ios_rounded, size: 14),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ==========================================
// الهيكل الأساسي للتطبيق
// ==========================================
class MainLayout extends StatefulWidget {
  const MainLayout({Key? key}) : super(key: key);
  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    const PracticalTasksView(),
    const PersonalTasksView(),
    const ExpensesTab(),
    const NotesTab(),
  ];

  void _showTrashBin() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            child: Column(
              children: [
                // مقبض
                Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.withOpacity(0.3), borderRadius: BorderRadius.circular(2))),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: Colors.redAccent.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                      child: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 20),
                    ),
                    const SizedBox(width: 10),
                    Text('سلة المهملات', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: isDark ? AppColors.darkText : AppColors.lightText)),
                    const Spacer(),
                    Text('${globalTrash.length} عنصر', style: const TextStyle(fontSize: 12, color: AppColors.lightSubText)),
                  ],
                ),
                const SizedBox(height: 12),
                Divider(color: isDark ? const Color(0xFF21262D) : AppColors.lightDivider),
                Expanded(
                  child: globalTrash.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.delete_sweep_outlined, size: 48, color: Colors.grey.withOpacity(0.3)),
                              const SizedBox(height: 12),
                              const Text('السلة فارغة', style: TextStyle(color: AppColors.lightSubText, fontSize: 14)),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: globalTrash.length,
                          itemBuilder: (context, index) {
                            final item = globalTrash[index];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                              decoration: BoxDecoration(
                                color: isDark ? AppColors.darkBg : AppColors.lightBg,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: isDark ? const Color(0xFF21262D) : AppColors.lightCardBorder),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(item['title'] ?? 'بدون عنوان', style: TextStyle(fontWeight: FontWeight.w600, color: isDark ? AppColors.darkText : AppColors.lightText, fontSize: 13)),
                                        const SizedBox(height: 2),
                                        Text(item['type'], style: const TextStyle(color: AppColors.lightSubText, fontSize: 11)),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.restore_rounded, color: Colors.green, size: 20),
                                    onPressed: () {
                                      setState(() {
                                        if (item['type'] == 'مهام عملية') globalPracticalTasks.add(item['data']);
                                        if (item['type'] == 'مهام شخصية') globalPersonalTasks.add(item['data']);
                                        if (item['type'] == 'مصاريف شخصية') globalPersonalExpenses.add(item['data']);
                                        if (item['type'] == 'مصاريف عملية') globalPracticalExpenses.add(item['data']);
                                        if (item['type'] == 'ملاحظة') globalNotes.add(item['data']);
                                        globalTrash.removeAt(index);
                                      });
                                      setModalState(() {});
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_forever_rounded, color: Colors.redAccent, size: 20),
                                    onPressed: () => setModalState(() => globalTrash.removeAt(index)),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = tabColor(_currentIndex, isDark);
    final titles = ["مهام العمل", "المهام الشخصية", "المحفظة", "الملاحظات"];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(titles[_currentIndex]),
          actions: [
            ValueListenableBuilder<ThemeMode>(
              valueListenable: globalThemeNotifier,
              builder: (context, mode, _) => IconButton(
                icon: Icon(
                  mode == ThemeMode.dark ? Icons.wb_sunny_rounded : Icons.nights_stay_rounded,
                  color: color,
                ),
                onPressed: () => globalThemeNotifier.value =
                    mode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 22),
              onPressed: _showTrashBin,
            ),
            const SizedBox(width: 4),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(2),
            child: Container(height: 2, decoration: BoxDecoration(gradient: LinearGradient(colors: [color.withOpacity(0.6), color.withOpacity(0.0)]))),
          ),
        ),
        body: IndexedStack(index: _currentIndex, children: _pages),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: isDark ? const Color(0xFF21262D) : AppColors.lightCardBorder, width: 1)),
          ),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
            type: BottomNavigationBarType.fixed,
            selectedItemColor: tabColor(_currentIndex, isDark),
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.business_center_outlined), activeIcon: Icon(Icons.business_center_rounded), label: 'عملية'),
              BottomNavigationBarItem(icon: Icon(Icons.self_improvement_outlined), activeIcon: Icon(Icons.self_improvement_rounded), label: 'شخصية'),
              BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet_outlined), activeIcon: Icon(Icons.account_balance_wallet_rounded), label: 'المحفظة'),
              BottomNavigationBarItem(icon: Icon(Icons.sticky_note_2_outlined), activeIcon: Icon(Icons.sticky_note_2_rounded), label: 'ملاحظات'),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// ويدجت مشترك: بطاقة الإحصاء العلوية
// ==========================================
class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final bool isDark;
  final VoidCallback? onSort;

  const _StatCard({required this.label, required this.value, required this.color, required this.isDark, this.onSort});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withOpacity(0.25)),
        boxShadow: [BoxShadow(color: color.withOpacity(isDark ? 0.12 : 0.08), blurRadius: 20, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(14)),
            child: Center(
              child: Text(value, style: TextStyle(color: color, fontSize: 22, fontWeight: FontWeight.w800)),
            ),
          ),
          const SizedBox(width: 14),
          Text(label, style: TextStyle(color: isDark ? AppColors.darkSubText : AppColors.lightSubText, fontSize: 14, fontWeight: FontWeight.w500)),
          const Spacer(),
          if (onSort != null)
            IconButton(
              tooltip: 'فرز حسب الأهمية',
              icon: Icon(Icons.sort_rounded, color: color),
              style: IconButton.styleFrom(backgroundColor: color.withOpacity(0.1)),
              onPressed: onSort,
            ),
        ],
      ),
    );
  }
}

// ==========================================
// 1. شاشة المهام العملية
// ==========================================
class PracticalTasksView extends StatefulWidget {
  const PracticalTasksView({Key? key}) : super(key: key);
  @override
  State<PracticalTasksView> createState() => _PracticalTasksViewState();
}

class _PracticalTasksViewState extends State<PracticalTasksView> {
  final _titleController    = TextEditingController();
  final _durationController = TextEditingController();
  bool _isImportant = false;

  void _addTask() {
    if (_titleController.text.trim().isEmpty) return;
    setState(() {
      globalPracticalTasks.insert(0, {
        'id': DateTime.now().millisecondsSinceEpoch,
        'title': _titleController.text.trim(),
        'duration': _durationController.text.trim(),
        'important': _isImportant,
        'dateTime': getCurrentFormattedDate(),
      });
      _titleController.clear(); _durationController.clear(); _isImportant = false;
    });
  }

  void _sortTasks() {
    setState(() {
      globalPracticalTasks.sort((a, b) {
        if (a['important'] == b['important']) return 0;
        return (a['important'] == true) ? -1 : 1;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color  = tabColor(0, isDark);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        children: [
          _StatCard(label: 'المهام المسجلة', value: '${globalPracticalTasks.length}', color: color, isDark: isDark, onSort: _sortTasks),
          const SizedBox(height: 14),
          // حقل الإدخال
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(hintText: 'مهمة جديدة...'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 1,
                child: TextField(
                  controller: _durationController,
                  decoration: const InputDecoration(hintText: 'المدة'),
                ),
              ),
              const SizedBox(width: 6),
              IconButton(
                icon: Icon(_isImportant ? Icons.star_rounded : Icons.star_border_rounded, color: _isImportant ? Colors.amber : AppColors.lightSubText),
                onPressed: () => setState(() => _isImportant = !_isImportant),
              ),
              const SizedBox(width: 2),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(44, 48),
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _addTask,
                child: const Icon(Icons.add_rounded),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Expanded(
            child: globalPracticalTasks.isEmpty
                ? _EmptyState(color: color, label: 'لا توجد مهام بعد')
                : ListView.builder(
                    itemCount: globalPracticalTasks.length,
                    itemBuilder: (context, index) {
                      final task = globalPracticalTasks[index];
                      return _TaskCard(
                        title: task['title'],
                        subtitle: '${task['duration']}  •  ${task['dateTime']}',
                        isImportant: task['important'] == true,
                        color: color,
                        isDark: isDark,
                        onDelete: () => setState(() => globalTrash.add({
                          'type': 'مهام عملية',
                          'title': task['title'],
                          'data': globalPracticalTasks.removeAt(index),
                        })),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// ويدجت مشترك: بطاقة المهمة
// ==========================================
class _TaskCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isImportant;
  final Color color;
  final bool isDark;
  final VoidCallback onDelete;

  const _TaskCard({
    required this.title, required this.subtitle, required this.isImportant,
    required this.color, required this.isDark, required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isImportant ? Colors.amber.withOpacity(0.5) : (isDark ? const Color(0xFF21262D) : AppColors.lightCardBorder),
          width: isImportant ? 1.5 : 1,
        ),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(isDark ? 0.2 : 0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          if (isImportant)
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Icon(Icons.star_rounded, color: Colors.amber, size: 18),
            )
          else
            Container(
              width: 8, height: 8,
              margin: const EdgeInsets.only(left: 12),
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.w600, color: isDark ? AppColors.darkText : AppColors.lightText, fontSize: 14)),
                const SizedBox(height: 3),
                Text(subtitle, style: const TextStyle(color: AppColors.lightSubText, fontSize: 11)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 19),
            onPressed: onDelete,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// ويدجت: حالة فارغة
// ==========================================
class _EmptyState extends StatelessWidget {
  final Color color;
  final String label;
  const _EmptyState({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_rounded, size: 52, color: color.withOpacity(0.25)),
          const SizedBox(height: 12),
          Text(label, style: const TextStyle(color: AppColors.lightSubText, fontSize: 14)),
        ],
      ),
    );
  }
}

// ==========================================
// 2. شاشة المهام الشخصية
// ==========================================
class PersonalTasksView extends StatefulWidget {
  const PersonalTasksView({Key? key}) : super(key: key);
  @override
  State<PersonalTasksView> createState() => _PersonalTasksViewState();
}

class _PersonalTasksViewState extends State<PersonalTasksView> {
  final Map<String, bool> _prayers = {
    'الفجر': false, 'الظهر': false, 'العصر': false, 'المغرب': false, 'العشاء': false,
  };
  double _waterAmount = 0.0;
  final _personalController = TextEditingController();
  bool _isImportant = false;

  void _addWater() => setState(() => _waterAmount < 3.0 ? _waterAmount += 0.250 : _waterAmount = 0);

  void _addTask() {
    if (_personalController.text.trim().isEmpty) return;
    setState(() {
      globalPersonalTasks.insert(0, {
        'id': DateTime.now().millisecondsSinceEpoch,
        'title': _personalController.text.trim(),
        'important': _isImportant,
        'dateTime': getCurrentFormattedDate(),
      });
      _personalController.clear(); _isImportant = false;
    });
  }

  void _sortTasks() {
    setState(() {
      globalPersonalTasks.sort((a, b) {
        if (a['important'] == b['important']) return 0;
        return (a['important'] == true) ? -1 : 1;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color  = tabColor(1, isDark);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _StatCard(label: 'الأهداف الشخصية', value: '${globalPersonalTasks.length}', color: color, isDark: isDark, onSort: _sortTasks),
          const SizedBox(height: 20),
          // ---- الصلوات ----
          _SectionLabel(label: 'الصلوات الخمس', icon: Icons.mosque_rounded, color: color),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: isDark ? const Color(0xFF21262D) : AppColors.lightCardBorder),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: _prayers.keys.map((p) {
                final done = _prayers[p]!;
                return GestureDetector(
                  onTap: () => setState(() => _prayers[p] = !done),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                      color: done ? color.withOpacity(0.15) : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: done ? color : (isDark ? const Color(0xFF21262D) : AppColors.lightCardBorder)),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.mosque_rounded, color: done ? color : AppColors.lightSubText, size: 22),
                        const SizedBox(height: 5),
                        Text(p, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: done ? color : AppColors.lightSubText)),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 20),
          // ---- الماء ----
          _SectionLabel(label: 'مؤشر شرب الماء', icon: Icons.water_drop_rounded, color: Colors.blue),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: isDark ? const Color(0xFF21262D) : AppColors.lightCardBorder),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('المستهدف: 3 لتر', style: TextStyle(color: AppColors.lightSubText, fontSize: 12)),
                      const SizedBox(height: 6),
                      Text(
                        '${_waterAmount.toStringAsFixed(2)} لتر',
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Colors.blue),
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: (_waterAmount / 3.0).clamp(0.0, 1.0),
                          minHeight: 8,
                          backgroundColor: Colors.blue.withOpacity(0.1),
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                GestureDetector(
                  onTap: _addWater,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Container(
                        width: 46, height: 64,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue, width: 2),
                          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12), top: Radius.circular(6)),
                          color: isDark ? AppColors.darkBg : AppColors.lightBg,
                        ),
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                        width: 42, height: 60 * (_waterAmount / 3.0).clamp(0.0, 1.0),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.7),
                          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(10)),
                        ),
                      ),
                      Icon(Icons.water_drop_rounded, size: 14, color: Colors.white.withOpacity(0.8)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // ---- إضافة هدف ----
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _personalController,
                  decoration: const InputDecoration(hintText: 'إضافة هدف شخصي...'),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: Icon(_isImportant ? Icons.star_rounded : Icons.star_border_rounded,
                    color: _isImportant ? Colors.amber : AppColors.lightSubText),
                onPressed: () => setState(() => _isImportant = !_isImportant),
              ),
              const SizedBox(width: 2),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: color, foregroundColor: Colors.white,
                  minimumSize: const Size(44, 48), padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _addTask,
                child: const Icon(Icons.add_rounded),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: globalPersonalTasks.length,
            itemBuilder: (context, index) {
              final task = globalPersonalTasks[index];
              return _TaskCard(
                title: task['title'],
                subtitle: task['dateTime'],
                isImportant: task['important'] == true,
                color: color,
                isDark: isDark,
                onDelete: () => setState(() => globalTrash.add({
                  'type': 'مهام شخصية',
                  'title': task['title'],
                  'data': globalPersonalTasks.removeAt(index),
                })),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  const _SectionLabel({required this.label, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(width: 7),
        Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: color)),
      ],
    );
  }
}

// ==========================================
// 3. شاشة المصاريف
// ==========================================
class ExpensesTab extends StatelessWidget {
  const ExpensesTab({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color  = tabColor(2, isDark);
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.lightBg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: isDark ? const Color(0xFF21262D) : AppColors.lightCardBorder),
            ),
            child: TabBar(
              indicator: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
              labelColor: Colors.white,
              unselectedLabelColor: AppColors.lightSubText,
              indicatorSize: TabBarIndicatorSize.tab,
              labelStyle: const TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.w700, fontSize: 13),
              tabs: const [Tab(text: "محفظة شخصية"), Tab(text: "محفظة عملية")],
            ),
          ),
          const Expanded(child: TabBarView(children: [
            ExpenseTypeView(isPractical: false),
            ExpenseTypeView(isPractical: true),
          ])),
        ],
      ),
    );
  }
}

class ExpenseTypeView extends StatefulWidget {
  final bool isPractical;
  const ExpenseTypeView({Key? key, required this.isPractical}) : super(key: key);
  @override
  State<ExpenseTypeView> createState() => _ExpenseTypeViewState();
}

class _ExpenseTypeViewState extends State<ExpenseTypeView> {
  final _titleCtrl  = TextEditingController();
  final _amountCtrl = TextEditingController();
  String _selectedCategory = 'مصروف عادي';
  final List<String> _categories = ['صافي الراتب', 'أموال أخرى (دخل)', 'أقساط ومديونيات', 'مصروف عادي'];

  List<Map<String, dynamic>> get _list => widget.isPractical ? globalPracticalExpenses : globalPersonalExpenses;

  void _add() {
    if (_titleCtrl.text.trim().isEmpty || _amountCtrl.text.trim().isEmpty) return;
    final amount = double.tryParse(_amountCtrl.text.trim());
    if (amount == null) return;
    setState(() {
      _list.insert(0, {
        'id': DateTime.now().millisecondsSinceEpoch,
        'title': _titleCtrl.text.trim(),
        'amount': amount,
        'category': _selectedCategory,
        'isCredit': (_selectedCategory == 'صافي الراتب' || _selectedCategory == 'أموال أخرى (دخل)'),
        'date': getCurrentFormattedDate(),
      });
      _titleCtrl.clear(); _amountCtrl.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final totalCredit = _list.where((i) => i['isCredit'] == true).fold(0.0, (s, i) => s + i['amount']);
    final totalDebit  = _list.where((i) => i['isCredit'] == false).fold(0.0, (s, i) => s + i['amount']);
    final net = totalCredit - totalDebit;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color  = tabColor(2, isDark);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Column(
        children: [
          // بطاقة الرصيد
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: color.withOpacity(0.25)),
              boxShadow: [BoxShadow(color: color.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, 4))],
            ),
            child: Column(
              children: [
                Text('صافي الرصيد', style: TextStyle(color: isDark ? AppColors.darkSubText : AppColors.lightSubText, fontSize: 12, fontWeight: FontWeight.w500)),
                const SizedBox(height: 6),
                Text(
                  '${net >= 0 ? "+" : ""}${net.toStringAsFixed(2)} ريال',
                  style: TextStyle(color: net >= 0 ? Colors.green : Colors.redAccent, fontSize: 26, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _BalancePill(label: 'دائن', value: '+${totalCredit.toStringAsFixed(1)}', color: Colors.green),
                    Container(width: 1, height: 28, color: isDark ? const Color(0xFF21262D) : AppColors.lightDivider),
                    _BalancePill(label: 'مدين', value: '-${totalDebit.toStringAsFixed(1)}', color: Colors.redAccent),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // نموذج الإدخال
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: isDark ? const Color(0xFF21262D) : AppColors.lightCardBorder),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.label_outline_rounded, color: color, size: 16),
                    const SizedBox(width: 6),
                    const Text('النوع:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: DropdownButton<String>(
                        value: _selectedCategory, isExpanded: true, underline: const SizedBox(),
                        dropdownColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                        style: TextStyle(fontFamily: 'Tajawal', fontSize: 12, color: isDark ? AppColors.darkText : AppColors.lightText),
                        items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                        onChanged: (val) => setState(() => _selectedCategory = val!),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(flex: 2, child: TextField(controller: _titleCtrl, decoration: const InputDecoration(hintText: 'البيان...'))),
                    const SizedBox(width: 8),
                    Expanded(flex: 1, child: TextField(controller: _amountCtrl, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: const InputDecoration(hintText: 'المبلغ'))),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: color, foregroundColor: Colors.white,
                        minimumSize: const Size(44, 48), padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: _add,
                      child: const Icon(Icons.add_rounded),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: _list.isEmpty
                ? _EmptyState(color: color, label: 'لا توجد معاملات بعد')
                : ListView.builder(
                    itemCount: _list.length,
                    itemBuilder: (context, index) {
                      final item = _list[index];
                      final isCredit = item['isCredit'] == true;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: isDark ? const Color(0xFF21262D) : AppColors.lightCardBorder),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 36, height: 36,
                              decoration: BoxDecoration(color: (isCredit ? Colors.green : Colors.redAccent).withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                              child: Icon(isCredit ? Icons.south_west_rounded : Icons.north_east_rounded, color: isCredit ? Colors.green : Colors.redAccent, size: 18),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item['title'], style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: isDark ? AppColors.darkText : AppColors.lightText)),
                                  Text(item['category'], style: const TextStyle(color: AppColors.lightSubText, fontSize: 11)),
                                ],
                              ),
                            ),
                            Text(
                              '${isCredit ? "+" : "-"}${item['amount'].toStringAsFixed(2)}',
                              style: TextStyle(color: isCredit ? Colors.green : Colors.redAccent, fontWeight: FontWeight.w700, fontSize: 14),
                            ),
                            const SizedBox(width: 4),
                            IconButton(
                              icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 18),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                              onPressed: () => setState(() => globalTrash.add({'type': 'مصاريف', 'title': item['title'], 'data': _list.removeAt(index)})),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _BalancePill extends StatelessWidget {
  final String label, value;
  final Color color;
  const _BalancePill({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: AppColors.lightSubText, fontSize: 11)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 15)),
      ],
    );
  }
}

// ==========================================
// 4. شاشة الملاحظات
// ==========================================
class NotesTab extends StatefulWidget {
  const NotesTab({Key? key}) : super(key: key);
  @override
  State<NotesTab> createState() => _NotesTabState();
}

class _NotesTabState extends State<NotesTab> {
  void _openNoteDialog({Map<String, dynamic>? existingNote, int? index}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color  = tabColor(3, isDark);
    final titleCtrl   = TextEditingController(text: existingNote?['title'] ?? '');
    final contentCtrl = TextEditingController(text: existingNote?['content'] ?? '');
    Color selectedColor = existingNote?['color'] ?? (isDark ? const Color(0xFF1E1B4B) : const Color(0xFFF5F3FF));
    bool isImportant   = existingNote?['important'] ?? false;

    // ألوان البطاقة (dark & light variants)
    final List<Color> noteColors = isDark
        ? [const Color(0xFF1E1B4B), const Color(0xFF1A2744), const Color(0xFF0F2318), const Color(0xFF3B0A0A), const Color(0xFF1A0A2E)]
        : [const Color(0xFFF5F3FF), const Color(0xFFEFF6FF), const Color(0xFFF0FDF4), const Color(0xFFFFF1F2), const Color(0xFFFAF5FF)];
    final List<Color> dotColors = [const Color(0xFF7C3AED), const Color(0xFF2563EB), const Color(0xFF059669), const Color(0xFFBE185D), const Color(0xFF9333EA)];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setD) => Directionality(
          textDirection: TextDirection.rtl,
          child: Dialog(
            backgroundColor: selectedColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Icon(Icons.sticky_note_2_rounded, color: color, size: 20),
                      const SizedBox(width: 8),
                      Text('ملاحظة', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: isDark ? AppColors.darkText : AppColors.lightText)),
                      const Spacer(),
                      IconButton(
                        icon: Icon(isImportant ? Icons.star_rounded : Icons.star_border_rounded, color: Colors.amber),
                        onPressed: () => setD(() => isImportant = !isImportant),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  TextField(
                    controller: titleCtrl,
                    decoration: InputDecoration(
                      hintText: 'العنوان...',
                      border: InputBorder.none,
                      filled: false,
                      hintStyle: TextStyle(color: (isDark ? AppColors.darkSubText : AppColors.lightSubText)),
                    ),
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: isDark ? AppColors.darkText : AppColors.lightText),
                  ),
                  Divider(color: isDark ? const Color(0xFF21262D) : AppColors.lightDivider),
                  TextField(
                    controller: contentCtrl,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: 'اكتب ملاحظتك...',
                      border: InputBorder.none,
                      filled: false,
                      hintStyle: TextStyle(color: isDark ? AppColors.darkSubText : AppColors.lightSubText),
                    ),
                    style: TextStyle(fontSize: 13, color: isDark ? AppColors.darkText : AppColors.lightText, height: 1.6),
                  ),
                  const SizedBox(height: 12),
                  // منتقي اللون
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(noteColors.length, (i) => GestureDetector(
                      onTap: () => setD(() => selectedColor = noteColors[i]),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        width: 28, height: 28,
                        decoration: BoxDecoration(
                          color: dotColors[i],
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: selectedColor == noteColors[i] ? Colors.white : Colors.transparent,
                            width: 2.5,
                          ),
                          boxShadow: selectedColor == noteColors[i] ? [BoxShadow(color: dotColors[i].withOpacity(0.5), blurRadius: 8)] : [],
                        ),
                      ),
                    )),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('إلغاء', style: TextStyle(color: isDark ? AppColors.darkSubText : AppColors.lightSubText)),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: color, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                        onPressed: () {
                          if (titleCtrl.text.isEmpty && contentCtrl.text.isEmpty) return;
                          setState(() {
                            final noteData = {
                              'title': titleCtrl.text,
                              'content': contentCtrl.text,
                              'color': selectedColor,
                              'important': isImportant,
                              'dateTime': getCurrentFormattedDate(),
                              'isLocked': existingNote?['isLocked'] ?? false,
                              'password': existingNote?['password'] ?? '',
                            };
                            if (index == null) globalNotes.insert(0, noteData);
                            else globalNotes[index] = noteData;
                          });
                          Navigator.pop(context);
                        },
                        child: const Text('حفظ', style: TextStyle(fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _sortNotes() {
    setState(() {
      globalNotes.sort((a, b) {
        if (a['important'] == b['important']) return 0;
        return (a['important'] == true) ? -1 : 1;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color  = tabColor(3, isDark);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 2,
                  ),
                  icon: const Icon(Icons.edit_note_rounded),
                  label: const Text('ملاحظة جديدة', style: TextStyle(fontWeight: FontWeight.w700)),
                  onPressed: () => _openNoteDialog(),
                ),
              ),
              const SizedBox(width: 10),
              IconButton(
                tooltip: 'فرز حسب الأهمية',
                style: IconButton.styleFrom(
                  backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                  minimumSize: const Size(50, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: BorderSide(color: isDark ? const Color(0xFF21262D) : AppColors.lightCardBorder)),
                ),
                icon: Icon(Icons.sort_rounded, color: color),
                onPressed: _sortNotes,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: globalNotes.isEmpty
                ? _EmptyState(color: color, label: 'لا توجد ملاحظات بعد')
                : GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12,
                    ),
                    itemCount: globalNotes.length,
                    itemBuilder: (context, index) {
                      final note = globalNotes[index];
                      final isImportant = note['important'] == true;
                      return GestureDetector(
                        onTap: () => _openNoteDialog(existingNote: note, index: index),
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: note['color'],
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: isImportant ? Colors.amber : (isDark ? const Color(0xFF21262D) : AppColors.lightCardBorder),
                              width: isImportant ? 1.8 : 1,
                            ),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(isDark ? 0.25 : 0.06), blurRadius: 10, offset: const Offset(0, 3))],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      note['title'],
                                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: isDark ? AppColors.darkText : AppColors.lightText),
                                      maxLines: 1, overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  if (isImportant) const Icon(Icons.star_rounded, size: 14, color: Colors.amber),
                                ],
                              ),
                              Divider(height: 12, color: isDark ? const Color(0xFF21262D) : AppColors.lightDivider),
                              Expanded(
                                child: Text(
                                  note['content'],
                                  style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkSubText : AppColors.lightSubText, height: 1.5),
                                  overflow: TextOverflow.fade,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    note['dateTime'].toString().split('-')[0].trim(),
                                    style: const TextStyle(color: AppColors.lightSubText, fontSize: 9),
                                  ),
                                  GestureDetector(
                                    onTap: () => setState(() => globalTrash.add({'type': 'ملاحظة', 'title': note['title'], 'data': globalNotes.removeAt(index)})),
                                    child: const Icon(Icons.delete_sweep_rounded, size: 17, color: Colors.redAccent),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
