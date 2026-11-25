import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/project.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:provider/provider.dart';

class ProjectFormPage extends StatefulWidget {
  const ProjectFormPage({super.key});

  @override
  State<ProjectFormPage> createState() => _ProjectFormPageState();
}

class _ProjectFormPageState extends State<ProjectFormPage> {
  final _formKey = GlobalKey<FormState>();

  String _title = "";
  String _description = "";
  String _techStack = "";
  String _projectUrl = "";
  String _projectImageUrl = "";
  bool _isSubmitting = false;

  /// Validasi URL: wajib diawali http:// atau https:// dan punya domain.
  String? _validateUrl(String? value, {required bool isRequired}) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) {
      return isRequired ? "Project URL tidak boleh kosong!" : null;
    }
    final uri = Uri.tryParse(text);
    final isHttp =
        uri != null && (uri.isScheme('http') || uri.isScheme('https'));
    if (!isHttp || uri.host.isEmpty) {
      return "Masukkan URL valid yang diawali http:// atau https://";
    }
    return null;
  }

  InputDecoration _inputDecoration(String label, {String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
    );
  }

  void _resetForm() {
    _formKey.currentState!.reset();
    setState(() {
      _title = "";
      _description = "";
      _techStack = "";
      _projectUrl = "";
      _projectImageUrl = "";
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void _showSuccessDialog(Project project) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Proyek berhasil ditambahkan!'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Title: ${project.title}'),
                Text('Description: ${project.description}'),
                Text('Tech Stack: ${project.techStack}'),
                Text('Project URL: ${project.projectUrl}'),
                Text(
                  'Image URL: ${project.projectImageUrl.isEmpty ? '-' : project.projectImageUrl}',
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pop(dialogContext);
                _resetForm();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    // Ambil dependensi sebelum await supaya context tidak dipakai
    // setelah jeda asinkron.
    final apiClient = context.read<ApiClient>();
    final authState = context.read<AuthState>();

    final loggedIn = await ensureLoggedIn(context);
    if (!loggedIn || !mounted) return;

    setState(() {
      _isSubmitting = true;
    });

    final newProject = Project(
      title: _title.trim(),
      description: _description.trim(),
      techStack: _techStack.trim(),
      projectUrl: _projectUrl.trim(),
      projectImageUrl: _projectImageUrl.trim(),
    );

    try {
      final created = await apiClient.createProject(
        newProject,
        token: authState.token!,
      );
      if (!mounted) return;
      _showSuccessDialog(created);
    } on ApiException catch (e) {
      if (!mounted) return;
      if (e.statusCode == 401) {
        // Token tidak berlaku lagi: logout lalu minta login ulang.
        await authState.logout();
        if (!mounted) return;
        _showSnackBar('Sesi kamu sudah berakhir. Silakan login ulang.');
        await ensureLoggedIn(context);
      } else {
        _showSnackBar('Gagal menyimpan proyek (${e.statusCode}).');
      }
    } on Exception {
      if (!mounted) return;
      _showSnackBar('Tidak dapat terhubung ke server.');
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Project Form'),
        centerTitle: true,
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // === Title ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: _inputDecoration(
                    "Title",
                    hint: "Contoh: MyPortfolio Mobile",
                  ),
                  onChanged: (String value) => _title = value,
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Title tidak boleh kosong!";
                    }
                    return null;
                  },
                ),
              ),

              // === Description ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  maxLines: 5,
                  decoration: _inputDecoration("Description"),
                  onChanged: (String value) => _description = value,
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Description tidak boleh kosong!";
                    }
                    return null;
                  },
                ),
              ),

              // === Tech Stack ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: _inputDecoration(
                    "Tech Stack",
                    hint: "Contoh: Flutter, Django, PostgreSQL",
                  ),
                  onChanged: (String value) => _techStack = value,
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Tech stack tidak boleh kosong!";
                    }
                    return null;
                  },
                ),
              ),

              // === Project URL ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.url,
                  decoration: _inputDecoration(
                    "Project URL",
                    hint: "https://github.com/username/proyek",
                  ),
                  onChanged: (String value) => _projectUrl = value,
                  validator: (value) => _validateUrl(value, isRequired: true),
                ),
              ),

              // === Project Image URL (opsional) ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.url,
                  decoration: _inputDecoration(
                    "Project Image URL (Optional)",
                    hint: "https://contoh.com/gambar.png",
                  ),
                  onChanged: (String value) => _projectImageUrl = value,
                  validator: (value) => _validateUrl(value, isRequired: false),
                ),
              ),

              // === Tombol Save ===
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(primaryColor),
                    ),
                    onPressed: _isSubmitting ? null : _submit,
                    child: _isSubmitting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            "Save",
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
