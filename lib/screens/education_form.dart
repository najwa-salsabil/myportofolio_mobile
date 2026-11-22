import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';

class EducationFormPage extends StatefulWidget {
  const EducationFormPage({super.key});

  @override
  State<EducationFormPage> createState() => _EducationFormPageState();
}

class _EducationFormPageState extends State<EducationFormPage> {
  final _formKey = GlobalKey<FormState>();

  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();

  String _institution = "";
  String _degree = "S1";
  String _fieldOfStudy = "";
  String _gpa = "";
  String _description = "";
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isOngoing = false;

  final List<String> _degrees = [
    'SMA/SMK',
    'D3',
    'D4',
    'S1',
    'S2',
    'S3',
  ];

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  Future<void> _pickDate({required bool isStart}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: (isStart ? _startDate : _endDate) ?? DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime(2040),
    );
    if (picked == null || !mounted) return;

    setState(() {
      if (isStart) {
        _startDate = picked;
        _startDateController.text = _formatDate(picked);
      } else {
        _endDate = picked;
        _endDateController.text = _formatDate(picked);
      }
    });
  }

  InputDecoration _inputDecoration(
    String label, {
    String? hint,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
    );
  }

  void _resetForm() {
    _formKey.currentState!.reset();
    _startDateController.clear();
    _endDateController.clear();
    setState(() {
      _institution = "";
      _degree = "S1";
      _fieldOfStudy = "";
      _gpa = "";
      _description = "";
      _startDate = null;
      _endDate = null;
      _isOngoing = false;
    });
  }

  void _showSummaryDialog() {
    final endText = _isOngoing ? 'Sekarang' : _endDateController.text;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Edukasi berhasil ditambahkan!'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Institusi: $_institution'),
                Text('Jenjang: $_degree'),
                Text('Jurusan: $_fieldOfStudy'),
                Text('Periode: ${_startDateController.text} - $endText'),
                Text('IPK: ${_gpa.trim().isEmpty ? '-' : _gpa}'),
                Text(
                  'Deskripsi: ${_description.trim().isEmpty ? '-' : _description}',
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Tutup'),
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

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Education Form'),
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
              // === Institution ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: _inputDecoration(
                    "Nama Institusi",
                    hint: "Contoh: Universitas Indonesia",
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _institution = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Nama institusi tidak boleh kosong!";
                    }
                    if (value.trim().length > 100) {
                      return "Nama institusi maksimal 100 karakter!";
                    }
                    return null;
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                  decoration: _inputDecoration("Jenjang"),
                  initialValue: _degree,
                  items: _degrees
                      .map((degree) => DropdownMenuItem(
                            value: degree,
                            child: Text(degree),
                          ))
                      .toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _degree = newValue!;
                    });
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: _inputDecoration(
                    "Jurusan / Bidang Studi",
                    hint: "Contoh: Sistem Informasi",
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _fieldOfStudy = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Jurusan tidak boleh kosong!";
                    }
                    if (value.trim().length > 100) {
                      return "Jurusan maksimal 100 karakter!";
                    }
                    return null;
                  },
                ),
              ),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _startDateController,
                        readOnly: true,
                        decoration: _inputDecoration(
                          "Tanggal Mulai",
                          suffixIcon: const Icon(Icons.calendar_today),
                        ),
                        onTap: () => _pickDate(isStart: true),
                        validator: (String? value) {
                          if (_startDate == null) {
                            return "Tanggal mulai wajib diisi!";
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _endDateController,
                        readOnly: true,
                        enabled: !_isOngoing,
                        decoration: _inputDecoration(
                          "Tanggal Selesai",
                          suffixIcon: const Icon(Icons.calendar_today),
                        ),
                        onTap: () => _pickDate(isStart: false),
                        validator: (String? value) {
                          if (_isOngoing) return null;
                          if (_endDate == null) {
                            return "Tanggal selesai wajib diisi!";
                          }
                          if (_startDate != null &&
                              _endDate!.isBefore(_startDate!)) {
                            return "Tidak boleh sebelum tanggal mulai!";
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ],
              ),

              CheckboxListTile(
                title: const Text("Masih menempuh pendidikan ini"),
                value: _isOngoing,
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (bool? value) {
                  setState(() {
                    _isOngoing = value ?? false;
                    if (_isOngoing) {
                      _endDate = null;
                      _endDateController.clear();
                    }
                  });
                },
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: _inputDecoration(
                    "IPK (opsional)",
                    hint: "Contoh: 3.75",
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _gpa = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return null; // opsional
                    }
                    final gpa =
                        double.tryParse(value.trim().replaceAll(',', '.'));
                    if (gpa == null) {
                      return "IPK harus berupa angka!";
                    }
                    if (gpa < 0 || gpa > 4) {
                      return "IPK harus di antara 0.00 dan 4.00!";
                    }
                    return null;
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  maxLines: 4,
                  decoration: _inputDecoration(
                    "Deskripsi (opsional)",
                    hint: "Organisasi, prestasi, atau mata kuliah unggulan",
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _description = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value != null && value.trim().length > 300) {
                      return "Deskripsi maksimal 300 karakter!";
                    }
                    return null;
                  },
                ),
              ),

              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(primaryColor),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _showSummaryDialog();
                      }
                    },
                    child: const Text(
                      "Simpan",
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