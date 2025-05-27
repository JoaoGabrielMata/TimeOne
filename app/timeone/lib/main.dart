import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

void main() {
  runApp(BancoDeHorasApp());
}

class BancoDeHorasApp extends StatelessWidget {
  const BancoDeHorasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Banco de Horas',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeScreen(),
      routes: {
        '/registros': (_) => RegistrosScreen(),
        '/registrar': (_) => RegistrarScreen(),
        '/calendario': (_) => CalendarioScreen(),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Banco de Horas')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/registros'),
              child: Text('Registros Passados'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/registrar'),
              child: Text('Registrar'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/calendario'),
              child: Text('Calendário'),
            ),
          ],
        ),
      ),
    );
  }
}

class RegistrarScreen extends StatefulWidget {
  const RegistrarScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegistrarScreenState createState() => _RegistrarScreenState();
}

class _RegistrarScreenState extends State<RegistrarScreen> {
  TimeOfDay? _horaEntrada;
  TimeOfDay? _horaSaida;

  Future<void> _selecionarHora(bool entrada) async {
    final TimeOfDay? hora = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (hora != null) {
      setState(() {
        if (entrada) {
          _horaEntrada = hora;
        } else {
          _horaSaida = hora;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Registrar Horário")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => _selecionarHora(true),
              child: Text(_horaEntrada != null
                  ? "Entrada: ${_horaEntrada!.format(context)}"
                  : "Selecionar Entrada"),
            ),
            ElevatedButton(
              onPressed: () => _selecionarHora(false),
              child: Text(_horaSaida != null
                  ? "Saída: ${_horaSaida!.format(context)}"
                  : "Selecionar Saída"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Horários registrados!")),
                );
              },
              child: Text("Salvar Registro"),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: use_key_in_widget_constructors
class RegistrosScreen extends StatelessWidget {
  final List<String> registros = [
    '20/05 - Entrada: 08:00, Saída: 17:00',
    '21/05 - Entrada: 09:00, Saída: 18:00',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Registros Passados")),
      body: ListView.builder(
        itemCount: registros.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(registros[index]),
          );
        },
      ),
    );
  }
}

// ignore: use_key_in_widget_constructors
class CalendarioScreen extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _CalendarioScreenState createState() => _CalendarioScreenState();
}

class _CalendarioScreenState extends State<CalendarioScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Calendário")),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(DateTime.now().year, 1, 1),
            lastDay: DateTime.utc(DateTime.now().year, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
          ),
          if (_selectedDay != null)
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Dia selecionado: $_selectedDay"),
            ),
        ],
      ),
    );
  }
}