-- CRM Web App Database Schema
-- This file contains all the SQL commands needed to set up the Supabase database
-- for the CRM Web App with support for multi-select headquarters and areas for MRs

-- ================================================================================
-- DROP EXISTING TABLES (if they exist) - Use with caution in production
-- ================================================================================

-- Uncomment the following lines if you need to recreate tables
-- DROP TABLE IF EXISTS medical_representatives CASCADE;
-- DROP TABLE IF EXISTS doctors CASCADE;
-- DROP TABLE IF EXISTS medical_facilities CASCADE;
-- DROP TABLE IF EXISTS stockists CASCADE;
-- DROP TABLE IF EXISTS areas CASCADE;
-- DROP TABLE IF EXISTS specialties CASCADE;
-- DROP TABLE IF EXISTS headquarters CASCADE;

-- ================================================================================
-- CREATE TABLES
-- ================================================================================

-- 1. Headquarters Table
CREATE TABLE IF NOT EXISTS headquarters (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 2. Specialties Table
CREATE TABLE IF NOT EXISTS specialties (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 3. Areas Table (depends on headquarters)
CREATE TABLE IF NOT EXISTS areas (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    area VARCHAR(255) NOT NULL,
    headquarter VARCHAR(255) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    UNIQUE(area, headquarter)
);

-- 4. Medical Representatives Table (updated for multi-select)
CREATE TABLE IF NOT EXISTS medical_representatives (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    age INTEGER,
    sex VARCHAR(10),
    phone_no VARCHAR(20) NOT NULL,
    address TEXT,
    area_names TEXT[] DEFAULT '{}', -- Array of area names for multi-select
    account_number VARCHAR(50),
    bank_name VARCHAR(255),
    ifsc_code VARCHAR(20),
    headquarters TEXT[] DEFAULT '{}', -- Array of headquarters for multi-select
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 5. Doctors Table (with headquarters field)
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

-- 6. Medical Facilities Table
CREATE TABLE IF NOT EXISTS medical_facilities (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    headquarter VARCHAR(255) NOT NULL,
    area VARCHAR(255) NOT NULL,
    contact_person VARCHAR(255) NOT NULL,
    phone_no VARCHAR(20) NOT NULL,
    address TEXT NOT NULL,
    attached_doctor VARCHAR(255) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 7. Stockists Table (with headquarters field)
CREATE TABLE IF NOT EXISTS stockists (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    company VARCHAR(255) NOT NULL,
    contact VARCHAR(255) NOT NULL, -- Contact information
    address TEXT NOT NULL,
    area VARCHAR(255) NOT NULL,
    headquarter VARCHAR(255) NOT NULL, -- Added headquarters field
    license_number VARCHAR(100),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- ================================================================================
-- CREATE INDEXES FOR PERFORMANCE
-- ================================================================================

-- Headquarters indexes
CREATE INDEX IF NOT EXISTS idx_headquarters_name ON headquarters(name);

-- Specialties indexes
CREATE INDEX IF NOT EXISTS idx_specialties_name ON specialties(name);

-- Areas indexes
CREATE INDEX IF NOT EXISTS idx_areas_area ON areas(area);
CREATE INDEX IF NOT EXISTS idx_areas_headquarter ON areas(headquarter);

-- Medical Representatives indexes
CREATE INDEX IF NOT EXISTS idx_mrs_name ON medical_representatives(name);
CREATE INDEX IF NOT EXISTS idx_mrs_phone ON medical_representatives(phone_no);
CREATE INDEX IF NOT EXISTS idx_mrs_area_names ON medical_representatives USING GIN(area_names);
CREATE INDEX IF NOT EXISTS idx_mrs_headquarters ON medical_representatives USING GIN(headquarters);

-- Doctors indexes
CREATE INDEX IF NOT EXISTS idx_doctors_name ON doctors(name);
CREATE INDEX IF NOT EXISTS idx_doctors_specialty ON doctors(specialty);
CREATE INDEX IF NOT EXISTS idx_doctors_area ON doctors(area);
CREATE INDEX IF NOT EXISTS idx_doctors_headquarter ON doctors(headquarter);
CREATE INDEX IF NOT EXISTS idx_doctors_phone ON doctors(phone_no);

-- Medical Facilities indexes
CREATE INDEX IF NOT EXISTS idx_medicals_name ON medical_facilities(name);
CREATE INDEX IF NOT EXISTS idx_medicals_area ON medical_facilities(area);
CREATE INDEX IF NOT EXISTS idx_medicals_headquarter ON medical_facilities(headquarter);
CREATE INDEX IF NOT EXISTS idx_medicals_doctor ON medical_facilities(attached_doctor);

-- Stockists indexes
CREATE INDEX IF NOT EXISTS idx_stockists_name ON stockists(name);
CREATE INDEX IF NOT EXISTS idx_stockists_company ON stockists(company);
CREATE INDEX IF NOT EXISTS idx_stockists_area ON stockists(area);
CREATE INDEX IF NOT EXISTS idx_stockists_headquarter ON stockists(headquarter);

-- ================================================================================
-- ENABLE ROW LEVEL SECURITY (RLS)
-- ================================================================================

ALTER TABLE headquarters ENABLE ROW LEVEL SECURITY;
ALTER TABLE specialties ENABLE ROW LEVEL SECURITY;
ALTER TABLE areas ENABLE ROW LEVEL SECURITY;
ALTER TABLE medical_representatives ENABLE ROW LEVEL SECURITY;
ALTER TABLE doctors ENABLE ROW LEVEL SECURITY;
ALTER TABLE medical_facilities ENABLE ROW LEVEL SECURITY;
ALTER TABLE stockists ENABLE ROW LEVEL SECURITY;

-- ================================================================================
-- CREATE RLS POLICIES (PERMISSIVE FOR NOW - ADJUST FOR PRODUCTION)
-- ================================================================================

-- Drop existing policies if they exist (to avoid conflicts)
DROP POLICY IF EXISTS "Enable all operations for authenticated users" ON headquarters;
DROP POLICY IF EXISTS "Enable all operations for authenticated users" ON specialties;
DROP POLICY IF EXISTS "Enable all operations for authenticated users" ON areas;
DROP POLICY IF EXISTS "Enable all operations for authenticated users" ON medical_representatives;
DROP POLICY IF EXISTS "Enable all operations for authenticated users" ON doctors;
DROP POLICY IF EXISTS "Enable all operations for authenticated users" ON medical_facilities;
DROP POLICY IF EXISTS "Enable all operations for authenticated users" ON stockists;

-- Headquarters policies
CREATE POLICY "Enable all operations for authenticated users" ON headquarters
FOR ALL USING (true);

-- Specialties policies
CREATE POLICY "Enable all operations for authenticated users" ON specialties
FOR ALL USING (true);

-- Areas policies
CREATE POLICY "Enable all operations for authenticated users" ON areas
FOR ALL USING (true);

-- Medical Representatives policies
CREATE POLICY "Enable all operations for authenticated users" ON medical_representatives
FOR ALL USING (true);

-- Doctors policies
CREATE POLICY "Enable all operations for authenticated users" ON doctors
FOR ALL USING (true);

-- Medical Facilities policies
CREATE POLICY "Enable all operations for authenticated users" ON medical_facilities
FOR ALL USING (true);

-- Stockists policies
CREATE POLICY "Enable all operations for authenticated users" ON stockists
FOR ALL USING (true);

-- ================================================================================
-- CREATE UPDATE TRIGGERS FOR AUTOMATIC TIMESTAMP MANAGEMENT
-- ================================================================================

-- Create function to update updated_at column
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = timezone('utc'::text, now());
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create triggers for all tables
DROP TRIGGER IF EXISTS update_headquarters_updated_at ON headquarters;
CREATE TRIGGER update_headquarters_updated_at BEFORE UPDATE ON headquarters
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_specialties_updated_at ON specialties;
CREATE TRIGGER update_specialties_updated_at BEFORE UPDATE ON specialties
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_areas_updated_at ON areas;
CREATE TRIGGER update_areas_updated_at BEFORE UPDATE ON areas
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_medical_representatives_updated_at ON medical_representatives;
CREATE TRIGGER update_medical_representatives_updated_at BEFORE UPDATE ON medical_representatives
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_doctors_updated_at ON doctors;
CREATE TRIGGER update_doctors_updated_at BEFORE UPDATE ON doctors
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_medical_facilities_updated_at ON medical_facilities;
CREATE TRIGGER update_medical_facilities_updated_at BEFORE UPDATE ON medical_facilities
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_stockists_updated_at ON stockists;
CREATE TRIGGER update_stockists_updated_at BEFORE UPDATE ON stockists
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ================================================================================
-- OPTIONAL: SAMPLE DATA FOR TESTING
-- ================================================================================

-- Insert sample headquarters
INSERT INTO headquarters (name) VALUES 
    ('Mumbai'),
    ('Delhi'),
    ('Bangalore'),
    ('Chennai')
ON CONFLICT (name) DO NOTHING;

-- Insert sample specialties
INSERT INTO specialties (name) VALUES 
    ('Cardiology'),
    ('Orthopedics'),
    ('Neurology'),
    ('Pediatrics'),
    ('General Medicine')
ON CONFLICT (name) DO NOTHING;

-- Insert sample areas
INSERT INTO areas (area, headquarter) VALUES 
    ('Andheri', 'Mumbai'),
    ('Bandra', 'Mumbai'),
    ('Connaught Place', 'Delhi'),
    ('Karol Bagh', 'Delhi'),
    ('Koramangala', 'Bangalore'),
    ('Whitefield', 'Bangalore'),
    ('T. Nagar', 'Chennai'),
    ('Anna Nagar', 'Chennai')
ON CONFLICT (area, headquarter) DO NOTHING;

-- ================================================================================
-- VERIFICATION QUERIES
-- ================================================================================

-- Run these queries to verify the setup
-- SELECT 'Tables created successfully' as status;
-- SELECT table_name FROM information_schema.tables WHERE table_schema = 'public' AND table_type = 'BASE TABLE';
-- SELECT * FROM headquarters;
-- SELECT * FROM specialties;
-- SELECT * FROM areas;
