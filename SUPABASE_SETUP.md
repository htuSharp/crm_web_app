# Supabase Setup Guide for CRM Web App

## Prerequisites
1. Create a Supabase account at https://supabase.com
2. Create a new project in Supabase
3. Get your project URL and anon key from Project Settings > API

##### Common Issues

1. **RLS Policy Errors**: Ensure policies are created after enabling RLS
2. **Policy Creation Conflicts**: PostgreSQL doesn't support `IF NOT EXISTS` for policies - drop existing policies first
3. **Array Field Issues**: Use proper array syntax: `'{"item1", "item2"}'`
4. **Trigger Errors**: Drop existing triggers before recreating
5. **Index Conflicts**: Use `IF NOT EXISTS` clauses for tables and indexes only

### Policy Management
```sql
-- Always drop existing policies before creating new ones
DROP POLICY IF EXISTS "policy_name" ON table_name;
CREATE POLICY "policy_name" ON table_name FOR ALL USING (condition);
```guration
1. Update `lib/config/supabase_config.dart` with your actual values:
   --dart
   static const String supabaseUrl = 'https://your-project-ref.supabase.co';
   static const String supabaseAnonKey = 'your-anon-key-here';
   --

## Database Schema Setup

--###-- Quick Setup (Recommended)
Run the complete schema file provided in the project root:
1. Copy the contents of `database_schema.sql` file
2. Go to your Supabase project > SQL Editor
3. Paste and execute the entire script

This will create all required tables with:
- Multi-select support for MR headquarters and areas
- Proper indexes for performance
- Row Level Security (RLS) policies
- Automatic timestamp triggers
- Sample data for testing

--###-- Current Database Structure

The application now supports the following enhanced features:
- **Multi-select MR Management**: Medical Representatives can be assigned to multiple headquarters and areas
- **Headquarters-Area Relationships**: Areas are linked to specific headquarters
- **Enhanced Dropdowns**: Dynamic filtering of areas based on selected headquarters

--###--# Updated Tables Structure:

1. **medical_representatives** - Enhanced for multi-select
   - `area_names TEXT[]` - Array of area names
   - `headquarters TEXT[]` - Array of headquarters names

2. **doctors** - Added headquarters field
   - `headquarter VARCHAR(255)` - Single headquarters assignment

3. **stockists** - Added headquarters field  
   - `headquarter VARCHAR(255)` - Single headquarters assignment

4. **medical_facilities** - Existing structure maintained

5. **areas** - Links areas to headquarters
   - `area VARCHAR(255)` - Area name
   - `headquarter VARCHAR(255)` - Parent headquarters

6. **specialties** - Medical specialties lookup

7. **headquarters** - Headquarters lookup table

7. **headquarters** - Headquarters lookup table

## Manual Schema Setup (Alternative)

If you prefer to run individual commands, here are the key table creation scripts:

--###-- 1. Medical Representatives Table (Updated for Multi-select)
--sql
CREATE TABLE IF NOT EXISTS medical_representatives (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    age INTEGER,
    sex VARCHAR(10),
    phone_no VARCHAR(20) NOT NULL,
    address TEXT,
    area_names TEXT[] DEFAULT '{}', -- Array for multi-select areas
    account_number VARCHAR(50),
    bank_name VARCHAR(255),
    ifsc_code VARCHAR(20),
    headquarters TEXT[] DEFAULT '{}', -- Array for multi-select headquarters
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);
--

--###-- 2. Doctors Table (Updated with Headquarters)
--sql
CREATE TABLE IF NOT EXISTS doctors (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    specialty VARCHAR(255) NOT NULL,
    area VARCHAR(255) NOT NULL,
    headquarter VARCHAR(255) NOT NULL, -- Added headquarters field
    date_of_birth DATE,
    phone_no VARCHAR(20) NOT NULL,
    marriage_anniversary DATE,
    call_days TEXT[] DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);
--

--###-- 3. Stockists Table (Updated with Headquarters)
--sql
CREATE TABLE IF NOT EXISTS stockists (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    company VARCHAR(255) NOT NULL,
    contact VARCHAR(255) NOT NULL,
    address TEXT NOT NULL,
    area VARCHAR(255) NOT NULL,
    headquarter VARCHAR(255) NOT NULL, -- Added headquarters field
    license_number VARCHAR(100),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);
--

--###-- 4. Areas Table
--sql
CREATE TABLE IF NOT EXISTS areas (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    area VARCHAR(255) NOT NULL,
    headquarter VARCHAR(255) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    UNIQUE(area, headquarter)
);
--

