-- CRM Web App - Row Level Security Policies
-- Run this AFTER the main schema setup
-- This file manages RLS policies separately for easier maintenance

-- ================================================================================
-- WARNING: POLICY MANAGEMENT
-- ================================================================================
-- PostgreSQL doesn't support "CREATE POLICY IF NOT EXISTS"
-- These policies will create new ones each time if names change
-- To avoid conflicts, either:
-- 1. Run this only once after schema setup
-- 2. Or manually drop policies before running this again
-- 3. Or use the management functions below

-- ================================================================================
-- POLICY MANAGEMENT FUNCTIONS
-- ================================================================================

-- Function to safely create policies
CREATE OR REPLACE FUNCTION create_policy_safe(
    policy_name TEXT,
    table_name TEXT,
    policy_command TEXT,
    policy_role TEXT DEFAULT 'public',
    policy_expression TEXT DEFAULT 'true'
)
RETURNS TEXT AS $$
DECLARE
    policy_exists BOOLEAN;
    full_query TEXT;
BEGIN
    -- Check if policy exists
    SELECT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE schemaname = 'public' 
        AND tablename = table_name 
        AND policyname = policy_name
    ) INTO policy_exists;
    
    IF policy_exists THEN
        RETURN 'Policy ' || policy_name || ' already exists on ' || table_name;
    ELSE
        -- Create the policy
        full_query := format('CREATE POLICY %I ON %I FOR %s TO %s USING (%s)',
            policy_name, table_name, policy_command, policy_role, policy_expression);
        EXECUTE full_query;
        RETURN 'Policy ' || policy_name || ' created successfully on ' || table_name;
    END IF;
END;
$$ LANGUAGE plpgsql;

-- Function to drop all policies for a table
CREATE OR REPLACE FUNCTION drop_all_policies(table_name TEXT)
RETURNS TEXT AS $$
DECLARE
    policy_record RECORD;
    result_count INTEGER := 0;
BEGIN
    FOR policy_record IN 
        SELECT policyname FROM pg_policies 
        WHERE schemaname = 'public' AND tablename = table_name
    LOOP
        EXECUTE format('DROP POLICY %I ON %I', policy_record.policyname, table_name);
        result_count := result_count + 1;
    END LOOP;
    
    RETURN 'Dropped ' || result_count || ' policies from ' || table_name;
END;
$$ LANGUAGE plpgsql;

-- ================================================================================
-- OPTION 1: CREATE POLICIES (simple approach)
-- ================================================================================
-- Uncomment this section if you want to create basic policies
-- WARNING: This will fail if policies already exist with same names

/*
-- Headquarters policies
CREATE POLICY "Enable all operations for headquarters" ON headquarters FOR ALL TO public USING (true);

-- Specialties policies  
CREATE POLICY "Enable all operations for specialties" ON specialties FOR ALL TO public USING (true);

-- Areas policies
CREATE POLICY "Enable all operations for areas" ON areas FOR ALL TO public USING (true);

-- Medical Representatives policies
CREATE POLICY "Enable all operations for medical_representatives" ON medical_representatives FOR ALL TO public USING (true);

-- Doctors policies
CREATE POLICY "Enable all operations for doctors" ON doctors FOR ALL TO public USING (true);

-- Medical Facilities policies
CREATE POLICY "Enable all operations for medical_facilities" ON medical_facilities FOR ALL TO public USING (true);

-- Stockists policies
CREATE POLICY "Enable all operations for stockists" ON stockists FOR ALL TO public USING (true);
*/

-- ================================================================================
-- OPTION 2: SAFE POLICY CREATION (recommended)
-- ================================================================================
-- Use the safe function to create policies

SELECT create_policy_safe('enable_all_headquarters', 'headquarters', 'ALL', 'public', 'true');
SELECT create_policy_safe('enable_all_specialties', 'specialties', 'ALL', 'public', 'true');
SELECT create_policy_safe('enable_all_areas', 'areas', 'ALL', 'public', 'true');
SELECT create_policy_safe('enable_all_medical_representatives', 'medical_representatives', 'ALL', 'public', 'true');
SELECT create_policy_safe('enable_all_doctors', 'doctors', 'ALL', 'public', 'true');
SELECT create_policy_safe('enable_all_medical_facilities', 'medical_facilities', 'ALL', 'public', 'true');
SELECT create_policy_safe('enable_all_stockists', 'stockists', 'ALL', 'public', 'true');

-- ================================================================================
-- POLICY MANAGEMENT COMMANDS (for future use)
-- ================================================================================

-- To view all policies:
-- SELECT schemaname, tablename, policyname, permissive, roles, cmd, qual 
-- FROM pg_policies WHERE schemaname = 'public';

-- To drop all policies from a specific table:
-- SELECT drop_all_policies('headquarters');
-- SELECT drop_all_policies('specialties');
-- SELECT drop_all_policies('areas');
-- SELECT drop_all_policies('medical_representatives');
-- SELECT drop_all_policies('doctors');
-- SELECT drop_all_policies('medical_facilities');
-- SELECT drop_all_policies('stockists');

-- To recreate policies after dropping:
-- Just run the OPTION 2 section again

-- ================================================================================
-- SUCCESS MESSAGE
-- ================================================================================

SELECT 'RLS policies setup completed successfully!' as status;
