class SupabaseConfig {
  // Replace these with your actual Supabase project URL and anon key
  static const String supabaseUrl = 'https://jrbnfurhlvhorzstesgz.supabase.co';
  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImpyYm5mdXJobHZob3J6c3Rlc2d6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTQ1OTM4MDMsImV4cCI6MjA3MDE2OTgwM30.FD7vkhHr5ERAc4x64njYIlA2cZ17T_kkKG-G83nLPX4';

  // Table names for each management section
  static const String doctorsTable = 'doctors';
  static const String areasTable = 'areas';
  static const String specialtiesTable = 'specialties';
  static const String mrsTable = 'medical_representatives';
  static const String medicalsTable = 'medical_facilities';
  static const String stockistsTable = 'stockists';
  static const String headquartersTable = 'headquarters';
}