--###-- 5. Other Required Tables
See `database_schema.sql` for complete table definitions including:
- headquarters
- specialties  
- medical_facilities

## Important Migration Notes

--###-- For Existing Databases
If you have an existing database, you'll need to migrate the data:

1. **Medical Representatives Migration**:
   --sql
   -- Add new columns if upgrading from single-select
   ALTER TABLE medical_representatives 
   ADD COLUMN IF NOT EXISTS area_names TEXT[] DEFAULT '{}',
   ADD COLUMN IF NOT EXISTS headquarters TEXT[] DEFAULT '{}';
   
   -- Migrate existing data (if you had area_name and headquarter columns)
   UPDATE medical_representatives 
   SET area_names = ARRAY[area_name], 
       headquarters = ARRAY[headquarter] 
   WHERE area_name IS NOT NULL AND headquarter IS NOT NULL;
   --

2. **Doctors/Stockists Migration**:
   --sql
   -- Add headquarters column if missing
   ALTER TABLE doctors ADD COLUMN IF NOT EXISTS headquarter VARCHAR(255);
   ALTER TABLE stockists ADD COLUMN IF NOT EXISTS headquarter VARCHAR(255);
   --

   ALTER TABLE stockists ADD COLUMN IF NOT EXISTS headquarter VARCHAR(255);
   --

## Testing the Setup

After running the schema, you can test the connection by:

1. Running the Flutter app: `flutter run -d web`
2. Adding test data through the Data Management page:
   - Add headquarters (Mumbai HQ, Delhi HQ, etc.)
   - Add areas linked to headquarters
   - Add specialties
   - Create MRs with multi-select headquarters and areas
   - Add doctors and stockists with headquarters selection
3. Verify data appears in your Supabase dashboard
4. Test the multi-select functionality in MR dialogs

## Application Features

--###-- Multi-Select MR Management
- Medical Representatives can be assigned to multiple headquarters
- Areas are filtered based on selected headquarters  
- Dynamic dropdown interactions
- Chip-based selection display

--###-- Headquarters-Area Relationships
- Areas are linked to specific headquarters
- Cascading dropdowns in all forms
- Consistent data relationships

--###-- Enhanced Data Management
- View record dialogs for detailed information
- Comprehensive search functionality
- Bulk operations support

## Security Considerations

The current setup uses permissive RLS policies. For production, consider:

1. **User Authentication**: Implement proper user roles and authentication
2. **Restrictive Policies**: Create role-based RLS policies
3. **Data Validation**: Add database constraints and triggers
4. **Audit Logging**: Track data changes with audit tables
5. **Backup Strategy**: Set up automated backups
6. **Monitoring**: Enable database monitoring and alerts

--###-- Example Production RLS Policy
--sql
-- Example: Restrict access based on user's assigned headquarters
CREATE POLICY "users_own_headquarters_data" ON medical_representatives
FOR ALL USING (
    EXISTS (
        SELECT 1 FROM user_headquarters uh 
        WHERE uh.user_id = auth.uid() 
        AND uh.headquarter = ANY(medical_representatives.headquarters)
    )
);
--

## Troubleshooting

--###-- Common Issues

1. **RLS Policy Errors**: Ensure policies are created after enabling RLS
2. **Array Field Issues**: Use proper array syntax: `'{"item1", "item2"}'`
3. **Trigger Errors**: Drop existing triggers before recreating
4. **Index Conflicts**: Use `IF NOT EXISTS` clauses

--###-- Verification Queries
--sql
-- Check table structure
SELECT table_name, column_name, data_type 
FROM information_schema.columns 
WHERE table_schema = 'public' 
ORDER BY table_name, ordinal_position;

-- Verify RLS is enabled
SELECT schemaname, tablename, rowsecurity 
FROM pg_tables 
WHERE schemaname = 'public';

-- Check policies
SELECT tablename, policyname, permissive, roles, cmd, qual 
FROM pg_policies 
WHERE schemaname = 'public';
--

## Next Steps

1. **Deploy Schema**: Run the complete `database_schema.sql` in your Supabase project
2. **Update Configuration**: Set your Supabase URL and keys in `lib/config/supabase_config.dart`
3. **Test Application**: Run the Flutter app and test all functionality
4. **Customize Security**: Adjust RLS policies based on your requirements
5. **Add Sample Data**: Use the application to create test data
6. **Performance Optimization**: Monitor query performance and add indexes as needed

For additional support, refer to the [Supabase Documentation](https://supabase.com/docs) or the application's README file.
