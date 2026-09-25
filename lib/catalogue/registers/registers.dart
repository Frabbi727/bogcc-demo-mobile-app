/// Registry of every config-driven register.
///
/// Adding a register is: write a config, list it here, seed some entries. No new
/// screens — the three generic ones in `lib/engine/screens/` read the config.
library;

import 'birth_death.dart';
import 'building_plan.dart';
import 'cert_citizen.dart';
import 'cert_warish.dart';
import 'garbage.dart';
import 'garbage_trips.dart';
import 'market_rent.dart';
import 'register_config.dart';
import 'rickshaw_licence.dart';
import 'streetlight.dart';

export 'register_config.dart';

const registers = <RegisterConfig>[
  streetlightRegister,
  garbageRegister,
  garbageTripsRegister,
  certCitizenRegister,
  certWarishRegister,
  marketRentRegister,
  rickshawLicenceRegister,
  buildingPlanRegister,
  birthDeathRegister,
];

RegisterConfig? getRegister(String? key) {
  if (key == null) return null;
  for (final r in registers) {
    if (r.key == key) return r;
  }
  return null;
}

/// Registers a citizen can apply to online.
final citizenRegisters = registers.where((r) => r.citizenFacing).toList();

/// Looks a register up by the service catalogue key it implements.
RegisterConfig? registerForService(String? serviceKey) {
  if (serviceKey == null) return null;
  for (final r in registers) {
    if (r.serviceKey == serviceKey) return r;
  }
  return null;
}
