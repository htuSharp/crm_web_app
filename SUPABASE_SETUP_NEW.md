# CRM Web App - Supabase Database Setup

This document contains all the SQL queries needed to set up the Supabase database for the CRM Web App.

## Prerequisites
1. Create a Supabase account at https://supabase.com
2. Create a new project in Supabase
3. Get your project URL and anon key from Project Settings > API

## Database Schema Overview

The CRM system uses the following main tables:
- `headquarters` - Company headquarters/branches
- `specialties` - Medical specialties 
- `areas` - Geographical areas linked to headquarters
- `medical_representatives` - MR data with multi-select support
- `doctors` - Doctor information
- `medical_facilities` - Medical facilities/hospitals
- `stockists` - Stockist/distributor information

## Setup Options

### Option 1: Complete Setup (Recommended for New Projects)

Use the `database_schema.sql` file for a complete one-time setup:

1. Go to your Supabase project dashboard
2. Navigate to the SQL Editor
3. Copy and paste the contents of `database_schema.sql`
4. Click "Run" to execute all queries

**Note:** This option may fail if tables or policies already exist.

### Option 2: Safe Setup (Recommended for Existing Projects)

Use the safe setup files that can be run multiple times without conflicts:

#### Step 1: Core Schema Setup
1. Copy and paste the contents of `safe_schema_setup.sql`
2. Click "Run" to create tables, indexes, and triggers

#### Step 2: RLS Policies Setup (Optional)
1. Copy and paste the contents of `rls_policies.sql`
2. Click "Run" to create Row Level Security policies

## Verification Steps

### Step 1: Verify Setup

After running the schema, verify that all tables were created successfully:

```sql
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
ORDER BY table_name;
```

### Step 2: Check Sample Data

Verify that sample data was inserted:

```sql
SELECT 'headquarters' as table_name, count(*) as record_count FROM headquarters
UNION ALL
SELECT 'specialties', count(*) FROM specialties  
UNION ALL
SELECT 'areas', count(*) FROM areas
UNION ALL
SELECT 'medical_representatives', count(*) FROM medical_representatives
UNION ALL
SELECT 'doctors', count(*) FROM doctors
UNION ALL
SELECT 'medical_facilities', count(*) FROM medical_facilities
UNION ALL
SELECT 'stockists', count(*) FROM stockists;
```

## Key Database Features

### Multi-Select Support for Medical Representatives
- `area_names TEXT[]` - Array of area names for multi-select
- `headquarters TEXT[]` - Array of headquarters names for multi-select

### Headquarters-Area Relationships
- Areas are linked to specific headquarters
- Dynamic filtering in forms based on headquarters selection

### Enhanced Table Structure
1. **medical_representatives** - Multi-select arrays for areas and headquarters
2. **doctors** - Single headquarters assignment
3. **stockists** - Single headquarters assignment  
4. **medical_facilities** - Existing structure maintained
5. **areas** - Links areas to headquarters
6. **specialties** - Medical specialties lookup
7. **headquarters** - Headquarters lookup table

## Application Configuration

Update `lib/config/supabase_config.dart` with your actual values:
```dart
static const String supabaseUrl = 'https://your-project-ref.supabase.co';
static const String supabaseAnonKey = 'your-anon-key-here';
```

## Migration from Existing Database

If you have an existing database, you'll need to migrate:

### Medical Representatives Migration
```sql
-- Add new columns if upgrading from single-select
ALTER TABLE medical_representatives 
ADD COLUMN IF NOT EXISTS area_names TEXT[] DEFAULT '{}',
ADD COLUMN IF NOT EXISTS headquarters TEXT[] DEFAULT '{}';

-- Migrate existing data (if you had area_name and headquarter columns)
UPDATE medical_representatives 
SET area_names = ARRAY[area_name], 
    headquarters = ARRAY[headquarter] 
WHERE area_name IS NOT NULL AND headquarter IS NOT NULL;
```

### Doctors/Stockists Migration
```sql
-- Add headquarters column if missing
ALTER TABLE doctors ADD COLUMN IF NOT EXISTS headquarter VARCHAR(255);
ALTER TABLE stockists ADD COLUMN IF NOT EXISTS headquarter VARCHAR(255);
```

## Testing the Setup

After running the schema, test the application:

1. Run the Flutter app: `flutter run -d web`
2. Navigate to Data Management page
3. Add test data:
   - Create headquarters (Mumbai HQ, Delhi HQ, etc.)
   - Add areas linked to headquarters
   - Add specialties
   - Create MRs with multi-select headquarters and areas
   - Add doctors and stockists with headquarters selection
4. Verify data appears in your Supabase dashboard
5. Test multi-select functionality in MR dialogs

## Troubleshooting

### Common Issues

1. **PostgreSQL Policy Errors**: PostgreSQL doesn't support `CREATE POLICY IF NOT EXISTS`
   - Solution: Use the safe setup files or manually drop policies before creating

2. **Array Field Issues**: Use proper PostgreSQL array syntax
   - Correct: `'{"item1", "item2"}'`
   - Incorrect: `["item1", "item2"]`

3. **RLS Policy Conflicts**: Ensure policies are created after enabling RLS
   - Solution: Use the `rls_policies.sql` file which handles this properly

4. **Trigger Errors**: PostgreSQL may have existing triggers
   - Solution: The safe setup files use `DROP TRIGGER IF EXISTS` before creating

### Policy Management

PostgreSQL policy management requires special handling:

```sql
-- Always drop existing policies before creating new ones
DROP POLICY IF EXISTS "policy_name" ON table_name;
CREATE POLICY "policy_name" ON table_name FOR ALL USING (condition);
```

### Verification Queries

Check table structure:
```sql
SELECT table_name, column_name, data_type 
FROM information_schema.columns 
WHERE table_schema = 'public' 
ORDER BY table_name, ordinal_position;
```

Verify RLS is enabled:
```sql
SELECT schemaname, tablename, rowsecurity 
FROM pg_tables 
WHERE schemaname = 'public';
```

Check policies:
```sql
SELECT tablename, policyname, permissive, roles, cmd, qual 
FROM pg_policies 
WHERE schemaname = 'public';
```

## Security Considerations

The current setup uses permissive RLS policies for development. For production:

1. **User Authentication**: Implement proper user roles
2. **Restrictive Policies**: Create role-based RLS policies
3. **Data Validation**: Add database constraints and triggers
4. **Audit Logging**: Track data changes
5. **Backup Strategy**: Set up automated backups

### Example Production Policy
```sql
-- Restrict access based on user's assigned headquarters
CREATE POLICY "users_own_headquarters_data" ON medical_representatives
FOR ALL USING (
    EXISTS (
        SELECT 1 FROM user_headquarters uh 
        WHERE uh.user_id = auth.uid() 
        AND uh.headquarter = ANY(medical_representatives.headquarters)
    )
);
```

## Next Steps

1. **Deploy Schema**: Choose either complete or safe setup approach
2. **Update Configuration**: Set your Supabase URL and keys
3. **Test Application**: Run the Flutter app and verify functionality
4. **Customize Security**: Adjust RLS policies for your requirements
5. **Add Sample Data**: Create test data through the application
6. **Monitor Performance**: Add indexes as needed for large datasets

For additional support, refer to the [Supabase Documentation](https://supabase.com/docs) or the application's README file.
