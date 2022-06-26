Config = {}

Config["MDTCommand"] = "mdt"

Config["PoliceJobs"] = {
    "police",
    "sheriff",
    "state"
}

Config["EMSJobs"] = {
    "ems"
}

-- Config["PoliceRosterLink"] = "https://docs.google.com/spreadsheets/d/1Xyh8-khskhg0KxXDcPmepI7qF0pdpOFb0Kzq5NTuo1M/edit?usp=sharing"

-- Config["EMSRosterLink"] = ""

-- Config["PublicRecords"] = {
--     ['Coords'] = vector3(236.35, -409.44, 47.92),
--     ['AllowImageChange'] = false
-- }

Config["SQLWrapper"] = "oxmysql"

Config["CoreSettings"]  = {
    ["Core"] = "drpbase",
    ["DRPBase"] = {
        ["CoreName"] = "warp-base"
    }
}

Config['OffensesTitels'] = {
        [1] = ''
}

Config["Offenses"] = {
    [1] = {
        [1] = { title = 'Intimidation', class = 'Misdemeanor', id = 'A1', months = 10, fine = 500, color = 'orange' },
        [2] = { title = 'Assault', class = 'Misdemeanor', id = 'A2', months = 15, fine = 1200, color = 'orange' },
        [3] = { title = 'Assault with a Deadly Weapon', class = 'Felony', id = 'A3', months = 20, fine = 2000, color = 'red' },
        [4] = { title = 'Mutual Combat', class = 'Misdemeanor', id = 'A4', months = 10, fine = 750, color = 'orange' },
        [5] = { title = 'Battery', class = 'Misdemeanor', id = 'A5', months = 15, fine = 1000, color = 'orange' },
        [6] = { title = 'Aggravated Battery', class = 'Felony', id = 'A6', months = 25, fine = 2000, color = 'red' },
        [7] = { title = 'Entrapment', class = 'Felony', id = 'A7', months = 50, fine = 7500, color = 'red' },
        [8] = { title = 'Manslaughter', class = 'Felony', id = 'A8', months = 30, fine = 2500, color = 'red' },
        [9] = { title = 'Murder', class = 'Felony', id = 'A9', months = 50, fine = 15000, color = 'red' },
	[10] = { title = 'Possession of an Illegal Class 1', class = 'Felony', id = 'A10', months = 45, fine = 10000, color = 'red' },
	[11] = { title = 'Possession of an Illegal Class 2', class = 'Felony', id = 'A11', months = 65, fine = 15000, color = 'red' },
	[12] = { title = 'Possession of an Illegal Class 3', class = 'Felony', id = 'A12', months = 65, fine = 20000, color = 'red' },
	[13] = { title = 'First Degree Attempted Murder', class = 'Felony', id = 'A13', months = 50, fine = 20000, color = 'red' },
	[14] = { title = 'Second Degree Attempted Murder', class = 'Felony', id = 'A14', months = 35, fine = 14500, color = 'red' },
	[15] = { title = 'Criminal Threats', class = 'Felony', id = 'A15', months = 15, fine = 3500, color = 'red' },
	[16] = { title = 'First Degree Murder of a Government Offical', class = 'Felony', id = 'A16', months = 90, fine = 25000, color = 'red' },
	[17] = { title = 'Second Degree Murder of a Government Offical', class = 'Felony', id = 'A17', months = 90, fine = 25000, color = 'red' },
        [18] = { title = 'False Imprisonment', class = 'Felony', id = 'A18', months = 20, fine = 2000, color = 'red' },
        [19] = { title = 'Kidnapping', class = 'Felony', id = 'A19', months = 30, fine = 2500, color = 'red' },
        [20] = { title = 'Mayhem', class = 'Felony', id = 'A20', months = 20, fine = 3000, color = 'red' },
        [21] = { title = 'Vehicular Murder', class = 'Felony', id = 'A21', months = 60, fine = 5000, color = 'red' },
        [22] = { title = 'Assault on a Government Official, Class C (1-2)', class = 'Felony', id = 'A22', months = 25, fine = 2500, color = 'red' },
        [23] = { title = 'Assault on a Government Official, Class B (3-5)', class = 'Felony', id = 'A23', months = 45, fine = 5000, color = 'red' },
        [24] = { title = 'Assault on a Government Official, Class A (6+)', class = 'Felony', id = 'A24', months = 70, fine = 7500, color = 'red' },
        [25] = { title = 'Torture', class = 'Felony', id = 'A25', months = 45, fine = 4500, color = 'red' },
        [26] = { title = 'Trespassing', class = 'Misdemeanor', id = 'B1', months = 10, fine = 500, color = 'orange' },
        [27] = { title = 'Trespassing within a Restricted Zone', class = 'Felony', id = 'B2', months = 20, fine = 1000, color = 'orange' },
        [28] = { title = 'Burglary', class = 'Misdemeanor', id = 'B3', months = 15, fine = 1200, color = 'orange' },
        [29] = { title = 'Aggravated Burglary', class = 'Felony', id = 'B4', months = 25, fine = 2200, color = 'red' },
        [30] = { title = 'Possession of Burglary Tools.', class = 'Infraction', id = 'B5', months = 10, fine = 1500, color = 'blue' },
        [31] = { title = 'Intent to Distribute Burglary Tools', class = 'Felony', id = 'B6', months = 50, fine = 5000, color = 'red' },
        [32] = { title = 'Robbery', class = 'Felony', id = 'B7', months = 15, fine = 1200, color = 'red' },    
        [33] = { title = 'Armed Robbery', class = 'Felony', id = 'B8', months = 25, fine = 2500, color = 'red' }, 
        [34] = { title = 'Petty Larceny', class = 'Misdemeanor', id = 'B9', months = 5, fine = 500, color = 'orange' },
        [35] = { title = 'Larceny', class = 'Misdemeanor', id = 'B10', months = 15, fine = 1200, color = 'orange' },
        [36] = { title = 'Grand Larceny', class = 'Felony', id = 'B11', months = 20, fine = 2500, color = 'red' },
        [37] = { title = 'Grand Theft Auto', class = 'Felony', id = 'B12', months = 20, fine = 2500, color = 'red' },
        [38] = { title = 'Receiving Stolen Property', class = 'Misdemeanor', id = 'B13', months = 10, fine = 1200, color = 'orange' },
        [39] = { title = 'Extortion', class = 'Felony', id = 'B14', months = 30, fine = 2500, color = 'red' },
        [40] = { title = 'Forgery', class = 'Misdemeanor', id = 'B15', months = 15, fine = 1500, color = 'orange' },
        [41] = { title = 'Fraud', class = 'Felony', id = 'B16', months = 25, fine = 2500, color = 'red' },
        [42] = { title = 'Vandalism', class = 'Misdemeanor', id = 'B17', months = 5, fine = 1200, color = 'orange' },
        [43] = { title = 'Grand Theft Auto (Commercial Vehicle)', class = 'Felony', id = 'B18', months = 30, fine = 3000, color = 'red' },
        [44] = { title = 'Contraband', class = 'Misdemeanor', id = 'B19', months = 0, fine = 250, color = 'orange' },
        [45] = { title = 'Indecent Exposure', class = 'Infraction', id = 'C1', months = 0, fine = 750, color = 'blue' },
        [46] = { title = 'Sexual Assault', class = 'Misdemeanor', id = 'C2', months = 30, fine = 3000, color = 'orange' },
        [47] = { title = 'Stalking', class = 'Felony', id = 'C3', months = 60, fine = 5000, color = 'red' },
        [48] = { title = 'Bribery', class = 'Felony', id = 'D1', months = 40, fine = 5000, color = 'red' },
        [49] = { title = 'Failure to Pay a Fine', class = 'Misdemeanor', id = 'D2', months = 5, fine = 500, color = 'orange' },
        [50] = { title = 'Contempt of Court', class = 'Misdemeanor', id = 'D3', months = 240, fine = 20000, color = 'orange' },
        [51] = { title = 'Subpoena Violation', class = 'Misdemeanor', id = 'D4', months = 240, fine = 20000, color = 'orange' },
        [52] = { title = 'Dissuading a Witness or Victim', class = 'Felony', id = 'D5', months = 60, fine = 5000, color = 'red' },
        [53] = { title = 'False Information to a Government Employee', class = 'Misdemeanor', id = 'D6', months = 15, fine = 2500, color = 'orange' },
        [54] = { title = 'Filing a False Complaint', class = 'Misdemeanor', id = 'D7', months = 15, fine = 2500, color = 'orange' },
        [55] = { title = 'Perjury', class = 'Felony', id = 'D8', months = 60, fine = 7500, color = 'red' },
        [56] = { title = 'Failure to Identify to a Peace Officer', class = 'Misdemeanor', id = 'D9', months = 10, fine = 1200, color = 'orange' },
        [57] = { title = 'Impersonation of a Government Employee', class = 'Misdemeanor', id = 'D10', months = 30, fine = 5000, color = 'orange' },
        [58] = { title = 'Obstruction of a Government Employee', class = 'Misdemeanor', id = 'D11', months = 15, fine = 2500, color = 'orange' },
        [59] = { title = 'Resisting a Peace Officer', class = 'Misdemeanor', id = 'D12', months = 15, fine = 2000, color = 'orange' },
        [60] = { title = 'Escape from Custody', class = 'Felony', id = 'D13', months = 50, fine = 7500, color = 'red' },
        [61] = { title = 'Escape', class = 'Felony', id = 'D14', months = 50, fine = 7500, color = 'red' },
        [62] = { title = 'Misuse of a Government Hotline', class = 'Infraction', id = 'D16', months = 0, fine = 1000, color = 'blue' },
        [63] = { title = 'Tampering with Evidence', class = 'Felony', id = 'D17', months = 20, fine = 3000, color = 'red' },
        [64] = { title = 'Introduction of Contraband', class = 'Felony', id = 'D18', months = 40, fine = 5000, color = 'red' },
        [65] = { title = 'Violation of Parole or Probation', class = 'Felony', id = 'D19', months = 30, fine = 2500, color = 'red' },
        [66] = { title = 'Voter Fraud/Voter Pandering', class = 'Felony', id = 'D20', months = 40, fine = 3000, color = 'red' },
        [67] = { title = 'Corruption of Public Duty', class = 'Felony', id = 'D21', months = 200, fine = 20000, color = 'red' },
        [68] = { title = 'Corruption of Public Office', class = 'Felony', id = 'D22', months = 200, fine = 20000, color = 'red' },
        [69] = { title = 'Filing a False Claim/Fraud', class = 'Felony', id = 'D23', months = 30, fine = 2500, color = 'red' },
        [70] = { title = 'Disturbing the Peace', class = 'Misdemeanor', id = 'E1', months = 15, fine = 1200, color = 'orange' },
        [71] = { title = 'Unlawful Assembly', class = 'Misdemeanor', id = 'E2', months = 20, fine = 1500, color = 'orange' },
        [72] = { title = 'Incitement to Riot', class = 'Felony', id = 'E3', months = 30, fine = 5000, color = 'red' },
        [73] = { title = 'Vigilantism', class = 'Felony', id = 'E4', months = 30, fine = 6000, color = 'red' },
        [74] = { title = 'Terrorism', class = 'Felony', id = 'E5', months = 999, fine = 0, color = 'red' },
        [75] = { title = 'Aiding and Abetting', class = 'Misdemeanor', id = 'E6', months = 25, fine = 1000, color = 'orange' },
        [76] = { title = 'Terroristic Threats', class = 'Felony', id = 'E7', months = 50, fine = 5000, color = 'red' },
        [77] = { title = 'Communicating a Threat', class = 'Misdemeanor', id = 'E8', months = 15, fine = 1500, color = 'orange' },
        [78] = { title = 'Possession of a Controlled Substance', class = 'Misdemeanor', id = 'F1', months = 10, fine = 1200, color = 'orange' },
        [79] = { title = 'Possession of a Controlled Substance with Intent to Sell', class = 'Felony', id = 'F2', months = 30, fine = 5000, color = 'red' },
        [80] = { title = 'Possession of Drug Paraphernalia', class = 'Felony', id = 'F3', months = 40, fine = 15000, color = 'blue' },
        [81] = { title = 'Maintaining a Place for Purpose of Distribution', class = 'Felony', id = 'F4', months = 15, fine = 2000, color = 'red' },
        [82] = { title = 'Manufacture of a Controlled Substance', class = 'Felony', id = 'F5', months = 30, fine = 5000, color = 'red' },
        [83] = { title = 'Sale of a Controlled Substance', class = 'Felony', id = 'F6', months = 30, fine = 5000, color = 'red' },
        [84] = { title = 'Possession of an Open Container', class = 'Infraction', id = 'F7', months = 0, fine = 500, color = 'blue' },
        [85] = { title = 'Public Intoxication', class = 'Misdemeanor', id = 'F8', months = 10, fine = 1500, color = 'orange' },
        [86] = { title = 'Under the Influence of a Controlled Substance', class = 'Misdemeanor', id = 'F9', months = 10, fine = 1200, color = 'orange' },
        [87] = { title = 'Possession of Marijuana (See Penal Code)', class = 'Modifier', id = 'F10', months = 0, fine = 0, color = 'yellow' },
        [88] = { title = 'Animal Abuse/Cruelty', class = 'Felony', id = 'G1', months = 20, fine = 2500, color = 'red' },
        [89] = { title = 'Animal Abuse/Cruelty (Police K9)', class = 'Felony', id = 'G1.1', months = 120, fine = 20000, color = 'red' },
        [90] = { title = 'Hunting/Fishing with a Commercial Vehicle', class = 'Infraction', id = 'G2', months = 0, fine = 1200, color = 'blue' },
        [91] = { title = 'Driving with a Suspended License', class = 'Misdemeanor', id = 'H1', months = 5, fine = 1200, color = 'orange' },
        [92] = { title = 'Evading a Peace Officer', class = 'Misdemeanor', id = 'H2', months = 15, fine = 1500, color = 'orange' },
        [93] = { title = 'Evading a Peace Officer - High Performance Vehicle', class = 'Felony', id = 'H3', months = 40, fine = 3000, color = 'red' },
        [94] = { title = 'Evading a Peace Officer - Oversized Vehicle', class = 'Felony', id = 'H4', months = 30, fine = 2500, color = 'red' },
        [95] = { title = 'Evading a Peace Officer - Naval Vessel', class = 'Felony', id = 'H5', months = 30, fine = 2500, color = 'red' },
        [96] = { title = 'Hit and Run', class = 'Felony', id = 'H6', months = 10, fine = 2000, color = 'red' },
        [97] = { title = 'Reckless Operation of an Offroad or Naval Vehicle', class = 'Misdemeanor', id = 'H7', months = 10, fine = 1000, color = 'orange' },
        [98] = { title = 'Felony Evasion', class = 'Felony', id = 'H8', months = 30, fine = 3000, color = 'red' },
        [99] = { title = 'Possession of a Prohibited Weapon', class = 'Misdemeanor', id = 'I1', months = 10, fine = 1500, color = 'orange' },
        [100] = { title = 'Possession of an Unlicensed Firearm', class = 'Misdemeanor', id = 'I2', months = 20, fine = 1500, color = 'orange' },
        [101] = { title = 'Possession of an Illegal Class 1', class = 'Felony', id = 'I3', months = 25, fine = 5000, color = 'red' },
        [102] = { title = 'Possession of an Automatic Weapon', class = 'Felony', id = 'I4', months = 40, fine = 7500, color = 'red' },
        [103] = { title = 'Unlicensed Distribution of a Weapon', class = 'Felony', id = 'I5', months = 50, fine = 15000, color = 'red' },
        [104] = { title = 'Possession of an Explosive Device', class = 'Felony', id = 'I6', months = 30, fine = 10000, color = 'red' },
        [105] = { title = 'Manufacture or Possession of an Improvised Device', class = 'Felony', id = 'I7', months = 30, fine = 10000, color = 'red' },
        [106] = { title = 'Possession of Weaponry with Intent to Sell', class = 'Felony', id = 'I8', months = 30, fine = 10000, color = 'red' },
        [107] = { title = 'Possession of Explosive Devices with Intent to Sell', class = 'Felony', id = 'I9', months = 50, fine = 15000, color = 'red' },
        [108] = { title = 'Brandishing a Firearm', class = 'Misdemeanor', id = 'I10', months = 10, fine = 1200, color = 'orange' },
        [109] = { title = 'Weapons Discharge Violation', class = 'Misdemeanor', id = 'I11', months = 10, fine = 1200, color = 'orange' },
        [110] = { title = 'Drive by Shooting', class = 'Felony', id = 'I12', months = 30, fine = 3000, color = 'red' },
        [111] = { title = 'CCW/PF Violation', class = 'Misdemeanor', id = 'I13', months = 5, fine = 0, color = 'orange' },
        [112] = { title = 'Possession of Police Issued Equipment', class = 'Felony', id = 'I14', months = 15, fine = 2500, color = 'red' },
        [113] = { title = 'Possession of Police Issued Handgun', class = 'Felony', id = 'I15', months = 40, fine = 7500, color = 'red' },
        [114] = { title = 'Possession of Police Issued Rifles', class = 'Felony', id = 'I16', months = 50, fine = 12000, color = 'red' },
        [115] = { title = 'Exception', class = 'Modifier', id = 'J0', months = 0, fine = 0, color = 'yellow' },
        [116] = { title = 'Attempt', class = 'Modifier', id = 'J1', months = 0, fine = 0, color = 'yellow' },
        [117] = { title = 'Conspiracy', class = 'Modifier', id = 'J2', months = 0, fine = 0, color = 'yellow' },
        [118] = { title = 'Soliciting', class = 'Modifier', id = 'J3', months = 0, fine = 0, color = 'yellow' },
        [119] = { title = 'Government Woker Clause', class = 'Modifier', id = 'J4', months = 0, fine = 0, color = 'yellow' },
        [120] = { title = 'Plea Bargaining/Police Compliance Clause', class = 'Modifier', id = 'J5', months = 0, fine = 0, color = 'yellow' },
        [121] = { title = 'Three-Strikes Vehicle Policy', class = 'Modifier', id = 'J6', months = 0, fine = 0, color = 'yellow' },
        [122] = { title = 'Criminal Accomplice Clause', class = 'Modifier', id = 'J7', months = 0, fine = 0, color = 'yellow' },
        [123] = { title = 'Accessory', class = 'Modifier', id = 'J8', months = 0, fine = 0, color = 'yellow' },
        [124] = { title = 'Gang Crimes Clause', class = 'Modifier', id = 'J9', months = 0, fine = 0, color = 'yellow' },
        [125] = { title = 'Speeding (Excess 5-14)', class = 'Infraction', id = 'K1', months = 0, fine = 250, color = 'blue' },
        [126] = { title = 'Speeding (Excess 15-29)', class = 'Infraction', id = 'K2', months = 0, fine = 500, color = 'blue' },
        [127] = { title = 'Speeding (30+)', class = 'Infraction', id = 'K3', months = 0, fine = 1200, color = 'blue' },
        [128] = { title = 'Failure to Abide by a Traffic Control Device', class = 'Infraction', id = 'K4', months = 0, fine = 400, color = 'blue' },
        [129] = { title = 'Yield Violation', class = 'Infraction', id = 'K5', months = 0, fine = 1500, color = 'blue' },
        [130] = { title = 'Parking Violation', class = 'Infraction', id = 'K6', months = 0, fine = 500, color = 'blue' },
        [131] = { title = 'Reckless Driving', class = 'Infraction', id = 'K7', months = 0, fine = 2000, color = 'blue' },
        [132] = { title = 'Aggravated Reckless Driving', class = 'Misdemeanor', id = 'K8', months = 10, fine = 4000, color = 'orange' },
        [133] = { title = 'Vehicular Noise Violation', class = 'Infraction', id = 'K9', months = 0, fine = 1000, color = 'blue' },
        [134] = { title = 'Illegal Nitrious Oxide Possession', class = 'Misdemeanor', id = 'K10', months = 10, fine = 2500, color = 'orange' },
        [135] = { title = 'Illegal use of Hydraulics', class = 'Infraction', id = 'K11', months = 0, fine = 1200, color = 'blue' },
        [136] = { title = 'Driving While Impaired (DWI)', class = 'Misdemeanor', id = 'K12', months = 10, fine = 1200, color = 'orange' },
        [137] = { title = 'Driving under the Influence (DUI)', class = 'Felony', id = 'K13', months = 20, fine = 2500, color = 'red' },
        [138] = { title = 'Registration Violation', class = 'Infraction', id = 'K14', months = 0, fine = 500, color = 'blue' },
        [139] = { title = 'Unsafe Usage of a Bicycle', class = 'Infraction', id = 'K15', months = 0, fine = 1200, color = 'blue' },
        [140] = { title = 'Street Racing', class = 'Misdemeanor', id = 'K16', months = 20, fine = 2000, color = 'orange' },
        [141] = { title = 'Driving without a Valid License', class = 'Misdemeanor', id = 'K17', months = 20, fine = 1500, color = 'orange' },
        [142] = { title = 'Jaywalking', class = 'Infraction', id = 'K18', months = 0, fine = 500, color = 'blue' },
        [143] = { title = 'Tinted Windows', class = 'Infraction', id = 'K19', months = 0, fine = 500, color = 'blue' },
        [144] = { title = 'Unlawful Transport of a Person(s) in a Cargo Area', class = 'Infraction', id = 'K20', months = 0, fine = 1000, color = 'blue' },
        [145] = { title = 'Fire Hydrant Parking Restriction', class = 'Infraction', id = 'K21', months = 0, fine = 1200, color = 'blue' },
        [146] = { title = 'Operation of an ATV within City Limits', class = 'Infraction', id = 'K22', months = 0, fine = 1200, color = 'blue' },
        [147] = { title = 'Laundering of Money Instruments', class = 'Felony', id = 'M2', months = 0, fine = 0, color = 'red' },
        [148] = { title = 'Gambling License Violation', class = 'Felony', id = 'M3', months = 40, fine = 6000, color = 'red' },
        [149] = { title = 'Legal Practice Violation', class = 'Misdemeanor', id = 'M4', months = 20, fine = 3000, color = 'orange' },
        [150] = { title = 'Wire Tapping ', class = 'Felony', id = 'M5', months = 15, fine = 4000, color = 'red' },
        [151] = { title = 'Criminal Business Operations', class = 'Misdemeanor', id = 'M6', months = 0, fine = 500, color = 'orange' },
        [152] = { title = 'Corporate Hijacking', class = 'Misdemeanor', id = 'M7', months = 30, fine = 5000, color = 'orange' },
        [153] = { title = 'Embezzlement', class = 'Felony', id = 'M8', months = 0, fine = 0, color = 'red' },
        [154] = { title = 'Possession of Illegal Narcotics', class = 'Felony', id = 'A26', months = 15, fine = 6000, color = 'blue' },
        [155] = { title = 'Arms Trafficking', class = 'Felony', id = 'A27', months = 35, fine = 15000, color = 'red' },
        [156] = { title = 'Money Laundering', class = 'Felony', id = 'A28', months = 75, fine = 35000, color = 'blue' },
        [157] = { title = 'Arson', class = 'Felony', id = 'A29', months = 50, fine = 20000, color = 'blue' },
        [158] = { title = 'Kidnapping of a Government Offical', class = 'Felony', id = 'A30', months = 45, fine = 25000, color = 'red' },
        [159] = { title = 'Possession of Counterfit Money', class = 'Felony', id = 'A31', months = 25, fine = 10000, color = 'blue' },
        [160] = { title = 'Possession of a Illegal Melee weapon', class = 'Felony', id = 'A32', months = 15, fine = 5000, color = 'red' },
        [161] = { title = 'Tax Evasion', class = 'Felony', id = 'A33', months = 55, fine = 30000, color = 'red' },
        [162] = { title = 'Armed Bank Robbery', class = 'Felony', id = 'A34', months = 50, fine = 10000, color = 'red' },
        [163] = { title = 'Armed Bank Truck', class = 'Felony', id = 'A35', months = 60, fine = 15000, color = 'red' },
        [164] = { title = 'Armed Bobcat Robbery', class = 'Felony', id = 'A36', months = 70, fine = 20000, color = 'red' },
        }
}

Config["StaffLogs"] = {
    ["NewBulletin"] = "%s Created New Bulletin.",
    ["DeleteBulletin"] = "%s Deleted Bulletin.",
    ["NewIncident"] = "%s Created New Incident.",
    ["EditIncident"] = "%s Edited Incident.",
    ["DeleteIncident"] = "%s Deleted Incident.",
    ["NewReport"] = "%s Created New Report.",
    ["EditReport"] = "%s Edited Report.",
    ["DeleteReport"] = "%s Deleted Report.",
    ["NewBolo"] = "%s Created New Bolo.",
    ["EditBolo"] = "%s Edited Bolo.",
    ["DeleteBolo"] = "%s Deleted Bolo.",
}
